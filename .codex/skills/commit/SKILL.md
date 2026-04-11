---
name: commit
description: Create a git commit following project conventions. Use when asked to commit, create a commit, or finalize changes.
---

Create a git commit following the rules below.

Before creating any commit in this repository:
- Read `.ai/commit-message.md`
- Explicitly mention that you checked `.ai/commit-message.md`

## Workflow

1. Run `git status` and review staged and unstaged changes.
2. Inspect diffs with `git diff --staged` and `git diff` as needed.
3. Stage only the intended files. Prefer specific paths over broad staging.
4. Check recent commits with `git log --oneline -10` to match local tone and scope conventions.
5. Write the commit message using `.ai/commit-message.md`.
6. Create the commit.

## Notes

- If the user says `only staged files` or `staged only`, review only `git diff --staged`, do not run `git add` unless explicitly asked, and create the commit from the current staged set only.
- Prefer scoped subjects like `<area>: <message>`
- Keep the subject concise and lowercase
- Focus on intent and user-visible behavior
- Avoid vague subjects like `misc fixes`
