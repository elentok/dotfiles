---
name: to-tickets
description:
  Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each
  declaring its blocking edges, published to the configured tracker — edges as text in one file per
  ticket locally, or native blocking links on a real tracker.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** — tracer-bullet vertical slices, each
declaring the tickets that **block** it.

The issue tracker and triage label vocabulary should have been provided to you — run
`/setup-elentok-skills` if not.

Estimate the amount of tokens that will be needed for the implemetnation of each ticket, if a ticket
will need more than 130K tokens - split it.

When estimating, budget for the whole session, not just the diff size. A ticket that only adds ~150
lines can still blow the budget once you add:

- **Full reads of existing files it touches.** If a ticket requires wiring new behavior through an
  existing file over ~300-400 lines (e.g. a central loop/dispatcher), count that file's size against
  the budget every time it's likely to be read (before editing, after review fixes, verification) —
  not once.
- **The verify/code-review pass.** `/code-review` and `/verify` add their own findings + fix + re-run
  cycles on top of the implementation itself; budget for at least one extra read+edit pass over any
  large file the ticket touches.
- **TDD iteration.** If the ticket will be built test-first, budget for multiple test-run cycles, not
  a single build+test at the end.
- **Variant fan-out.** Count how many independent states/variants the acceptance criteria describe
  (e.g. three distinct row badges, or a list-view change plus a separate preview-pane change). Each
  variant typically needs its own wiring and its own test assertion — treat N independent variants
  the same as threading a large file N times, and split by variant group if N is more than a couple.

Separate "the capability doesn't exist yet" from "something consumes a capability that now exists"
into different tickets — a plumbing/infra ticket vs. a feature-on-top ticket. This applies whenever a
ticket both builds a new capability and builds the thing that uses it, not only when a large
pre-existing file is threaded twice (e.g. "add the data/plumbing" ticket vs. "add the user-facing
command" ticket; or "add a new backend control path" vs. "add the UI that calls it").

If tickets earlier in the same epic are already implemented, check their actual cost (handoff notes,
session logs, run duration) before finalizing later estimates. A cold estimate is a guess; an earlier
sibling ticket's actual is real data about how this epic's tickets run in practice, and should
recalibrate the rest of the split — including retroactively splitting a not-yet-started ticket that
now looks oversized in light of it.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec
path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.
Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs
in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change
easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) —
  vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** — the other tickets that must complete before it can start.
A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical
change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole
codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land
green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add
the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by
blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping
CI green batch to batch because the old form still exists. Finally contract: delete the old form
once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay
green alone, keep the sequence but let them share an integration branch that all block a final
integrate-and-verify ticket — green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets to the configured tracker

Publish the approved tickets. **How** depends on the tracker `/setup-elentok-skills` configured —
the tickets are the same either way, only the shape of the blocking edges changes:

- **Local files** → write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`,
  numbered from `01` in dependency order (blockers first). Each file's "Blocked by" lists the
  numbers/titles it depends on. Use the per-ticket file template below — one ticket per file, never
  a single combined file.
- **A real issue tracker (GitHub, Linear, …)** → publish one issue per ticket in dependency order
  (blockers first) so each ticket's blocking edges can reference real identifiers. Use the
  platform's native blocking / sub-issue relationship where it has one; otherwise set each ticket's
  "Blocked by" to the blocking issues. Apply the `ready-for-agent` triage label unless instructed
  otherwise — the tickets are agent-grabbable by construction.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means
top to bottom.

Do NOT close or modify any parent issue.

Tickets can also be split off **mid-flight**, by `/implement` or `/code-review`, when a ticket
outgrows its budget while in progress — same template, same publishing mechanics, just triggered
from inside a running session instead of upfront here. It reuses this skill's numbering and
blocking conventions: a flat sibling number off the root ticket (`03` → `03b`, `03c`, ...), the new
ticket's "Blocked by" includes the original, and anything blocked-by the original also gets the new
ticket added as a blocker. The new ticket carries a `Following-up: <original>` line.

<local-ticket-template>

# <NN> — <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective —
not a layer-by-layer implementation list.

**Blocked by:** the numbers/titles of the tickets that gate this one, or "None — can start
immediately".

**Following-up:** (optional) the ticket this continues, if it exists because a prior ticket
outgrew its budget mid-flight.

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-ticket-template>

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit
this section).

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective — not layer-by-layer
implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None — can start immediately".

## Following-up

(optional) the ticket this continues, if it exists because a prior ticket outgrew its budget
mid-flight.

</issue-template>

In either form, avoid specific file paths or code snippets — they go stale fast. Exception: if a
prototype produced a snippet that encodes a decision more precisely than prose can (state machine,
reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the
decision-rich parts — not a working demo, just the important bits.
