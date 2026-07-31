---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

The issue tracker and triage label vocabulary should have been provided to you — run
`/setup-elentok-skills` if not.

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once starting, mark the ticket as "claimed"

Once done, use /code-review to review the work.

Commit your work to the current branch.
