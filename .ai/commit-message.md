# Commit Message Rules

When reading this file please explicitly mention that you did.

## Format

```
{subject}

{body}
```

## Subject

- Use a single-line subject only.
- Use lowercase style (no leading capitalized verb).
- Prefer scoped subjects: `<area>: <message>`.
- Keep it concise and specific (about 50-72 chars when possible).

### Scope

- Use a top-level scope for primary area changes, e.g. `nvim`, `git`, ...
- Nested scopes are allowed when they improve clarity, e.g. `nvim: gitsigns: ...`

## Style

- Write in imperative mood (for example: `add`, `fix`, `update`, `refine`).
- Focus on intent and user-visible impact, not implementation details.
- Match existing repo conventions such as:
  - `stage: add interactive staging UI with delta-rendered diffs`
  - `stage: clarify section headers in fullscreen diff view`
  - `worktrees: yank: fix space key not toggling`

## Body

- Mention the behavior change directly.
- Avoid vague subjects like `misc fixes` or `updates`.
- Do not include trailing punctuation.
- Avoid long paragraphs (4 lines max), prefer bullets.

## Quick Checklist

- Is the subject scoped?
- Is the verb imperative?
- Is there a paragraph longer than 4 lines?
- Is the change intent clear in one line?
- Does it match recent commit tone/style?
