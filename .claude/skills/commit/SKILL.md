---
name: commit
description: Create a git commit following project conventions. Use when asked to commit, create a commit, or finalize changes.
allowed-tools: Bash(git *)
---

Create a git commit following the rules below.

## Workflow

1. Run `git status` and `git diff --staged` (and `git diff` if nothing staged) to review changes
2. Stage appropriate files with `git add` — prefer specific files over `git add -A`
3. Check recent commits with `git log --oneline -10` to match tone and scope conventions
4. Write the commit message following the rules below
5. Create the commit

## Commit Message Rules

### Format

```
{subject}

{body}
```

### Subject

- Single-line only
- Lowercase (no leading capitalized verb)
- Prefer scoped: `<area>: <message>` (e.g. `nvim: gitsigns: fix toggle`)
- 50–72 chars when possible
- Nested scopes allowed for clarity: `nvim: conform: update formatters`

### Style

- Imperative mood: `add`, `fix`, `update`, `refine`, `remove`
- Focus on intent and user-visible impact, not implementation details

### Body (optional)

- Mention the behavior change directly
- No trailing punctuation
- Max 4 lines per paragraph — prefer bullets for multiple points

### Quick checklist before committing

- If the user says `only staged files` or `staged only`, review only `git diff --staged`, do not run `git add` unless explicitly asked, and create the commit from the current staged set only
- Is the subject scoped?
- Is the verb imperative and lowercase?
- Is the intent clear in one line?
- Does it match recent commit tone/style?

## Arguments

$ARGUMENTS
