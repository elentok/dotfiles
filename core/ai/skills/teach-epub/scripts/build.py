#!/usr/bin/env python3
"""Build a teach-epub workspace's markdown source into `site/*.html` and a
single EPUB. See ../SKILL.md for the authoring format this expects.
"""
import subprocess
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent


def ordered_markdown(workspace: Path, subdir: str) -> list[Path]:
    d = workspace / subdir
    return sorted(d.glob("*.md")) if d.is_dir() else []


def title_of(md_path: Path) -> str:
    for line in md_path.read_text(encoding="utf-8").splitlines():
        if line.startswith("# "):
            return line[2:].split("{#", 1)[0].strip()
    return md_path.stem


def course_title(workspace: Path, index_md: Path) -> str:
    if index_md.exists():
        return title_of(index_md)
    return workspace.name.replace("-", " ").title()


def build_site(workspace: Path, index_md: Path, lessons: list[Path], reference: list[Path]) -> None:
    site = workspace / "site"
    (site / "lessons").mkdir(parents=True, exist_ok=True)
    (site / "reference").mkdir(parents=True, exist_ok=True)
    quiz_filter = SKILL_DIR / "scripts" / "quiz-web.lua"
    links_filter = SKILL_DIR / "scripts" / "links-site.lua"
    images_filter = SKILL_DIR / "scripts" / "images-site.lua"
    quiz_widget = SKILL_DIR / "assets" / "quiz-widget.html"

    pages = []
    if index_md.exists():
        pages.append((index_md, site / "index.html", "../assets/style.css", "../"))
    pages += [(md, site / "lessons" / f"{md.stem}.html", "../../assets/style.css", "../../") for md in lessons]
    pages += [(md, site / "reference" / f"{md.stem}.html", "../../assets/style.css", "../../") for md in reference]

    for src, dest, css_rel, img_prefix in pages:
        subprocess.run(
            [
                "pandoc", str(src), "-s", "-o", str(dest),
                "--css", css_rel,
                "--lua-filter", str(quiz_filter),
                "--lua-filter", str(links_filter),
                "--lua-filter", str(images_filter),
                "--include-after-body", str(quiz_widget),
                "--metadata", f"title={title_of(src)}",
                "--metadata", f"imgprefix={img_prefix}",
            ],
            check=True,
        )
    print(f"Wrote {site}")


def build_epub(workspace: Path, index_md: Path, lessons: list[Path], reference: list[Path]) -> None:
    style = workspace / "assets" / "style.css"
    overrides = SKILL_DIR / "assets" / "epub-overrides.css"
    quiz_filter = SKILL_DIR / "scripts" / "quiz-epub.lua"
    links_filter = SKILL_DIR / "scripts" / "links-epub.lua"
    title = course_title(workspace, index_md)
    epub_out = workspace / f"{title}.epub"

    sources = ([index_md] if index_md.exists() else []) + lessons + reference
    if not sources:
        raise SystemExit("no markdown source found (index.md / lessons/*.md / reference/*.md)")

    subprocess.run(
        [
            "pandoc", *(str(s) for s in sources), "-o", str(epub_out),
            "--css", str(style),
            "--css", str(overrides),
            "--lua-filter", str(quiz_filter),
            "--lua-filter", str(links_filter),
            "--toc", "--toc-depth=1", "--split-level=1",
            "--metadata", f"title={title}",
            "--metadata", "lang=en",
        ],
        check=True,
        cwd=workspace,
    )
    print(f"Wrote {epub_out}")


def main() -> None:
    workspace = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    index_md = workspace / "index.md"
    lessons = ordered_markdown(workspace, "lessons")
    reference = ordered_markdown(workspace, "reference")
    build_site(workspace, index_md, lessons, reference)
    build_epub(workspace, index_md, lessons, reference)


if __name__ == "__main__":
    main()
