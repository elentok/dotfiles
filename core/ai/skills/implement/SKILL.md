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

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once starting, mark the ticket as "claimed".

Once done, use /code-review to review the work, then mark the ticket done.

Commit your work to the current branch.
