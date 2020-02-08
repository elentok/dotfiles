from dataclasses import dataclass
from typing import List, Union

import requests


@dataclass
class Asset:
    name: str
    browser_download_url: str

    def __init__(self, raw):
        self.name = raw['name']
        self.browser_download_url = raw['browser_download_url']


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


def fetch_latest_release(repo: str) -> Union[Release, None]:
    releases = fetch_releases(repo)
    for release in releases:
        if not release.prerelease:
            return release
    return None
