import json
from dataclasses import dataclass
from os import path
from typing import List

from .package import Package
from .package_installer import PackageInstaller

DOTF = path.join(path.dirname(__file__), '..', '..')
CONFIG_FILENAME = path.join(DOTF, 'config', 'dotf-pkgs.json')


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
            PackageInstaller(pkg).update()

    def install(self):
        for pkg in self.config.packages:
            PackageInstaller(pkg).install()
