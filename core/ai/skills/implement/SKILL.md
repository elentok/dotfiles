---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

The issue tracker and triage label vocabulary should have been provided to you — run
`/setup-elentok-skills` if not.

If given a directory of tickets rather than a single ticket, work the **frontier**: the
lowest-numbered ticket that is unblocked (every ticket in its "Blocked by" is done) and unclaimed.
Implement exactly that one ticket, then stop — do not continue on to the next ticket in the same
run, even if it's now unblocked.

## Plan the reading before you read

A ticket should fit in the smart-zone section of the context window (~130K tokens). What overflows
it is reading, not writing.

Before the first edit:

1. Read the ticket. **Only** the ticket. Go to the spec/map for a named section, never in full - one
   naive read of a spec is most of a window.
2. Write the seams down (`/tdd`) and, from them, **list the files you will touch**. Skipping this
   turns a plan into a sequence of rediscoveries.
3. Read exactly those files, once each.

If the ticket has a **Budget:** line, check your file list against it before editing - budgets come
from the ticket's prose and routinely undercount (one 40K/two-file estimate became 19 files, ~500K).
If your list is materially larger, **say so in one line and carry on**; the user may prefer a split.

Then, while working:

- **Read a file once.** After an `Edit` succeeds the file in context is current - never re-read to
  verify. Repeat reads are the largest leak.
- **Never read source through Bash** (`cat`, `sed -n`, `head`, `tail`). Same tokens as `Read`, no
  benefit.
- **Prefer the LSP plugin to `grep`**. Grep returns kilobytes for what references answer in 3 lines.
- **Delegate any survey wider than ~3 files** to an `Explore` subagent - you keep the conclusion,
  not the file dumps.

## Comments: fewer, and no numbers in them

A comment quoting a measured value duplicates it, and dupliates drift - stale figures ship.

- **A number goes in a test, not a comment.**
- **Comment the non-obvious decision, not the code.** Why this and not the obvious alternative, what
  broke last time. Anything the identifiers already say is noise.
- **One explanation, one home**. If two declarations need the same rationale, hoist what they share
  and explain it there.

## Other notes

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once starting, mark the ticket as "claimed".

Once done, use /code-review to review the work, then mark the ticket done.

Commit your work to the current branch.
