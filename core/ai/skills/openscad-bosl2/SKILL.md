---
name: openscad-bosl2
description:
  Generate, edit, or debug OpenSCAD 3D models using the BOSL2 library. Use when creating or editing
  .scad files, or when asked for a 3D-printable part, model, or BOSL2 design.
---

# OpenSCAD + BOSL2

Workflow for building parametric 3D models in this user's style — BOSL2-idiomatic, matching the
conventions already used across `~/dev/openscad`.

## 1. Reuse before writing

Check the project's `lib/` directory (e.g. `~/dev/openscad/lib/`) for existing modules — screw
sizes, rounded cubes, masks, etc. — before writing new geometry from scratch. `use <../../lib/x.scad>`
to pull one in.

If you find a bug in an existing `lib/` module while building something, fix it — don't work around
it.

## 2. Place the file

Mirror the existing category layout under `~/dev/openscad` (`desk/`, `keyboard/`, `tools/`,
`containers/`, etc.) — put a new part in the category it belongs to, don't drop it at the repo root.

- **Single part** → one `.scad` file in the category dir.
- **Multi-part project** → its own subfolder, following the `keyboard/iris-case-v2/` pattern:
  `vars.scad` (parameters), `shared.scad` (shared modules, `include <./vars.scad>` +
  `include <BOSL2/std.scad>`), and one file per part, each starting with `include <./shared.scad>`.

## 3. Write the code

File-level defaults, matching the rest of the repo:

- `include <BOSL2/std.scad>` (not `use`) as the first line — BOSL2 relies on globals, `use` won't
  pull them in.
- `$fn = 64;` right after the includes.
- `epsilon = 0.01;` when a boolean op needs overlap fudge to avoid coincident-face artifacts.
- Parameters as bare snake_case globals near the top of the file — not wrapped in a config module.
- Units are mm throughout.

Geometry idioms:

- Use BOSL2's directional shorthands (`up()`, `down()`, `left()`, `right()`, `fwd()`, `back()`)
  instead of raw `translate()`, and `anchor=`/`spin=`/`orient=` for positioning parts and picking
  reference points — see [attachables.md](attachables.md) for the anchor/spin/orient/attach model.
- Default to plain `difference()`/`union()` for booleans — that's the dominant pattern here. Reach
  for BOSL2's `tag()`/`diff()` attachment-boolean system only when a negative shape's position is
  genuinely anchor-relative to its parent (a hole anchored to a face that itself gets
  positioned/oriented) — [attachables.md](attachables.md) has the worked example.
- For less-common sub-libraries (threading, screws, gears, rounding, masks, ...), look up the exact
  function/module signature rather than guessing — see [module-index.md](module-index.md) for what
  each sub-library covers and where to find it on the BOSL2 wiki.

## 4. Format

Run the repo's formatter on the file — it's a stdin/stdout filter, not in-place:

```bash
dotf-openscad-format < path/to/file.scad > /tmp/formatted.scad && mv /tmp/formatted.scad path/to/file.scad
```

## 5. Verify

A model isn't done until it renders cleanly *and* looks right:

1. Render headlessly and check for errors — see [cli.md](cli.md) for the exact command and flags.
2. Read the rendered PNG (via the Read tool) and visually confirm the geometry is what was intended
   — a clean render can still be inverted, floating, or have parts missing that only a look catches.

## 6. Export

Only export an STL when the user explicitly asks to export or finalize — don't export on every
edit, it just litters the repo with stale STLs mid-iteration. Export next to the source file,
matching the existing STL-next-to-scad convention. Command in [cli.md](cli.md).

## Reference

- [attachables.md](attachables.md) — BOSL2's anchor/spin/orient/attach model, plus the `tag()`/
  `diff()` escape hatch with a worked example.
- [module-index.md](module-index.md) — BOSL2 sub-library index (threading, screws, gears, rounding,
  ...) with one-line descriptions and wiki links.
- [cli.md](cli.md) — headless render/check/export commands.
