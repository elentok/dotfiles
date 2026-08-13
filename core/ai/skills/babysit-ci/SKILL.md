---
name: babysit-ci
description: >-
  Loop unattended until GitHub Actions CI is green on the current branch: check the failing run, fix
  it, get a lightweight second opinion, commit, push, and wait for the next result. Use when the
  user explicitly asks to babysit, watch, or keep fixing CI until it passes.
disable-model-invocation: true
---

# Babysit CI

Run entirely within this session, without pausing for confirmation, until CI on the current branch
is green or the iteration cap is hit. This skill carries standing authorization to commit and push
its own fixes — do not stop to confirm those specific pushes.

Scope: the repo and branch already checked out in the working directory. No arguments.

Cap: 5 iterations. An iteration is one check→fix→push→result cycle.

## Workflow

Repeat from step 1, tracking the iteration count.

1. **Check the run.** Find the latest GitHub Actions run for the current branch
   (`gh run list --branch <branch> --limit 1`, then `gh run view <id> --log-failed` for detail). If
   it's green, go to step 6. If iteration count already hit the cap, go to step 6 as a failure.

2. **Triage before fixing.** Read the failure log and judge whether it's fixable by a code change in
   this repo. Bail to step 6 as unfixable if the log points to something a diff can't address:
   infra/runner outage, expired credentials or missing secrets, a failure with no relation to files
   this loop has touched. Only continue to step 3 for failures a code change can plausibly fix.

3. **Fix it.** Make the change addressing the failure.

4. **Second opinion.** Dispatch one fresh subagent (general-purpose, highest available Opus model)
   as a read-only reviewer: give it the CI failure, the diff, and the fix's rationale, and ask it to
   flag anything wrong with the fix before it ships. It inspects only — it does not edit. Apply
   whatever it flags, then continue.

   This is a lightweight, non-interactive stand-in for `/consult`: no grilling round, no pausing for
   the user. `/consult`'s interactive resolution loop is the wrong shape for an unattended loop —
   don't invoke `/consult` itself here.

5. **Commit and push**, then poll for the new run's result: check status, and where the run is still
   in progress, use `ScheduleWakeup` to resume rather than blocking — CI runs regularly outlast a
   single turn's budget. Once the run concludes:
   - pass → go to step 6 as a success
   - fail → notify (see step 7 for wording) that this attempt failed, increment the iteration count,
     and go back to step 1

6. **Stop condition reached.** Exactly one of: CI passed, an unfixable failure was found, or the
   iteration cap was hit.

7. **Notify.** Track a one-line summary of each fix made in step 3 as the loop runs. Always end with
   exactly one `gx notify`, and always include the accumulated fix summary (omit only when no fix
   was ever made, i.e. an unfixable bail on iteration 1):
   - success: `gx notify "👍 CI passes: <summary of fixes across all iterations>"`
   - unfixable: `gx notify "👎 babysit-ci stuck: <one-line reason from step 2>[; already fixed: <summary of prior iterations' fixes>]"`
   - cap hit: `gx notify "👎 babysit-ci gave up after 5 iterations, still failing: <summary of fixes across all iterations>"`
   - each failed attempt inside the loop (step 5's fail branch) also gets its own
     `gx notify "👎 babysit-ci attempt <n> failed: <one-line reason>; fixed this attempt: <summary of this iteration's fix>"`
     before looping back
