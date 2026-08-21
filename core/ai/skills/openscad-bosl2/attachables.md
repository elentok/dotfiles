# BOSL2 attachables: anchor, spin, orient, attach

BOSL2's core differentiator from vanilla OpenSCAD. Every BOSL2 primitive (`cube()`, `cyl()`,
`prismoid()`, ...) and any module wrapped in `attachable()` carries a bounding geometry that lets you
position and orient it declaratively instead of hand-computing `translate()`/`rotate()` math.

## Anchor

`anchor=` picks which point on the object sits at the origin. Directions combine face constants:

```
TOP, BOTTOM, LEFT, RIGHT, FRONT (=FWD), BACK, CENTER
```

Combine with `+` for corners/edges: `anchor = TOP+BACK+LEFT`, `anchor = BOTTOM+RIGHT`.

```openscad
cyl(d = 10, h = 20, anchor = BOTTOM);        // base sits at z=0, instead of centered
prismoid(size1 = [20,20], size2 = [10,10], h = 15, anchor = BACK+LEFT+BOTTOM);
```

## Spin and orient

- `spin=` — rotation in degrees around the Z axis (or the attachment axis, once oriented).
- `orient=` — a direction vector the object's "up" axis should point toward (e.g. `orient = RIGHT`
  lays a cylinder on its side).

```openscad
cyl(d = 5, h = 30, orient = RIGHT, anchor = BOTTOM);  // lying on its side, base at origin
```

## position() vs attach()

- `position(anchor)` moves a child so its own origin lands on the parent's named anchor point — no
  reorientation.
- `attach(parent_anchor, child_anchor)` snaps a child onto a parent's anchor and auto-orients it to
  match the parent's surface normal there — use this when the child needs to sit flush against a
  face regardless of the parent's own orientation.

```openscad
cuboid([40, 30, 10])
    attach(TOP, BOTTOM) cyl(d = 8, h = 5);   // cylinder sits flush on the top face
```

## tag() / diff() — the boolean escape hatch

Default to plain `difference()`/`union()` — see `SKILL.md` step 3. Reach for this only when a
negative shape's position is genuinely relative to an anchor on its parent (so you'd otherwise have
to hand-translate the cut to match).

`tag("name")` labels a piece of geometry; `diff("neg_tag", "keep_tag")` (called on the parent)
subtracts everything tagged `neg_tag` from everything tagged `keep_tag` (default: everything
untagged), while positioning the negative shapes via `attach()`/`position()` against the parent's own
anchors:

```openscad
// Hole positioned relative to the block's own TOP face, not by hand-computed coordinates.
diff("hole")
cuboid([40, 30, 10])
    attach(TOP, BOTTOM, inside = true, shiftout = 0.01)
        tag("hole") cyl(d = 6, h = 12);
```

Without `diff()`/`tag()`, the same cut would need the hole's absolute position recomputed by hand any
time the cuboid's size or the hole's face changes. With it, the hole tracks the anchor.

## Further reading

Full tutorials on the BOSL2 wiki — fetch these live rather than relying on memory for exact
parameter names:

- https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachment-Overview
- https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachment-Basic-Positioning
- https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachment-Attach
- https://github.com/BelfrySCAD/BOSL2/wiki/Tutorial-Attachment-Tags
