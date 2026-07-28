---
name: teach-epub
description:
  Author a teach workspace's lessons/reference/index in markdown and build both the browsable HTML
  site and a phone-friendly EPUB from that one source.
disable-model-invocation: true
argument-hint: "path to the teach workspace (defaults to the current directory)"
---

Extends [teach](../teach/SKILL.md) — read it first for the pedagogy (mission, ZPD, wisdom, assets,
lesson/reference philosophy). This skill only covers the format delta: markdown authoring, index
generation, and generating both the HTML site and the EPUB from one source.

## Workspace layout

Same workspace as `teach`, with the source format changed:

- `lessons/NNNN-slug.md`, `reference/slug.md` — markdown, not HTML. This is the authored source.
- `index.md` — new: `teach-epub` owns index generation, since `teach` never produced one. Keep it
  short — course title, one paragraph pulled from `MISSION.md`, a linked list of lessons in order, a
  link into the reference section.
- `assets/style.css` — the shared web stylesheet, exactly as `teach` uses it today. The EPUB build
  never edits it.
- `site/` — generated HTML output (`index.html`, `lessons/*.html`, `reference/*.html`). Build
  output, not hand-edited — regenerate rather than patch.
- `<Course Title>.epub` — generated EPUB, written to the workspace root.

## Authoring markdown

### Lessons and reference docs

Plain markdown. The `#` heading is the title, and must be the only top-level heading in the file —
the EPUB build splits chapters on it. Give it an explicit id so cross-doc links can target it:

```
# What Class Is Risperdal? {#risperdal-what-class-is-it}
```

### Cross-doc links

Link to another lesson or reference doc by its `.md` path plus that doc's heading id:

```
[medication classes](../reference/medication-classes-glossary.md#medication-classes-glossary)
```

The build rewrites this per target — `.md` → `.html` for the site, collapsed to the bare `#anchor`
for the EPUB (files are concatenated into one book there). Don't hand-author `.html` links or
anchor-only links — they'd be right for one target and wrong for the other.

### Images

Store image files under `assets/images/` and reference them as workspace-root-relative paths, with
no `../` prefix, regardless of which file (`index.md`, `lessons/*.md`, `reference/*.md`) does the
referencing:

```
![Plywood edge showing cross-grained veneer layers](assets/images/plywood-edge.jpg)
```

The EPUB build resolves this correctly as-is (it runs with the workspace root as its working
directory). The site build rewrites it per output file's depth via `--metadata imgprefix=...` and
`scripts/images-site.lua` — don't hand-author a `../`-prefixed path, it would only be correct for
one target's directory depth.

### Wide or data-heavy tables

Author as a markdown definition list, not a pipe table — pipe tables shrink to illegibility on
phone-width EPUB readers:

```
Dose range
:   0.25mg–3mg, dosed by weight.

Half-life
:   ~20 hours.
```

Renders identically on both targets from the same source; only the EPUB build adds the stacked
key-value card styling (`assets/epub-overrides.css`), so no dual-authoring is needed. Small tables
(a couple of short cells) can stay as ordinary pipe tables — they degrade fine.

### Quizzes

Authored once, rendered twice — an interactive click-to-answer widget on the web, a static answer
key in the EPUB — as a fenced div:

```
::: quiz
Q: Your neighbor says her daughter takes an SSRI for anxiety, and you mention your son takes
Risperdal for the same reason. What's the most accurate response?

1. "Same idea — just a different brand of anxiety medication."
2. "Actually his is a different class — it's for irritability/aggression, not anxiety directly."
3. "His is a much stronger version of the same drug."

Correct: 2
Right feedback: Right. Different drug class, different target symptom.
Wrong feedback: Not quite — see the correct answer highlighted above.
:::
```

`Right feedback:` / `Wrong feedback:` are optional and web-only — the EPUB has no click interaction
to give feedback on, so its answer key is just the numbered choices plus `Answer: 2`, never the full
correct-choice text repeated.

Per `teach`'s own quiz guidance: keep every choice the same length, and don't hint at the answer
through formatting.

## Building

Requires `pandoc` (validate the EPUB with `epubcheck` if it's installed — zero errors is the bar).

Run `scripts/build.py [workspace-dir]` (defaults to `.`). It:

1. Renders `index.md` + `lessons/*.md` + `reference/*.md` to `site/*.html`, one page per file, each
   linked to `assets/style.css`, quizzes rendered as the interactive widget
   (`scripts/quiz-web.lua` + `assets/quiz-widget.html`), cross-doc links rewritten to `.html`
   (`scripts/links-site.lua`), image paths depth-prefixed for that page's location
   (`scripts/images-site.lua`).
2. Renders `index.md` + `lessons/*.md` (filename order) + `reference/*.md` straight into
   `<Course Title>.epub` via one `pandoc … --split-level=1` call — no manual concatenation step,
   pandoc's own chapter splitting and cross-reference rewriting handle it. `assets/style.css` plus
   this skill's `assets/epub-overrides.css` are layered on as `--css`; quizzes render as the static
   answer key (`scripts/quiz-epub.lua`); cross-doc links collapse to in-book anchors
   (`scripts/links-epub.lua`).

`assets/epub-overrides.css` is EPUB-only — it flattens the type scale to two sizes (heading, body)
and styles the two markdown-native fallbacks (`dl` for wide tables, `.quiz-static` for quiz answer
keys). It's referenced straight from this skill directory; nothing needs copying into the workspace.
