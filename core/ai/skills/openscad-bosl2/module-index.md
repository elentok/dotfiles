# BOSL2 sub-library index

BOSL2 is split into sub-libraries under `BOSL2/`. `include <BOSL2/std.scad>` pulls in the core set
(attachments, shapes2d, shapes3d, transforms, distributors, math, lists, ...). Add explicit includes
for the rest as needed, e.g. `include <BOSL2/threading.scad>`.

For exact function/module signatures, don't guess — fetch the relevant wiki page (linked below) or
the [Index by Function/Module Name](https://github.com/BelfrySCAD/BOSL2/wiki/Index-by-Function-Module-Name)
and [Usage Cheat Sheet](https://github.com/BelfrySCAD/BOSL2/wiki/CheatSheet).

| File | Covers | Wiki |
| --- | --- | --- |
| `std.scad` | Standard loader — pulls in the core set below | — |
| `shapes3d.scad` | 3D primitives (`cuboid`, `cyl`, `prismoid`, `sphere`, ...) with built-in rounding/chamfer options | [Shapes3d](https://github.com/BelfrySCAD/BOSL2/wiki/shapes3d.scad) |
| `shapes2d.scad` | 2D shapes/polygons (`rect`, `circle`, `polygon` variants) | [Shapes2d](https://github.com/BelfrySCAD/BOSL2/wiki/shapes2d.scad) |
| `attachments.scad` | The anchor/spin/orient/attach/tag/diff system — see [attachables.md](attachables.md) | [Attachments](https://github.com/BelfrySCAD/BOSL2/wiki/attachments.scad) |
| `transforms.scad` | Transform shorthands (`up`, `down`, `left`, `right`, `fwd`, `back`, `xrot`, ...) | [Transforms](https://github.com/BelfrySCAD/BOSL2/wiki/transforms.scad) |
| `distributors.scad` | Patterned copies — grids, rings, arrays of children | [Distributors](https://github.com/BelfrySCAD/BOSL2/wiki/distributors.scad) |
| `rounding.scad` | Fillets, rounding, offsets on 2D/3D shapes | [Rounding](https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad) |
| `masks2d.scad` / `masks3d.scad` | Edge/corner masks (chamfer, round, cove) to subtract or union onto geometry | [Masks3d](https://github.com/BelfrySCAD/BOSL2/wiki/masks3d.scad) |
| `threading.scad` | Generic and specific threaded rods/holes | [Threading](https://github.com/BelfrySCAD/BOSL2/wiki/threading.scad) |
| `screws.scad` | Standard screw definitions (metric, UTS) and screwholes | [Screws](https://github.com/BelfrySCAD/BOSL2/wiki/screws.scad) |
| `metric_screws.scad` | Legacy metric screw helpers (older API, prefer `screws.scad`) | — |
| `gears.scad` | Spur/bevel/rack gear generation | [Gears](https://github.com/BelfrySCAD/BOSL2/wiki/gears.scad) |
| `walls.scad` | Wall/structural connector components | [Walls](https://github.com/BelfrySCAD/BOSL2/wiki/walls.scad) |
| `beziers.scad` | Bezier curve construction | [Beziers](https://github.com/BelfrySCAD/BOSL2/wiki/beziers.scad) |
| `nurbs.scad` | NURBS curve construction | [Nurbs](https://github.com/BelfrySCAD/BOSL2/wiki/nurbs.scad) |
| `skin.scad` | Surface skinning/lofting between profiles | [Skin](https://github.com/BelfrySCAD/BOSL2/wiki/skin.scad) |
| `paths.scad` | 2D path manipulation (resample, offset, ...) | [Paths](https://github.com/BelfrySCAD/BOSL2/wiki/paths.scad) |
| `geometry.scad` | Geometric calculations (intersections, projections) | [Geometry](https://github.com/BelfrySCAD/BOSL2/wiki/geometry.scad) |
| `structs.scad` | Struct-like key/value lookups (used for e.g. screw-size tables) | [Structs](https://github.com/BelfrySCAD/BOSL2/wiki/structs.scad) |
| `math.scad` / `linalg.scad` / `lists.scad` | Math, linear algebra, and list utility functions | [Math](https://github.com/BelfrySCAD/BOSL2/wiki/math.scad) |

## Local install

BOSL2 isn't vendored in this repo — it's installed globally via `~/dev/openscad/install-bosl2` to
the platform's OpenSCAD library dir (`~/Documents/OpenSCAD/libraries/BOSL2` on macOS). If
`include <BOSL2/...>` fails to resolve, that script hasn't been run — don't vendor a copy as a
workaround, run the install script instead.
