import json
import os
import re
import sys
from dataclasses import dataclass
from os import path
from typing import Tuple, List, Mapping, Optional

from . import github, download

APPS_ROOT = path.expanduser('~/.apps')
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

        self.path = path.join(APPS_ROOT, 'all', self.name)

    def bin(self) -> str:
        return self.platforms[sys.platform].bin

    def installed_bin_path(self) -> str:
        return path.join(APPS_ROOT, 'bin', self.name)

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
        release = github.fetch_latest_release(self.github_repo)
        if release is None:
            raise "Error: could not find release for package %s" % self.name

        asset = release.find_asset(self.platform().asset_regexp)
        if asset is None:
            raise "Error: Could not find asset for package %s" % self.name

        root = path.join(APPS_ROOT, 'all', self.name, release.tag_name)
        asset_filename = path.join(root, asset.name)
        download.download(asset.browser_download_url, asset_filename)


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
