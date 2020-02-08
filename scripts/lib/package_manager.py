import json
from dataclasses import dataclass
from os import listdir
from os.path import dirname, exists, expanduser, join
from typing import List

from . import github

APPS_ROOT = expanduser('~/.apps')
DOTF = join(dirname(__file__), '..', '..')
CONFIG_FILENAME = join(DOTF, 'config', 'dotf-pkgs.json')


@dataclass
class Package:
    name: str
    github_repo: str
    version: str
    filenames: List[str]

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.version = raw['version']
        self.filenames = raw['filenames']

        self.path = join(APPS_ROOT, self.name)

    def installed_versions(self) -> List[str]:
        if not exists(self.path):
            return []

        versions = listdir(self.path)
        versions.sort(reverse=True)
        return versions


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
            print(pkg.name)
            print(pkg.installed_versions())
            print(github.fetch_latest_release(pkg.github_repo))
