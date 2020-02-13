import re
from dataclasses import dataclass
from typing import List, Optional

import requests

LINUX_RE = re.compile('.*linux.*')
MAC_RE = re.compile('.*(mac).*')


@dataclass
class Asset:
    name: str
    browser_download_url: str
    ext: Optional[str]

    def __init__(self, raw):
        self.name = raw['name']
        self.browser_download_url = raw['browser_download_url']
        self.ext = identify_extension(self.name)

    def is_linux(self) -> bool:
        return LINUX_RE.search(self.name) is not None


def identify_extension(filename: str) -> str:
    if filename.endswith('.tar.gz'):
        return '.tar.gz'

    if filename.endswith('.tgz'):
        return '.tgz'

    if filename.endswith('.zip'):
        return '.zip'

    return ''


@dataclass
class Release:
    tag_name: str
    name: str
    prerelease: bool
    published_at: str
    assets: List[Asset]

    def __init__(self, raw):
        self.tag_name = raw['tag_name']
        self.name = raw['name']
        self.prerelease = raw['prerelease']
        self.published_at = raw['published_at']
        self.assets = list(map(Asset, raw['assets']))

    def find_asset(self, regexp: re.Pattern) -> Optional[Asset]:
        for asset in self.assets:
            if regexp.match(asset.name):
                return asset

        return None


def fetch_releases(repo: str) -> List[Release]:
    url = 'https://api.github.com/repos/%s/releases' % repo
    response = requests.get(url=url)
    data = response.json()
    return list(map(Release, data))


def fetch_latest_release(repo: str, prerelease=False) -> Optional[Release]:
    releases = fetch_releases(repo)
    if prerelease:
        return releases[0]

    for release in releases:
        if not release.prerelease:
            return release
    return None
