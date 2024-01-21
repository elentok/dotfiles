from dataclasses import dataclass
from os import path
from typing import List
from configparser import ConfigParser, SectionProxy
import platform
import re


from .package import Package, Platform

MACHINE = platform.machine()
DOTF = path.join(path.dirname(__file__), "..", "..", "..", "..")
CONFIG_FILENAME = path.join(DOTF, "config", "dotf-github.cfg")


@dataclass
class Config:
    packages: List[Package]

    def __init__(self, filename):
        config = ConfigParser()
        config.read(filename)

        self.packages = []
        packages_by_name = {}

        for name in config.sections():
            section = config[name]
            if ":" not in name:
                package = self.__parse_package(section)
                packages_by_name[name] = package
                self.packages.append(package)

            else:
                platform = self.__parse_platform(section)
                if platform.machine == MACHINE:
                    packages_by_name[platform.package_name].platform = platform

    def __parse_package(self, section: SectionProxy) -> Package:
        return Package(
            name=section.name,
            github_repo=section.get("github_repo"),
            bin_target=section.get("bin_target", section.name),
            strip_components=section.getint("strip_components", 0),
            prerelease=section.getboolean("prerelease", False),
            extract=section.getboolean("extract", True),
            post_extract=section.get("post_extract", None),
            version=section.get("version", "latest"),
        )

    def __parse_platform(self, section: SectionProxy) -> Platform:
        [package_name, machine] = section.name.split(":")
        return Platform(
            package_name=package_name,
            machine=machine,
            bin_source=section.get("bin_source"),
            asset_regexp=re.compile(section.get("asset_regexp")),
        )


CONFIG = Config(CONFIG_FILENAME)
