---
name: commit
description:
  Commit staged git changes, or include current changes only when the user explicitly says
  /commit all or $commit all. Use when asked to commit, create a commit, or finalize changes.
---

Create a git commit following the rules below.

## Workflow

1. Run `git status`.
2. Unless the user explicitly says `/commit all` or `$commit all`:
   - work only from staged changes
   - if there are no staged files, **STOP** and tell the user to say `/commit all` or `$commit all`
     to include current changes, or to name paths to stage
   - if unstaged changes exist, warn the user but do not inspect them
   - invoke `verify` in `staged` mode unless the user says `skip checks`
3. If the user explicitly says `/commit all` or `$commit all`:
   - inspect both staged and unstaged changes
   - stage only the intended paths
   - invoke `verify` in `commit-all` mode unless the user says `skip checks`
4. After `verify`, inspect the final staged snapshot with `git diff --cached`.
5. Unless the user says `skip secret scan`:
   - check availability with `command -v gitleaks`
   - if `gitleaks` is installed, run `gitleaks protect --staged`
   - if `gitleaks` is not installed, report that secret scanning was skipped
6. Infer the subject scope from the final staged paths:
   - if all paths are under one `core/ai/skills/<skill-name>/` directory, use `<skill-name>`
   - if paths span multiple `core/ai/skills/<skill-name>/` directories, use `skills`
   - otherwise, use the shared top-level directory
   - if there is no shared top-level directory, use `repo`
7. Draft the commit message directly.
8. Run a quick checklist, then run `git commit`.

## Commit Message Rules

### Format

- Always write a subject
- Add a body only when at least one is true:
  - the change contains multiple distinct behaviors
  - the rationale is not obvious from the diff
  - the behavior change is risky or user-visible
  - the user explicitly asks for a body

### Subject

- Single-line
- Lowercase (no leading capitalized verb)
- `{scope}: {message}`
- Concise (50~72 chars)
- Imperative (add, fix, remove, update, ...)

### Scope

- Infer it from the changed paths, not commit history
- Nested scopes are allowed when they improve clarity (`{top-scope}: {child-scope}: {message}`)

### Body

- Explain what changed and why
- Do not write an implementation diary
- Prefer short paragraphs or bullets
- Keep paragraphs to 2 lines max

## Quick Checklist

- Is the subject scoped?
- Is the verb imperative?
- Is the change intent clear in one line?
- Does the body exist only when it adds value?
- Is there any paragraph longer than 2 lines?
