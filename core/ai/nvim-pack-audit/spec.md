# nvim-pack-audit Spec

## Purpose

This workflow provides a single entry point for safely updating Neovim plugins
managed by `vim.pack`, auditing the fetched changes, and optionally promoting
the audited lockfile back into the real dotfiles repo.

Target command:

```sh
core/ai/nvim-pack-audit/nvim-pack-update
```

The workflow is designed around these goals:

- Use `vim.pack.update()` directly instead of reimplementing plugin discovery.
- Keep unreviewed plugin updates out of the real Neovim environment.
- Audit only the actual revisions selected by `vim.pack.update()`.
- Make promotion explicit and reviewable.
- Keep the commit artifact small and readable while still recording the audit.

## Final Layout

The implementation will live under one repo-local directory:

- `core/ai/nvim-pack-audit/nvim-pack-update`
- `core/ai/nvim-pack-audit/security-audit-prompt.md`
- `core/ai/nvim-pack-audit/audit-schema.json`
- `core/ai/nvim-pack-audit/spec.md`
- `core/ai/nvim-pack-audit/README.md`

## Why One Entry Point

We chose a single `nvim-pack-update` entry point instead of separate
`stage-update` and `promote` scripts because:

- the user wants one command for the whole flow;
- staging, audit, summary, promotion, and commit are one cohesive workflow;
- fewer scripts means less state-passing glue and fewer failure modes;
- the promotion decision depends on the audit output anyway, so keeping it in
  one command reduces accidental misuse.

## Workflow Overview

The command performs the following steps:

1. Validate the current repo state.
2. Create a temporary clone of the dotfiles repo.
3. Launch staged Neovim with isolated XDG directories.
4. Run `vim.pack.update()` automatically inside staged Neovim.
5. Detect whether the staged lockfile changed.
6. Run the security audit prompt against the staged update.
7. Print a concise summary of changed plugins and audit verdicts.
8. Ask the user whether to promote the staged lockfile.
9. If accepted and not blocked, copy the staged lockfile into the real repo.
10. Commit the lockfile with a condensed audit summary in the commit body.

## Preconditions

The command must be run from inside the real dotfiles repo.

Required tools:

- `git`
- `jq`
- `nvim`
- `codex`
- `rg`

The command assumes the real lockfile is:

- `core/nvim/nvim-pack-lock.json`

## Repo State Validation

Before any staging work starts, the script must validate the real repo.

### Lockfile Conflict Check

If the real lockfile has unmerged changes, warn and stop the flow.

Examples of states that must stop the flow:

- unresolved merge conflict markers in `core/nvim/nvim-pack-lock.json`
- git index reports conflict stages for that file

Suggested behavior:

- print a clear warning that the lockfile is in a conflicted state;
- explain that promotion would be ambiguous;
- exit without creating a temp clone.

Reasoning:

- the workflow promotes a single staged lockfile back to the real repo;
- if the target file is already conflicted, a successful audit does not tell us
  which side should win;
- stopping early is simpler and safer than trying to merge lockfile state.

### Optional Dirtiness Handling

The broader repo may be dirty; that should not block the workflow by itself.

Reasoning:

- only the lockfile is promoted and committed by this flow;
- unrelated repo changes should not prevent plugin maintenance work.

## Staging Model

We chose a temporary clone, not a worktree.

### Why Temp Clone

A temp clone is simpler and more isolated:

- it avoids interacting with the real repo index and worktree state;
- it avoids accidental reads from live plugin state under the normal XDG dirs;
- it is easier to delete wholesale after success;
- it keeps the mental model clean: staging is disposable.

### Clone Strategy

The command should create a temporary staging directory such as:

```text
/private/tmp/nvim-pack-audit-YYYYMMDD-HHMMSS/
```

Inside it:

```text
repo/
xdg/data/
xdg/state/
xdg/cache/
artifacts/
```

The staging repo should be cloned from the local dotfiles repo.

Important note:

```sh
git clone ~/.dotfiles --depth=1
```

is not a reliable way to get a shallow local clone. For local-path clones, git
often optimizes with local transport semantics, and `--depth=1` may be ignored
or behave differently than expected.

Preferred approaches:

