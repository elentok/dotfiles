import os
from os import path
from typing import Optional

from . import github, helpers
from .package import Package

APPS_ROOT = path.expanduser('~/.apps')
APPS_ALL = path.join(APPS_ROOT, 'all')
APPS_BIN = path.join(APPS_ROOT, 'bin')


class PackageInstaller:
    package: Package

    def __init__(self, package: Package):
        self.package = package

    def install(self):
        if is_installed(self.package):
            print(f'* {self.package.name} is already installed')
            return

        print(f'* Installing {self.package.name}...')

        asset = self.fetch_latest_asset()
        AssetInstaller(self.package, asset).install()

    def update(self):
        print(f'* Updating {self.package.name}...')
        asset = self.fetch_latest_asset()

        installed_tag_name = self.installed_tag_name()
        if installed_tag_name == asset.release.tag_name:
            print(f'  * already up to date ({installed_tag_name}), skipping.')
        else:
            AssetInstaller(self.package, asset).install()

    def installed_tag_name(self) -> Optional[str]:
        if not is_installed(self.package):
            return None

        return os.readlink(bin_symlink(self.package)).replace(
            path.join(APPS_ALL, self.package.name), '').split('/')[1]

    def fetch_latest_asset(self) -> github.Asset:
        package = self.package

        print('  * fetching latest release...')
        release = github.fetch_latest_release(
            package.github_repo, package.prerelease)
        if release is None:
            raise Exception(
                f"Could not find release for package {package.name}")

        asset = release.find_asset(package.platform.asset_regexp)
        if asset is None:
            raise Exception(f"Could not find asset for package {package.name}")

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
        full_bin_target = bin_symlink(self.package)
        full_bin_source = path.join(self.release_dirname, self.bin_source)
        if path.lexists(full_bin_target):
            os.remove(full_bin_target)
        os.symlink(full_bin_source, full_bin_target)

    #  def installed_versions(self) -> List[str]:
        #  if not path.exists(self.path):
        #  return []

        #  versions = os.listdir(self.path)
        #  versions.sort(reverse=True)
        #  return versions

    #  def is_release_installed(self, release: github.Release) -> bool:
        #  return release.tag_name in self.installed_versions()
        #
        #


def bin_symlink(package: Package) -> str:
    return path.join(APPS_BIN, package.bin_target)


def is_installed(package: Package) -> bool:
    return path.exists(bin_symlink(package))
