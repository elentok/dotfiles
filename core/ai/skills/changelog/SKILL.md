---
name: changelog
description:
  Update CHANGELOG.md with the changes for the next version. Use when asked to update the changelog
---

## Workflow

1. Prepare the changes description - for this step use a cheap sub-agent (`gpt-5.4-mini` in Codex or
   `haiku` in Cluade):
   1. Get all of the commits from HEAD until the last version tag (`v1.2.3`)
   2. Summarize all of the changes in these commits
   3. Pass the summary to the parent agent

2. Review the summary, make changes if needed
3. Update CHANGELOG.md

### 2. Update CHANGELOG.md

## Template

```md
# Changelog

## v1.2.3 - {date}

- Added this
- Changed that
```

- If the user mentioned what's the next version (or how to bump it), e.g.
  `/changelog patch|minor|major` use that version
- If the user did not provide a version:
  - If the latest version in the changelog (the one at the top of the file) has aleady been released
    (if there's an existing tag) create a new section named `Unreleased` at the top.
  - If it hasn't been released - update that section

## What to include in the changelog?

- New features
  - If a feature is split into multiple commits (one initial commit and then several modification
    commits) treat it as one change ("Added X feature"), you can describe what functionality it
    includes.
- Bug fixes
- Which dependencies updated