- use a normal local clone for simplicity; or
- use a `file://` URL if true shallow behavior is desired.

Implemented choice:

```sh
git clone --depth=1 "file://$repo_root" "$staging_repo"
```

Reasoning:

- this preserves the desire for a faster clone;
- it makes the depth request meaningful;
- it keeps the source local instead of hitting the network.

We chose this exact form during implementation rather than `git clone
~/.dotfiles --depth=1` because the latter can silently take the local-transport
path where shallow semantics are not the main thing being exercised. `file://`
forces the fetch-style path, which makes the shallow request more predictable.

## Staged Neovim Environment

The staged Neovim process must use isolated XDG paths:

- `XDG_CONFIG_HOME=<staging>/xdg/config`
- `XDG_DATA_HOME=<staging>/xdg/data`
- `XDG_STATE_HOME=<staging>/xdg/state`
- `XDG_CACHE_HOME=<staging>/xdg/cache`

The staging repo should be the config source for Neovim.

Implemented choice:

- create `<staging>/xdg/config/nvim` as a symlink to
  `<staging>/repo/core/nvim`

Expected result:

- plugin fetches and installed plugin revisions live only in the staging area;
- the real plugin installation on the main machine remains untouched;
- the user can interact with `vim.pack.update()` normally.

Reasoning:

- this keeps unreviewed plugin code out of the main environment;
- it lets the audit inspect the exact fetched revisions selected by
  `vim.pack.update()`;
- it reduces accidental state bleed between staging and real usage.

## User Interaction in Neovim

After starting staged Neovim, the script should print a short instruction:

```text
Inside staged Neovim:
1. vim.pack.update() will run automatically
2. Review the confirmation buffer
3. Use :write to apply updates or :quit to cancel
4. Exit Neovim
```

The script then waits for Neovim to exit.

Implemented choice:

- launch Neovim on the staged lockfile path and auto-run:
  `nvim "+lua vim.pack.update()" "$staging_repo/core/nvim/nvim-pack-lock.json"`

Reasoning:

- it gives the user an immediate visible file in the staged config tree;
- it removes a manual step from the workflow and matches the intended single
  entry point behavior;
- it keeps the operator focused on the artifact that will eventually be
  promoted.

### No-Change Handling

If the staged lockfile did not change after Neovim exits, the command should:

- print `no plugin updates applied`;
- exit successfully;
- avoid running the audit or making a commit.

Reasoning:

- no lockfile change means there is nothing new to audit or promote.

## Audit Trigger

If the staged lockfile changed, the script must run Codex with:

- `core/ai/nvim-pack-audit/security-audit-prompt.md`

The prompt is the audit contract. It is repo-local rather than a Codex skill.

### Why Prompt Instead of Skill

We chose a prompt file instead of a skill because:

- this workflow is repo-specific, not a general Codex capability;
- scripts can invoke it directly without relying on skill discovery;
- prompt, schema, and scripts can live together in one directory;
- the workflow is easier to version and review as a unit.

## Audit Inputs

The script must pass enough structured context for the audit to be deterministic.

Required inputs:

- real repo path
- staging repo path
- real lockfile path
- staged lockfile path
- staged plugin installation root
- artifact output directory
- mode: `changed_only` by default

The audit should examine only changed plugins by default.

Reasoning:

- the normal update workflow should review only the revisions selected by the
  current `vim.pack.update()` run;
- auditing every plugin on every run would be unnecessarily slow and noisy.

Implemented choice:

- the script snapshots the pre-update lockfile to
  `artifacts/old-lockfile.json`
- the audit compares `artifacts/old-lockfile.json` against the staged
  `core/nvim/nvim-pack-lock.json`

Reasoning:

- this avoids depending on the real repo state after the staging run begins;
- it gives the audit a stable before/after pair even if the real repo changes
  while the staged Neovim session is open.

## Audit Objectives

The audit must focus on supply-chain and trust-boundary changes, not generic
style review.

Priority areas:

- subprocess and shell execution
- network access
- dynamic code loading
- filesystem writes outside the plugin directory
- install/build hooks
- vendored binaries or executable blobs
- credential access patterns
- widened autocmd/user-command trust boundaries
- repository ownership or source anomalies

The audit should inspect:

