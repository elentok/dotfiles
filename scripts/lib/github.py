import re
from dataclasses import dataclass
from typing import List, Optional

import requests

LINUX_RE = re.compile('.*linux.*')


@dataclass
class Asset:
    name: str
    browser_download_url: str

    def __init__(self, raw):
        self.name = raw['name']
        self.browser_download_url = raw['browser_download_url']

    def is_linux(self) -> bool:
        return LINUX_RE.search(self.name) is not None


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


def fetch_releases(repo: str) -> List[Release]:
    url = 'https://api.github.com/repos/%s/releases' % repo
    response = requests.get(url=url)
    data = response.json()
    return list(map(Release, data))


def fetch_latest_release(repo: str) -> Optional[Release]:
    releases = fetch_releases(repo)
    for release in releases:
        if not release.prerelease:
            return release
    return None
