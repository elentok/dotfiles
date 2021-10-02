import os
from os import path, remove
from typing import Optional

from . import github, helpers
from .package import Package

APPS_ROOT = path.expanduser("~/.apps")
APPS_ALL = path.join(APPS_ROOT, "all")
APPS_BIN = path.join(APPS_ROOT, "bin")


class PackageInstaller:
    package: Package
    force_prerelease: bool

    def __init__(self, package: Package, force_prerelease=False):
        self.package = package
        self.force_prerelease = force_prerelease

    def install(self):
        if not self.force_prerelease and is_installed(self.package):
            print(f"* {self.package.name} is already installed")
            return

        if self.package.platform is None:
            print(f"* {self.package.name} is not supported on this platform")
            return

        print(f"* Installing {self.package.name}...")

        asset = self.fetch_latest_asset()
        AssetInstaller(self.package, asset, self.force_prerelease).install()

    def update(self):
        print(f"* Updating {self.package.name}...")
        asset = self.fetch_latest_asset()

        if self.should_update(asset):
            AssetInstaller(self.package, asset).install()

    def should_update(self, asset: github.Asset):
        installed_tag_name = self.installed_tag_name()
        if installed_tag_name == "nightly":
            print("  * using nightly build, so updating anyway.")
            return True

        if installed_tag_name != asset.release.tag_name:
            return True

        print(f"  * already up to date ({installed_tag_name}), skipping.")
        return False

    def installed_tag_name(self) -> Optional[str]:
        if not is_installed(self.package):
            return None

        return (
            os.readlink(bin_symlink(self.package))
            .replace(path.join(APPS_ALL, self.package.name), "")
            .split("/")[1]
        )

    def fetch_latest_asset(self) -> github.Asset:
        package = self.package
        version = "prerelease" if self.force_prerelease else package.version

        print(f"  * fetching release {version}...")
        release = github.fetch_release(package.github_repo, version)
        if release is None:
            raise Exception(f"Could not find release for package {package.name}")

        print(f"  * latest release is: {release.name} (tag={release.tag_name})")

        if package.platform is None:
            raise Exception(f"Could not find platform for package {package.name}")

        asset = release.find_asset(package.platform.asset_regexp)
        if asset is None:
            raise Exception(
                f"Could not find asset for package {package.name} (regexp: {package.platform.asset_regexp})"
            )

        return asset


class AssetInstaller:
    package: Package
    asset: github.Asset
    release_dirname: str
    asset_filename: str
    bin_source: str
    force_prerelease: bool

    def __init__(self, package: Package, asset: github.Asset, force_prerelease=False):
        self.package = package
        self.asset = asset
        self.release_dirname = path.join(APPS_ALL, package.name, asset.release.tag_name)
        self.asset_filename = path.join(
            self.release_dirname, f"{package.name}{asset.ext}"
        )
        self.bin_source = package.platform.bin_source or package.bin_target
        self.force_prerelease = force_prerelease

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
            os.remove(self.asset_filename)

        print(f"  * downloading {self.asset_filename}...")
        helpers.download(self.asset.browser_download_url, self.asset_filename)

    def extract(self):
        print("  * extracting...")
        helpers.extract(self.asset_filename, self.package.strip_components)

    def make_executable(self):
        print("  * making {self.asset_filename} executable ...")
        os.system(f"chmod u+x {self.asset_filename}")

    def link(self):
        print("  * linking...")

        helpers.mkdirp(APPS_BIN)
        full_bin_target = bin_symlink(self.package)
        if self.force_prerelease:
            full_bin_target = f"{full_bin_target}-pre"

        full_bin_source = path.join(self.release_dirname, self.bin_source)
        if path.lexists(full_bin_target):
            os.remove(full_bin_target)
        os.symlink(full_bin_source, full_bin_target)


def bin_symlink(package: Package) -> str:
    return path.join(APPS_BIN, package.bin_target)


def is_installed(package: Package) -> bool:
    return path.exists(bin_symlink(package))
