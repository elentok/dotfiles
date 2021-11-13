from .config import CONFIG
from .package_installer import PackageInstaller


class PackageManager:
    def list(self):
        for pkg in CONFIG.packages:
            print("Name: ", pkg.name)

    def update(self):
        for pkg in CONFIG.packages:
            PackageInstaller(pkg).update()

    def update_single(self, name: str, force_prerelease=False):
        pkgs = [pkg for pkg in CONFIG.packages if pkg.name == name]
        for pkg in pkgs:
            PackageInstaller(pkg, force_prerelease).update()

    def install(self):
        for pkg in CONFIG.packages:
            PackageInstaller(pkg).install()

    def install_single(self, name: str, force_prerelease=False):
        pkgs = [pkg for pkg in CONFIG.packages if pkg.name == name]
        for pkg in pkgs:
            PackageInstaller(pkg, force_prerelease).install()
