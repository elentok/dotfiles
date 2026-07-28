---
name: batchfinder
description:
  Run wayfinder with two standing defaults so you don't restate them every time - batched interviews
  via batch-grill-me instead of one-at-a-time grilling, and the local-markdown issue tracker. Type
  /batchfinder in place of /wayfinder.
disable-model-invocation: true
---

Runs [wayfinder](../wayfinder/SKILL.md) with two defaults baked in:

- **Batched interviews.** Wherever wayfinder's instructions say to run `/grilling`, run
  `/batch-grill-me` instead — every frontier question in one round, not one at a time.
  `/domain-modeling` steps are unchanged.
- **Local tracker.** Use the
  [local-markdown tracker](../setup-elentok-skills/issue-tracker-local.md) regardless of what this
  repo's issue tracker would otherwise resolve to.

Carry both into the map's **Notes** when charting, so later sessions working the same map pick them
up without re-reading this skill:

```markdown
## Notes

- Grilling: use /batch-grill-me instead of /grilling for all interview rounds.
- Tracker: local markdown (issue-tracker-local.md), regardless of repo default.
```

Then follow wayfinder's [Invocation](../wayfinder/SKILL.md#invocation) section as written.