- old and new locked revisions
- commit range summary
- changed files
- code patterns relevant to the risk areas above

## Audit Outputs

The audit produces two artifacts:

- `artifacts/audit.json`
- `artifacts/audit.md`

The JSON is for machine decisions.
The Markdown is for human reading and commit-body condensation.

The script also writes:

- `artifacts/summary.txt`
- `artifacts/old-lockfile.json`
- `artifacts/commit-message.txt`

Reasoning:

- `summary.txt` captures the exact operator-facing summary;
- `old-lockfile.json` preserves the before-state used by the audit;
- `commit-message.txt` makes the eventual git commit deterministic and
  inspectable.

### Verdicts

Allowed per-plugin verdicts:

- `approve`
- `manual_review`
- `block`

Rules:

- `block` is reserved for concrete high-risk findings;
- `manual_review` means notable change or uncertainty, but promotion is still
  allowed if the user accepts it;
- the workflow refuses promotion only if any plugin verdict is `block`.

Reasoning:

- the user explicitly wants the refusal policy to be narrow;
- this keeps the workflow usable instead of over-blocking on routine updates.

### Overall Verdict

`overall_verdict` is:

- `block` if any plugin is `block`;
- otherwise `manual_review` if any plugin is `manual_review`;
- otherwise `approve`.

## audit.json Contract

The schema should include at least:

```json
{
  "workflow_version": 1,
  "mode": "changed_only",
  "overall_verdict": "approve",
  "summary": {
    "plugins_changed": 0,
    "plugins_approved": 0,
    "plugins_manual_review": 0,
    "plugins_blocked": 0
  },
  "plugins": [
    {
      "name": "owner/repo",
      "plugin_name": "repo",
      "old_rev": "abc123",
      "new_rev": "def456",
      "verdict": "approve",
      "risk_level": "low",
      "findings": [
        {
          "severity": "low",
          "title": "example finding",
          "details": "brief explanation",
          "files": ["lua/example.lua"]
        }
      ],
      "change_summary": [
        "5 commits",
        "12 files changed"
      ]
    }
  ],
  "commit": {
    "subject": "nvim: update pack lockfile",
    "body_markdown": "..."
  }
}
```

### Commit Subject

The commit subject is fixed:

- `nvim: update pack lockfile`

Reasoning:

- the user explicitly chose this subject;
- the scope matches repo conventions;
- the lockfile is the primary artifact being promoted.

## audit.md Contract

The Markdown report should contain these sections:

- `Overview`
- `Changed Plugins`
- `Findings`
- `Per-Plugin Verdicts`
- `Promotion Recommendation`

It should remain concise and terminal-friendly.

Reasoning:

- the report needs to be readable in the terminal before promotion;
- it also needs to be easy to condense into a commit body.

## Summary Display

After the audit completes, the script should print a concise terminal summary:

- changed plugin count
- plugin name, `old_rev -> new_rev`, and `+added/-removed` totals
- per-plugin verdict
- top finding per plugin when present
- overall verdict
- whether promotion is allowed
- paths to `audit.json` and `audit.md`

Example:

```text
Changed plugins: 3
- snacks.nvim: abc123 -> def456 [approve] (+42/-10)
- gitsigns.nvim: 112233 -> 445566 [manual_review] (+18/-6)
- lazydiff.nvim: aa11bb -> cc22dd [approve] (+7/-1)

Overall verdict: manual_review
Promotion allowed: yes
Audit report: /tmp/.../artifacts/audit.md
```

Reasoning:

- the user wants a summary of the changes plus the audit report;
- the summary should be enough for a quick decision;
- the full report remains available for deeper inspection.

Implemented choice:

- when a plugin has findings, the summary prints only the first finding for that
  plugin;
- when there are no findings at all, it prints `Top findings: * none`
- each plugin summary line includes `lines_added` and `lines_removed`

Reasoning:

- this keeps the summary compact enough to make the promotion prompt usable;
- the line totals help estimate review size at a glance;
- the full `audit.md` remains the place for complete detail.

## Promotion Step

After showing the summary, the script should prompt:

```text
Promote audited lockfile and commit it? [y/N]
```

### Promotion Rules

Promotion is allowed when:

- the user confirms; and
- `overall_verdict` is not `block`

