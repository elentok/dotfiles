import json
import os
import sys
from dataclasses import dataclass
from os import path
from typing import List, Mapping

from . import github

APPS_ROOT = path.expanduser('~/.apps')
DOTF = path.join(path.dirname(__file__), '..', '..')
CONFIG_FILENAME = path.join(DOTF, 'config', 'dotf-pkgs.json')


@dataclass
class Platform:
    bin: str

    def __init__(self, raw):
        self.bin = raw['bin']


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
            print(github.fetch_latest_release(pkg.github_repo))
