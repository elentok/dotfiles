---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

The issue tracker and triage label vocabulary should have been provided to you — run
`/setup-elentok-skills` if not.

If given a directory of tickets rather than a single ticket, work the **frontier**: the
lowest-numbered ticket that is unblocked (every ticket in its `blocked_by` is `done`) and unclaimed.
Implement exactly that one ticket, then stop — do not continue on to the next ticket in the same
run, even if it's now unblocked.

Before starting work on the ticket you're about to claim, run `gx tickets validate <path>` on it.
If it fails, stop and fix the ticket's frontmatter (or hand it back) before doing anything else —
do not begin implementation against a ticket that fails validation.

## Plan the reading before you read

A ticket should fit in the smart-zone section of the context window (~130K tokens). What overflows
it is reading, not writing.

Before the first edit:

1. Read the ticket. **Only** the ticket. Go to the spec/map for a named section, never in full - one
   naive read of a spec is most of a window.
2. Write the seams down (`/tdd`) and, from them, **list the files you will touch**. Skipping this
   turns a plan into a sequence of rediscoveries.
3. Read exactly those files, once each.

If the ticket has an `expected_context_window` field, check your file list against it before
editing - budgets come from the ticket's prose and routinely undercount (one 40K/two-file estimate
became 19 files, ~500K). If your list is materially larger, **say so in one line and carry on**;
the user may prefer a split.

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
read above, and before starting a new seam. To check: tail the current session's transcript JSONL
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
   blocking edges, `split_from`) and its estimation method. This chain is uncapped — each split
   narrows what's left, so it's self-limiting. Move any not-yet-finished acceptance criteria off
   the original ticket onto the new one(s). Do this **autonomously** — no pause for user approval;
   this exists to keep the outer loop unattended.
4. **Close the original** as done, with its `split` frontmatter field listing the new ticket IDs
   (e.g. `["03b", "03c"]`) and a body note of the token count from the last budget check (e.g.
   `Tokens used: ~102K`) — so it can be matched against the ticket's `expected_context_window`
   later. (`actual_context_window` itself is gx-written at cherry-pick time, not by the agent.)

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

Once starting, set the ticket's `status` frontmatter field to `claimed`.

Once done, set `status` to `done`. Code review runs separately, batched across the epic, not
per-ticket — do not invoke `/code-review` from here.

Commit your work to the current branch.
