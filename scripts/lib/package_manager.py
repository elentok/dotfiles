import json
import os
import re
import sys
from dataclasses import dataclass
from os import path
from typing import Tuple, List, Mapping, Optional

from . import github, helpers

APPS_ROOT = path.expanduser('~/.apps')
APPS_ALL = path.join(APPS_ROOT, 'all')
APPS_BIN = path.join(APPS_ROOT, 'bin')
DOTF = path.join(path.dirname(__file__), '..', '..')
CONFIG_FILENAME = path.join(DOTF, 'config', 'dotf-pkgs.json')


@dataclass
class Platform:
    bin: str
    asset_regexp: re.Pattern

    def __init__(self, raw):
        self.bin = raw['bin']
        self.asset_regexp = re.compile(raw['asset_regexp'])


@dataclass
class Package:
    name: str
    github_repo: str
    version: str
    platforms: Mapping[str, Platform]

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.version = raw['version']
        self.platforms = {k: Platform(v) for k, v in raw['platforms'].items()}
        self.path = path.join(APPS_ALL, self.name)

    def bin(self) -> str:
        return self.platforms[sys.platform].bin

    def installed_bin_path(self) -> str:
        return path.join(APPS_BIN, path.basename(self.bin()))

    def is_installed(self) -> bool:
        return path.exists(self.installed_bin_path())

    def installed_versions(self) -> List[str]:
        if not path.exists(self.path):
            return []

        versions = os.listdir(self.path)
        versions.sort(reverse=True)
        return versions

    def is_release_installed(self, release: github.Release) -> bool:
        return release.tag_name in self.installed_versions()

    def platform(self) -> Platform:
        return self.platforms[sys.platform]

    def install(self):
        print("Installing %s..." % self.name)
        print('  * fetching latest release...')
        release = github.fetch_latest_release(self.github_repo)
        if release is None:
            raise "Error: could not find release for package %s" % self.name

        asset = release.find_asset(self.platform().asset_regexp)
        if asset is None:
            raise "Error: Could not find asset for package %s" % self.name

        release_dirname = path.join(APPS_ALL, self.name, release.tag_name)
        asset_filename = path.join(release_dirname, asset.name)
        if not path.exists(asset_filename):
            print("  * downloading...")
            helpers.download(asset.browser_download_url, asset_filename)
        print("  * extracting...")
        helpers.extract(asset_filename)
        print("  * linking...")
        self.link(release_dirname)
        print("  * done.")

    def link(self, release_dirname: str):
        helpers.mkdirp(APPS_BIN)
        bin_source = path.join(release_dirname, self.platform().bin)
        bin_target = path.join(APPS_BIN, path.basename(bin_source))
        if path.lexists(bin_target):
            os.remove(bin_target)
        os.symlink(bin_source, bin_target)


@dataclass
class Config:
    packages: List[Package]

    def __init__(self, filename):
        raw = json.load(open(filename))
        self.packages = list(map(Package, raw['packages']))


class PackageManager:
    def __init__(self):
        self.config = Config(CONFIG_FILENAME)

    def list(self):
        for pkg in self.config.packages:
            print('Name: ', pkg.name)
            print('Installed versions: ', pkg.installed_versions())
            print('Is installed?', pkg.is_installed())
            print()

    def update(self):
        for pkg in self.config.packages:
            print(pkg.name)
            print(pkg.installed_versions())
            print(pkg.install())

    def install(self):
        for pkg in self.config.packages:
            if pkg.is_installed():
                print(f'* {pkg.name} is already installed')
            else:
                print(pkg.install())
