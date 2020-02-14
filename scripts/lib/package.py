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


@dataclass
class Platform:
    bin_source: Optional[str]
    asset_regexp: re.Pattern

    def __init__(self, raw):
        self.bin_source = raw.get('bin_source')
        self.asset_regexp = re.compile(raw['asset_regexp'])


class Package:
    name: str
    github_repo: str
    platforms: Mapping[str, Platform]
    bin_target: str
    strip_components: int
    prerelease: bool
    extract: bool
    platform: Platform

    full_bin_target: str

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.bin_target = raw.get('bin_target', self.name)
        self.platforms = {k: Platform(v) for k, v in raw['platforms'].items()}
        self.path = path.join(APPS_ALL, self.name)
        self.strip_components = raw.get('strip_components', 0)
        self.prerelease = raw.get('prerelease', False)
        self.extract = raw.get('extract', True)
        self.platform = self.platforms[sys.platform]
        self.full_bin_target = path.join(APPS_BIN, self.bin_target)

    def installed_versions(self) -> List[str]:
        if not path.exists(self.path):
            return []

        versions = os.listdir(self.path)
        versions.sort(reverse=True)
        return versions

    def is_release_installed(self, release: github.Release) -> bool:
        return release.tag_name in self.installed_versions()

    def is_installed(self) -> bool:
        return path.exists(self.full_bin_target)

    def install(self):
        Installer(self).install()


class Installer:
    package: Package

    def __init__(self, package: Package):
        self.package = package

    def install(self):
        print(f'Installing {self.package.name}...')

        asset = self.fetch_latest_asset()
        AssetInstaller(self.package, asset).install()

    def fetch_latest_asset(self) -> github.Asset:
        pkg = self.package

        print('  * fetching latest release...')
        release = github.fetch_latest_release(pkg.github_repo, pkg.prerelease)
        if release is None:
            raise Exception(f"Could not find release for package {pkg.name}")

        asset = release.find_asset(pkg.platform.asset_regexp)
        if asset is None:
            raise Exception(f"Could not find asset for package {pkg.name}")

        return asset


class AssetInstaller:
    package: Package
    asset: github.Asset
    release_dirname: str
    asset_filename: str
    bin_source: str

    def __init__(self, package: Package, asset: github.Asset):
        self.package = package
        self.asset = asset
        self.release_dirname = path.join(
            APPS_ALL, package.name, asset.release.tag_name)
        self.asset_filename = path.join(
            self.release_dirname, f'{package.name}{asset.ext}')
        self.bin_source = package.platform.bin_source or package.bin_target

    def install(self):
        self.download()

        if self.package.extract:
            self.extract()
        else:
            self.make_executable()

        self.link()

        print("  * done.")

    def download(self):
        if path.exists(self.asset_filename):
            return

        print("  * downloading...")
        helpers.download(self.asset.browser_download_url, self.asset_filename)

    def extract(self):
        print("  * extracting...")
        helpers.extract(self.asset_filename, self.package.strip_components)

    def make_executable(self):
        print('  * making {self.asset_filename} executable ...')
        os.system(f'chmod u+x {self.asset_filename}')

    def link(self):
        print("  * linking...")

        helpers.mkdirp(APPS_BIN)
        full_bin_source = path.join(self.release_dirname, self.bin_source)
        if path.lexists(self.package.full_bin_target):
            os.remove(self.package.full_bin_target)
        os.symlink(full_bin_source, self.package.full_bin_target)
