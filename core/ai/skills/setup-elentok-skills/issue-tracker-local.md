# Issue tracker: Local Markdown

Issues and specs (you may know a spec as a PRD) for this repo live as markdown files in `.scratch/`.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`,
  numbered from `01` — never a single combined tickets file
- Each issue file opens with a `---`-delimited YAML frontmatter block, e.g.:

  ```yaml
  ---
  id: "03"
  status: open
  type: task
  blocked_by: ["01", "02"] # omit if not blocked
  ---
  ```

  - `status` is the triage state (see `triage-labels.md` for the role strings); canonical values:
    `open`, `needs-triage`, `ready-for-agent`, `ready-for-human`, `claimed`, `needs-info`,
    `needs-attention`, `done`, `superseded`
  - `type` is the ticket kind: `task`, `research`, `prototype`, `grilling`
  - `blocked_by` is a list of ticket IDs; omit the key entirely when there are none
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number
directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `.scratch/<effort>/map.md` — the Notes / Decisions-so-far / Fog body.
- **Child ticket**: `.scratch/<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question
  in the body and the frontmatter block described above. `type` is `research`/`prototype`/
  `grilling`/`task`; `status` moves `open` → `claimed` → `done` for wayfinding purposes.
- **Blocking**: a `blocked_by` list in the frontmatter. A ticket is unblocked when every ticket ID
  it lists has `status: done`.
- **Frontier**: scan `.scratch/<effort>/issues/` for files that are `open`, unblocked, and
  unclaimed; first by number wins.
- **Claim**: set `status: claimed` and save before any work.
- **Resolve**: append the answer under an `## Answer` heading, set `status: done`, then append a
  context pointer (gist + link) to the map's Decisions-so-far in `map.md`.
