---
name: commit
description:
  Create a git commit following project conventions. Use when asked to commit, create a commit, or
  finalize changes.
---

Create a git commit following the rules below.

When reading this file please explicitly mention that you did.

## Model Strategy

- Use a cheap sub-agent for commit analysis and draft preparation.
- Use `gpt-5.4-mini` in Codex or `haiku` in Claude.
- The sub-agent gathers commit context, proposes the message, and runs checklist validation.
- The main agent keeps authority over staging decisions, final message edits, and `git commit`.

## Workflow

1. Run `git status` and review staged and unstaged changes.
2. Default behavior is staged-only:
   - only commit already staged files
   - if there are no staged files, **STOP**
3. If the user explicitly asks to stage files, stage only intended paths (no broad staging).
4. Spawn the cheap sub-agent and have it:
   - gather context from `git diff --staged`, optional `git diff`, `git log --oneline -10`, and
     `bash "$(dirname "$SKILL_FILE")/scripts/commit-scopes.sh"`
   - summarize the behavior-level change
   - propose 3 candidate subjects
   - draft the final subject and body
   - validate the result against the checklist
   - review staged changes for:
     - Secrets or tokens
     - Accidental debug logging

5. Require worker output in this shape:
   - `summary:` 3-6 bullets of behavior-level changes
   - `candidate_subjects:` exactly 3 options
   - `final_subject:` 1 selected subject
   - `final_body:` body text
   - `checklist:` pass/fail per checklist item
6. Review the worker output, edit if needed, then run `git commit`.

## Commit Message Rules

### Format

```
{subject}

{body}
```

### Subject

- Single-line
- Lowercase (no leading capitalized verb).
- `{scope}: {message}`.
- Concise (50~72 chars).
- Imperative (add, fix, ...)

### Scope

- Nested scopes are allowed when they improve clarity (`{top-scope}: {child-scope}: {message}`)
- Get existing scopes (add new if missing):

  ```bash
  bash "$(dirname "$SKILL_FILE")/scripts/commit-scopes.sh"
  ```

### Body

- What/why, not implementation diary
- Avoid vague subjects like `misc fixes` or `updates`
- 2 line paragraphs max
- Prefer bullets

## Token Tracking

This helps estimate savings from cheap-model offloading.

1. For each commit run, capture:
   - `D`: tokens used by the cheap worker analysis/prep step
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
