import json
from dataclasses import dataclass
from os import path
from typing import List

from . import package

DOTF = path.join(path.dirname(__file__), '..', '..')
CONFIG_FILENAME = path.join(DOTF, 'config', 'dotf-pkgs.json')


@dataclass
class Config:
    packages: List[package.Package]

    def __init__(self, filename):
        raw = json.load(open(filename))
        self.packages = list(map(package.Package, raw['packages']))


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
