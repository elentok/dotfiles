# Issue tracker: Local Markdown

Issues and specs for this repo live as markdown files under a `.scratch/` root.

## Finding the `.scratch/` root

Don't assume `.scratch/` sits at the repo root or at cwd — in a bare-repo checkout with linked
worktrees, the canonical `.scratch/` lives at the bare repo's own root, not any worktree's. If the
repo has a `gx` binary (check `gx tickets root` runs without error), use it to resolve the root:

```bash
root=$(gx tickets root)
```

`gx tickets root` prints the canonical `.scratch` path with no decoration, so it's safe to use
directly in `cd $(gx tickets root)` or `$root/<feature-slug>/...`. If `gx` isn't available or the
repo isn't a gx-managed repo, fall back to `.scratch/` at the repo root.

## Conventions

- One feature per directory: `<root>/<feature-slug>/`
- The spec is `<root>/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `<root>/<feature-slug>/issues/<NN>-<slug>.md`,
  numbered from `01` — never a single combined tickets file
- Triage state is recorded as a `Status:` line near the top of each issue file (see
  `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new file under `<root>/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number
directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `<root>/<effort>/map.md` — the Notes / Decisions-so-far / Fog body.
- **Child ticket**: `<root>/<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question
  in the body. A `Type:` line records the ticket type (`research`/`prototype`/`grilling`/`task`); a
  `Status:` line records `claimed`/`resolved`.
- **Blocking**: a `Blocked by: NN, NN` line near the top. A ticket is unblocked when every file it
  lists is `resolved`.
- **Frontier**: scan `<root>/<effort>/issues/` for files that are open, unblocked, and unclaimed;
  first by number wins.
- **Claim**: set `Status: claimed` and save before any work.
- **Resolve**: append the answer under an `## Answer` heading, set `Status: resolved`, then append a
  context pointer (gist + link) to the map's Decisions-so-far in `map.md`.
