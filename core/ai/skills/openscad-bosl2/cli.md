# Headless OpenSCAD: render, check, export

## Render check (step 5)

Render to a PNG and check exit code + stderr for errors/warnings before doing anything else:

```bash
openscad -o /tmp/check.png --render --imgsize=800,600 path/to/file.scad
```

- `--render` forces a full CGAL/Manifold geometry evaluation (not the fast preview) — this is what
  catches non-manifold geometry and boolean failures, a `--preview` render won't.
- Add `--hardwarnings` to fail fast on the first warning instead of a clean exit with warnings
  buried in stderr.
- Pass parametric values from the CLI with `-D var=value` (repeatable) instead of editing the file
  to test a variant.
- `--check-parameters` / `--check-parameter-ranges` validate module/function parameter usage without
  a full render — cheap first pass on a large file.

After a clean exit, **Read the PNG** (the Read tool handles images) to visually confirm the shape —
render success only means the geometry evaluated, not that it's the right shape, right way up, or
free of floating/missing pieces.

## Export (step 6, only when asked)

```bash
openscad -o path/to/file.stl --render path/to/file.scad
```

Export format is inferred from the output extension (`.stl`, `.3mf`, `.off`, `.dxf`, `.svg`, ...).
Always pass `--render` for exports — the default preview geometry isn't guaranteed manifold and can
produce a broken mesh.

## Format (step 4)

```bash
dotf-openscad-format < path/to/file.scad > /tmp/formatted.scad && mv /tmp/formatted.scad path/to/file.scad
```

It's a stdin/stdout filter (rewrites `use`/`include <...>` to C++-style includes, pipes through
`clang-format` using `.openscad-format` at the project root, converts back) — it does not edit files
in place, so always redirect to a temp file and move it over.
