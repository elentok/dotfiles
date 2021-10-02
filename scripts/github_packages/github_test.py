import unittest
from . import github


class TestAsset(unittest.TestCase):
    def test_is_linux(self):
        self.assertEqual(asset("rg-x86_64-unknown-linux-musl").is_linux(), True)

    def test_ext(self):
        self.assertEqual(asset("hello.tar.gz").ext, ".tar.gz")
        self.assertEqual(asset("hello.zip").ext, ".zip")
        self.assertEqual(asset("hello.tgz").ext, ".tgz")
        self.assertEqual(asset("hello.world").ext, "")


def asset(name: str) -> github.Asset:
    return github.Asset({"name": name, "browser_download_url": "URL"})
