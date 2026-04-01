# Commit Message Rules

## Format

- Use a single-line subject only.
- Use lowercase style (no leading capitalized verb).
- Prefer scoped subjects: `<area>: <message>`.
- Keep it concise and specific (about 50-72 chars when possible).

## Style

- Write in imperative mood (for example: `add`, `fix`, `update`, `refine`).
- Focus on intent and user-visible impact, not implementation details.
- Match existing repo conventions such as:
  - `stage: add interactive staging UI with delta-rendered diffs`
  - `stage: clarify section headers in fullscreen diff view`
  - `worktrees: yank: fix space key not toggling`

## Scope Guidance

- Use a top-level scope for primary area changes
- Nested scopes are allowed when they improve clarity

## Content Rules

- Mention the behavior change directly.
- Avoid vague subjects like `misc fixes` or `updates`.
- Do not include ticket numbers unless requested.
- Do not include trailing punctuation.
- Prefer bullets to long lines.

## Quick Checklist

- Is the subject scoped?
- Is the verb imperative?
- Is the change intent clear in one line?
- Does it match recent commit tone/style?
