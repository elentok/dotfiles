---
name: commit
description:
  Create a git commit following project conventions. Use when asked to commit, create a commit, or
  finalize changes.
---

Create a git commit following the rules below.

When reading this file please explicitly mention that you did.

## Model Strategy

- When this skill is invoked, delegate commit message drafting to a cheap worker sub-agent.
- Spawn a `worker` sub-agent with model `gpt-5.4-mini` (when using Codex) or `haiku` (when using
  Claude).
- Give the worker one focused task: draft the commit subject/body from repo context and
  `.ai/commit-message.md`.
- Main agent remains responsible for final review and running `git commit`.

## Workflow

1. Run `git status` and review staged and unstaged changes.
2. Inspect diffs with `git diff --staged` and `git diff` as needed.
3. Default behavior is staged-only:
   - only commit already staged files
   - if there are no staged files, **STOP**
4. If the user explicitly asks to stage files, stage only intended paths (no broad staging).
5. Check recent commits with `git log --oneline -10` to match local tone and scope conventions.
6. Spawn a `gpt-5.4-mini` worker sub-agent to draft the commit message.
7. Review and, if needed, edit the worker draft to match repository tone and exact change intent.
8. Create the commit.

## Commit Message Rules

### Format

```
{subject}

{body}
```

### Subject

- Use a single-line subject only.
- Use lowercase style (no leading capitalized verb).
- Prefer scoped subjects: `{area}: {message}`.
- Keep it concise and specific (about 50-72 chars when possible).

### Scope

- Use a top-level scope for primary area changes
- Nested scopes are allowed when they improve clarity (`{top-scope}: {child-scope}: {message}`)
- Run the following script to get the commit scopes from the last 250 commits:

  ```bash
  bash "$(dirname "$SKILL_FILE")/scripts/commit-scopes.sh"
  ```

### Style

- Write in imperative mood (for example: `add`, `fix`, `update`, `refine`).
- Focus on intent and user-visible impact, not implementation details.
- Match existing repo conventions such as:
  - `stage: add interactive staging UI with delta-rendered diffs`
  - `stage: clarify section headers in fullscreen diff view`
  - `worktrees: yank: fix space key not toggling`

### Body

- Mention the behavior change directly.
- Avoid vague subjects like `misc fixes` or `updates`.
- Do not include trailing punctuation.
- Avoid long paragraphs (4 lines max), prefer bullets.

## Notes

- If the user says `only staged files` or `staged only`, review only `git diff --staged`, do not run
  `git add` unless explicitly asked, and create the commit from the current staged set only.
- Instruct the worker that it is not alone in the codebase and must not revert edits made by others.

## Token Tracking (Optional)

Use this when asked to estimate savings from cheap-model drafting.

1. For each commit run, capture:
   - `D`: tokens used by the cheap worker draft step
   - `T`: total tokens for the full commit task
2. Append one line to `docs/commit-token-tracking.csv`:
   - `date,branch,commit_subject,d_tokens,t_tokens,d_over_t`
3. Compute `d_over_t = D / T` per run.
4. After 10 runs, report:
   - average `D/T`
   - estimated savings using `estimated_savings = (D/T) * (1 - C_cheap/C_main)`
5. If exact token counters are unavailable, record a best-effort estimate and mark the row as
   estimated in `commit_subject` suffix: ` [est]`.

## Quick Checklist

- Is the subject scoped?
- Is the verb imperative?
- Is there a paragraph longer than 4 lines?
- Is the change intent clear in one line?
- Does it match recent commit tone/style?
