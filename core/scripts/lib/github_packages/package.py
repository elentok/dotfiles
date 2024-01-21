import re
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
    version: str
    post_extract: Optional["str"] = None
    platform: Optional["Platform"] = None


@dataclass
class Platform:
    package_name: str
    machine: str
    bin_source: Optional[str]
    asset_regexp: re.Pattern