Promotion is refused only when the audit says `block`.

If refused:

- print the blocking findings;
- keep artifacts and staging directory for inspection;
- exit with a distinct non-zero code.

Reasoning:

- this exactly matches the requested policy;
- `manual_review` remains advisory rather than a hard stop.

## Promotion Action

If promotion is accepted:

1. Copy staged `core/nvim/nvim-pack-lock.json` into the real repo.
2. Show the diff for that file.
3. Create a git commit for the lockfile.

Only the lockfile is committed by this workflow.

Reasoning:

- promotion should move only the audited source-of-truth artifact;
- plugin code in the staging area is disposable and must not be committed;
- limiting the commit to the lockfile makes review and rollback simpler.

Implemented choice:

- the script stages and commits only `core/nvim/nvim-pack-lock.json`
- the generated commit message is written to `artifacts/commit-message.txt`
  first, then passed to `git commit -F`

Reasoning:

- this avoids shell-quoting issues from multiline commit bodies;
- it keeps the commit input inspectable if the final commit step fails.

## Commit Body

The commit body must include condensed `audit.md` text.

Required characteristics:

- concise;
- human-readable;
- derived from the audit report;
- include changed plugin revisions and verdicts;
- include top findings, especially any `manual_review` items.

Suggested structure:

```md
update plugins via staged vim.pack workflow

plugins:
- snacks.nvim: abc123 -> def456
- gitsigns.nvim: 112233 -> 445566

audit:
- overall verdict: manual_review
- no blocked plugins
- gitsigns.nvim: new git subprocess helper; argv form, no shell interpolation
```

Important rule:

- do not paste the full `audit.md` into the commit body if it is large;
- condense it to the most important information.

Reasoning:

- the user wants the commit body to carry the change summary and audit result;
- a full raw report would make commits noisy and harder to scan later;
- a condensed version preserves the decision record without bloating history.

## Exit Codes

Recommended exit codes:

- `0`: success, including no-op update or successful promotion
- `1`: operational failure
- `2`: audit verdict `block`, promotion refused
- `3`: user declined promotion

Reasoning:

- this makes the command scriptable later if desired;
- it distinguishes safety refusal from ordinary operational errors.

## Temp Directory Retention

Default behavior:

- remove temp staging directory on successful promotion;
- remove temp staging directory on successful no-op update;
- keep temp staging directory on failure, `block`, or declined promotion.

Optional future flag:

- `--keep-temp`

Reasoning:

- successful runs should clean up after themselves;
- unsuccessful or undecided runs should preserve artifacts for inspection.

## Codex Invocation Details

The implementation runs Codex with:

- `codex exec`
- `--sandbox workspace-write`
- `--ephemeral`
- `--skip-git-repo-check`
- `--output-schema core/ai/nvim-pack-audit/audit-schema.json`

### Why `--ephemeral`

We chose `--ephemeral` during implementation because non-ephemeral `codex exec`
runs attempted to create session state under `~/.codex/sessions`, which is not
necessary for this workflow and can fail in more restricted environments.

Reasoning:

- this workflow is a one-shot audit, not a conversation to be resumed later;
- persistent session state adds an unnecessary filesystem dependency;
- `--ephemeral` keeps the audit run more self-contained and reproducible.

## Out of Scope

The first version does not need to:

- automatically sync the real plugin installation after commit;
- parse `pack.lua` during normal update flow;
- perform automatic rollback of real plugin state;
- block on anything other than `block` verdicts;
- create a separate `promote` script.

Reasoning:

- these features add complexity without improving the core review workflow;
- the first version should stay narrow and dependable.

## Implementation Notes

When implementation starts:

- read `.ai/commit-message.md` before creating the commit;
- validate the lockfile conflict state before cloning;
- prefer deterministic paths and explicit artifact filenames;
- keep the prompt contract strict so the script can trust `audit.json`.

## Future Extensions

Potential later additions:

- `--yes` auto-promote unless blocked
- `--baseline` audit all currently pinned plugins
- richer terminal UI for summary display
- storing baseline audit reports in-repo
- optional sync command hint after commit:
  `:lua vim.pack.update(nil, { target = 'lockfile' })`

These are intentionally deferred to keep the initial workflow small.
