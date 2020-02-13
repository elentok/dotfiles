import json
import os
import re
import sys
from dataclasses import dataclass
from os import path
from typing import List, Mapping, Optional

from . import github, helpers

APPS_ROOT = path.expanduser('~/.apps')
APPS_ALL = path.join(APPS_ROOT, 'all')
APPS_BIN = path.join(APPS_ROOT, 'bin')
DOTF = path.join(path.dirname(__file__), '..', '..')
CONFIG_FILENAME = path.join(DOTF, 'config', 'dotf-pkgs.json')


@dataclass
class Platform:
    bin_source: Optional[str]
    asset_regexp: re.Pattern

    def __init__(self, raw):
        self.bin_source = raw.get('bin_source')
        self.asset_regexp = re.compile(raw['asset_regexp'])


class Package:
    # fields from dotf-pkgs.json:
    name: str
    github_repo: str
    platforms: Mapping[str, Platform]
    bin_target: str
    strip_components: int
    prerelease: bool
    extract: bool

    # calculated fields:
    bin_source: str
    full_bin_target: str
    platform: Platform

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.bin_target = raw.get('bin_target', self.name)
        self.platforms = {k: Platform(v) for k, v in raw['platforms'].items()}
        self.path = path.join(APPS_ALL, self.name)
        self.strip_components = raw.get('strip_components', 0)
        self.prerelease = raw.get('prerelease', False)
        self.extract = raw.get('extract', True)

        self.bin_source = self.platforms[sys.platform].bin_source or self.bin_target
        self.full_bin_target = path.join(APPS_BIN, self.bin_target)
        self.platform = self.platforms[sys.platform]

    def is_installed(self) -> bool:
        return path.exists(self.full_bin_target)

    def installed_versions(self) -> List[str]:
        if not path.exists(self.path):
            return []

        versions = os.listdir(self.path)
        versions.sort(reverse=True)
        return versions

    def is_release_installed(self, release: github.Release) -> bool:
        return release.tag_name in self.installed_versions()

    def install(self):
        print("Installing %s..." % self.name)
        print('  * fetching latest release...')
        release = github.fetch_latest_release(
            self.github_repo, self.prerelease)
        if release is None:
            raise Exception(f"Could not find release for package {self.name}")

        asset = release.find_asset(self.platform.asset_regexp)
        if asset is None:
            raise Exception(f"Could not find asset for package {self.name}")

        release_dirname = path.join(APPS_ALL, self.name, release.tag_name)
        asset_filename = path.join(release_dirname, f'{self.name}{asset.ext}')
        if not path.exists(asset_filename):
            print("  * downloading...")
            helpers.download(asset.browser_download_url, asset_filename)
        if self.extract:
            print("  * extracting...")
            helpers.extract(asset_filename, self.strip_components)
        else:
            os.system(f'chmod u+x {asset_filename}')
        print("  * linking...")
        self.link(release_dirname)
        print("  * done.")

    def link(self, release_dirname: str):
        helpers.mkdirp(APPS_BIN)
        full_bin_source = path.join(release_dirname, self.bin_source)
        if path.lexists(self.full_bin_target):
            os.remove(self.full_bin_target)
        os.symlink(full_bin_source, self.full_bin_target)


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
