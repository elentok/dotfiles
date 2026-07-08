#!/usr/bin/env python3
"""Keeps a local copy of selected 3rd party skills, inlined for security and
ease-of-deployment. Safe to re-run: re-clones each source repo and
overwrites the skill directories and their README.md.
"""

import shutil
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent


@dataclass(frozen=True)
class SkillSpec:
    source_path: str
    dest_name: str | None = None

    @property
    def source_name(self) -> str:
        return self.source_path.rsplit("/", 1)[-1]

    @property
    def resolved_dest_name(self) -> str:
        return self.dest_name or self.source_name


@dataclass(frozen=True)
class Repo:
    url: str
    skills: list[SkillSpec] = field(default_factory=list)


REPOS = [
    Repo(
        "https://github.com/mattpocock/skills",
        [
            SkillSpec("skills/engineering/domain-modeling"),
            SkillSpec("skills/engineering/grill-with-docs"),
            SkillSpec("skills/engineering/improve-codebase-architecture"),
            SkillSpec("skills/engineering/resolving-merge-conflicts"),
            SkillSpec("skills/engineering/tdd"),
            SkillSpec("skills/engineering/to-spec"),
            SkillSpec("skills/engineering/to-tickets"),
            SkillSpec("skills/engineering/wayfinder"),
            SkillSpec("skills/productivity/grill-me"),
            SkillSpec("skills/productivity/grilling"),
            SkillSpec("skills/productivity/handoff"),
            SkillSpec("skills/productivity/teach"),
            SkillSpec("skills/productivity/writing-great-skills"),
        ],
    ),
    Repo(
        "https://github.com/cursor/plugins",
        [
            SkillSpec("cursor-team-kit/skills/thermo-nuclear-code-quality-review"),
        ],
    ),
]


def clone_repo(repo_url: str) -> Path:
    clone_dir = Path("/tmp") / repo_url.rsplit("/", 1)[-1]
    shutil.rmtree(clone_dir, ignore_errors=True)
    subprocess.run(
        ["git", "clone", "--depth", "1", "--quiet", repo_url, str(clone_dir)],
        check=True,
        stderr=sys.stderr,
    )
    return clone_dir


def skill_title(dest_name: str) -> str:
    return " ".join(word.capitalize() for word in dest_name.split("-"))


def write_readme(dest_dir: Path, repo_url: str, skill: SkillSpec) -> None:
    dest_name = skill.resolved_dest_name
    lines = [
        f"# {skill_title(dest_name)}",
        "",
        f"Inlined from {repo_url}/blob/main/{skill.source_path}/SKILL.md "
        + "for security and ease-of-deployment.",
    ]
    if skill.source_name != dest_name:
        lines += [
            "",
            f"Renamed from `{skill.source_name}` to `{dest_name}` to make it easier to run.",
        ]
    (dest_dir / "README.md").write_text("\n".join(lines) + "\n")


def copy_skill(clone_dir: Path, repo_url: str, skill: SkillSpec) -> None:
    dest_name = skill.resolved_dest_name
    src = clone_dir / skill.source_path
    dest = SCRIPT_DIR / dest_name

    if not src.is_dir():
        print(f"Skipping {dest_name}: {src} not found", file=sys.stderr)
        return

    shutil.rmtree(dest, ignore_errors=True)
    shutil.copytree(src, dest)
    write_readme(dest, repo_url, skill)
    print(f"Updated {dest_name}")


def main() -> None:
    for repo in REPOS:
        clone_dir = clone_repo(repo.url)
        for skill in repo.skills:
            copy_skill(clone_dir, repo.url, skill)


if __name__ == "__main__":
    main()
