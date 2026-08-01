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

## Splitting when the ticket outgrows budget

Check the live budget at every natural checkpoint — after an Explore-agent returns, after each file
read above, before starting a new seam, and (see `/code-review`) between each file's fix pass during
review. To check: tail the current session's transcript JSONL
(`~/.claude/projects/<encoded-cwd>/<session-id>.jsonl`) and sum the last assistant line's
`input_tokens + cache_creation_input_tokens + cache_read_input_tokens`. Trigger a split at **100K**
— that leaves headroom under the 130K smart-zone budget for growth the check can't see (mid-turn,
between checkpoints). If the check itself fails (format drift, file missing), treat that as
over-budget — fail toward splitting, not past it.

Also split, independent of token count, on a **kind-mismatch**: if mid-implementation you discover
the ticket actually needs new plumbing/infra the original ticket didn't scope for (not just an
extension of existing logic), that's to-tickets' plumbing/feature split showing up late, not a
budget problem — split it the same way regardless of how much budget is left.

When either trigger fires:

1. **Finish the current thread to green.** Get to the nearest point where tests pass and the code
   compiles/typechecks — don't split off a broken half-edit. If nothing's been coded yet (the
   trigger fired during exploration/design), there's nothing to make green; skip to step 2 and
   carry the design reasoning forward as notes instead of a diff.
2. **Commit.**
3. **Create the follow-up ticket(s)**, using to-tickets' mid-flight-split conventions (numbering,
   blocking edges, `Following-up`) and its estimation method. This chain is uncapped — each split
   narrows what's left, so it's self-limiting. Move any not-yet-finished acceptance criteria off
   the original ticket onto the new one(s). Do this **autonomously** — no pause for user approval;
   this exists to keep the outer loop unattended.
4. **Close the original** as done, with a `Split: 03b, 03c` note.

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

Once done, invoke `/code-review`, passing the ticket ID and noting it's running inside implement's
flow (see code-review's step 6). Then mark the ticket done with a
`Code-review fixes: none/inline/sub-agent/ticket <id>` note reflecting what code-review had to do
to land its findings.

Commit your work to the current branch.
