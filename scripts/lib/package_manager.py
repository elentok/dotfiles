import json
from dataclasses import dataclass
from os import path
from typing import List

from .package import Package
from .package_installer import PackageInstaller

DOTF = path.join(path.dirname(__file__), "..", "..")
CONFIG_FILENAME = path.join(DOTF, "config", "dotf-github.json")


@dataclass
class Config:
    packages: List[Package]

    def __init__(self, filename):
        raw = json.load(open(filename))
        self.packages = list(map(Package, raw["packages"]))


class PackageManager:
    def __init__(self):
        self.config = Config(CONFIG_FILENAME)

    def list(self):
        for pkg in self.config.packages:
            print("Name: ", pkg.name)

    def update(self):
        for pkg in self.config.packages:
            PackageInstaller(pkg).update()

    def update_single(self, name: str, force_prerelease=False):
        pkgs = [pkg for pkg in self.config.packages if pkg.name == name]
        for pkg in pkgs:
            PackageInstaller(pkg, force_prerelease).update()

    def install(self):
        for pkg in self.config.packages:
            PackageInstaller(pkg).install()

    def install_single(self, name: str, force_prerelease=False):
        pkgs = [pkg for pkg in self.config.packages if pkg.name == name]
        for pkg in pkgs:
            PackageInstaller(pkg, force_prerelease).install()
