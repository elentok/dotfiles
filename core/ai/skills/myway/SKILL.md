---
name: myway
description:
  Drive a wayfinder map through to a reviewed spec and a handed-off implementation epic, always on
  the gx local tracker. Detects the next step from on-disk state — invoke as `/myway {epic}`.
disable-model-invocation: true
---

`/myway {epic}` wraps [wayfinder](../wayfinder/SKILL.md) with fixed defaults for this workflow:
always the gx local tracker, and the destination is always a spec — this skill never implements or
touches code itself. `{epic}` is the epic-slug (`<root>/<epic>/...` under `gx tickets root`).

Three phases: **design** (wayfinder charts and resolves the map) → **review** (spec drafted,
design-reviewed, grilled) → **implement** (tickets published, `/myway`'s job is done). Every
invocation inspects on-disk state and runs exactly the next step — there is no separate phase field
anywhere, so detection is the state machine below.

## Detecting the next step

Evaluate in order; run the first branch that matches.

1. **No `<root>/<epic>/map.md`** → run wayfinder's "Chart the map" mode for `{epic}` (includes its
   own Destination-grilling).
2. **Map charted, not yet "the way is clear"** (open tickets remain, or `## Not yet specified` is
   non-empty) → run wayfinder's "Work through the map" mode, resolving exactly **one** ticket (never
   more per invocation — matches wayfinder's own rule, and keeps HITL ticket types genuinely
   interactive rather than faked in a subagent).
3. **The way is clear, no `docs/specs/<epic>.md`** → run [to-spec](../to-spec/SKILL.md) in a
   subagent. Seed it with the map body (Destination + Decisions so far) plus each closed ticket's
   title and resolution gist — not full ticket bodies; the map is already the index.
4. **Spec exists, no `.scratch/<epic>/review-findings.md`** → run a design-review subagent against
   the spec (rubric below), writing its findings to `.scratch/<epic>/review-findings.md` as a
   markdown checklist. Uncommitted — same tier as `map.md`, not the durable artifact.
5. **Findings file has unresolved items** → run a `/grilling` session on the open findings, staying
   resident in this same invocation (grilling is a live multi-round conversation; don't `/clear`
   between rounds — that's only for step 2's per-ticket isolation). Amend `docs/specs/<epic>.md`
   in place immediately as each finding resolves, and check it off in the findings file. Once every
   finding is resolved, fall through to step 6 in the same invocation.
6. **All findings resolved, no `<epic>-impl` epic** → run
   [gx-to-tickets](../gx-to-tickets/SKILL.md) against the amended spec, publishing into the new
   `<epic>-impl` epic (never into `{epic}`'s own `issues/` — a map's tickets are hand-resolved
   decisions, implementation tickets are ralph-loop-owned; see
   [gx-local-tracker.md](../gx-local-tracker.md)).
7. **`<epic>-impl` exists** → report its slug and stop. Nothing left for `/myway` — launch it via
   gx's ralph-loop orchestrator from the TUI Queue tab.

## Design-review rubric (step 4)

Review the spec against the map it came from and its own template, not in the abstract:

- Does every User Story trace back to the map's Destination and Decisions so far?
- Is each User Story testable?
- Does anything in the spec creep past the map's `## Out of scope` / the destination's boundary?
- What did the spec silently assume that the map never actually decided?
- Have we missed anything — any holes, any question the spec begs but doesn't answer?

## After every invocation

End with one line reporting what happened and what's next, using the phase name, not a step number:

```
✅ <phase>: <what happened this run>. Next: <phase> — <how to trigger it>
```

Examples:

```
✅ Design: resolved ticket 04-foo. Next: design — run /clear then /myway {epic}
✅ Design: the way is clear. Next: review — run /myway {epic}
✅ Review: all findings resolved, spec amended, epic {epic}-impl created. Next: nothing left for
   /myway — launch via gx's ralph-loop from the TUI Queue tab
```
