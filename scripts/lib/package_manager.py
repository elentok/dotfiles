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
        self.bin_source = raw['bin_source']
        self.asset_regexp = re.compile(raw['asset_regexp'])


class Package:
    name: str
    github_repo: str
    platforms: Mapping[str, Platform]
    bin_target: str
    strip_components: int

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.bin_target = raw['bin_target']
        self.platforms = {k: Platform(v) for k, v in raw['platforms'].items()}
        self.path = path.join(APPS_ALL, self.name)
        self.strip_components = raw.get('strip_components', 0)

    def bin_source(self) -> str:
        return self.platforms[sys.platform].bin_source

    def full_bin_target(self) -> str:
        return path.join(APPS_BIN, self.bin_target)

    def is_installed(self) -> bool:
        return path.exists(self.full_bin_target())

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
        helpers.extract(asset_filename, self.strip_components)
        print("  * linking...")
        self.link(release_dirname)
        print("  * done.")

    def link(self, release_dirname: str):
        helpers.mkdirp(APPS_BIN)
        bin_source = path.join(release_dirname, self.platform().bin_source)
        full_bin_target = self.full_bin_target()
        if path.lexists(full_bin_target):
            os.remove(full_bin_target)
        os.symlink(bin_source, full_bin_target)


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
