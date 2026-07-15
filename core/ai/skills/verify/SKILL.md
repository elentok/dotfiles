---
name: verify
description:
  Verify changed files after completing a task or before commit using cheap targeted checks. Use for
  staged, commit-all, or working-changes verification when handing work back or when another skill
  needs changed-file checks.
---

Run cheap, targeted verification for changed files.

## Workflow

1. Select the mode:
   - `staged`: when invoked by normal `commit`
   - `commit-all`: when invoked by `commit` for `/commit all` or `$commit all`
   - `working-changes`: when verifying after completing a task outside the commit flow
2. Discover files for the selected mode:
   - `staged`: use tracked files from `git diff --cached --name-only --diff-filter=ACMR`
   - `commit-all`: use tracked files from `git diff --name-only HEAD --diff-filter=ACMR` plus
     untracked files from `git ls-files --others --exclude-standard`
   - `working-changes`: use tracked files from `git diff --name-only HEAD --diff-filter=ACMR` plus
     untracked files from `git ls-files --others --exclude-standard`
   - deduplicate the file list
3. Apply the check table. Run every matching command and never invent extra checks.
4. Run formatters before analyzers or tests.
5. If a formatter changes files:
   - in `staged` mode, run `git add` on the formatted files that were already staged
   - in `commit-all` mode, run `git add` on the formatted files that are part of the intended commit
   - in `working-changes` mode, do not stage files; report that formatting changed the working tree
6. Report exactly one result:
   - `pass`: at least one check ran and every command passed
   - `fail`: any command failed
   - `no applicable checks`: no file matched the check table

## Check Table

- Shell:
  - files matching `*.sh`
  - files without an extension whose first line starts with `#!` and names `sh`, `bash`, or `zsh`
  - run `shfmt -w <shell-files>`
  - run `shellcheck <shell-files>`
- Python:
  - files matching `*.py`
  - run `basedpyright <python-files>`
  - run `ty check <python-files>`
- Go:
  - files matching `*.go`
  - run `gofmt -w <go-files>`
  - for each unique directory containing a matched Go file, run `go test ./<dir>`; use `go test .`
    for files in the repo root
- No matches:
  - report `no applicable checks`

## Boundaries

- Do not run whole-repo build, lint, format, or test commands unless the user explicitly asks.
- Do not perform secret scanning or semantic review; those belong to the caller.
