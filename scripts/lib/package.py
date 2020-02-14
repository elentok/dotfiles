import re
import sys
from dataclasses import dataclass
from typing import Optional


@dataclass
class Package:
    name: str
    github_repo: str
    bin_target: str
    strip_components: int
    prerelease: bool
    extract: bool
    platform: 'Platform'

    def __init__(self, raw):
        self.name = raw['name']
        self.github_repo = raw['github_repo']
        self.bin_target = raw.get('bin_target', self.name)
        self.strip_components = raw.get('strip_components', 0)
        self.prerelease = raw.get('prerelease', False)
        self.extract = raw.get('extract', True)
        self.platform = Platform(raw['platforms'][sys.platform])


@dataclass
class Platform:
    bin_source: Optional[str]
    asset_regexp: re.Pattern

    def __init__(self, raw):
        self.bin_source = raw.get('bin_source')
        self.asset_regexp = re.compile(raw['asset_regexp'])
