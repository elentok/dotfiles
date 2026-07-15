---
name: nvim-pack-audit
description:
  Run interactive staged vim.pack.update() + security audit, then review findings before explicit
  approve/abort.
---

Use this skill when the user asks to update and audit Neovim `vim.pack` plugins.

## Entry

Run:

```bash
core/ai/skills/nvim-pack-audit/scripts/start-audit
```

If it exits with `no plugin updates applied`, stop here.

Save the emitted `state.json` path from output (`staging ready: ...`).

## Run Audit

1. Read `audit_prompt_path`, `schema_path`, `old_lockfile`, `staged_lockfile`, `plugin_root`,
   `audit_json`, and `audit_md` from `state.json`.
2. Spawn a fresh sub-agent — isolated from this conversation's context — and give it the contents of
   `audit_prompt_path` as its task, followed by a `## Runtime Context` section with
   `mode: changed_only`, `old_lockfile_path: <old_lockfile>`,
   `new_lockfile_path: <staged_lockfile>`, `plugin_root: <plugin_root>`, and
   `audit_md_path: <audit_md>`. The sub-agent must have read/write access to the repo and write its
   JSON verdict to `audit_json` and its Markdown report to `audit_md`.
3. Once the sub-agent finishes, run:
   ```bash
   core/ai/skills/nvim-pack-audit/scripts/record-audit <state-json>
   ```
   This validates `audit.json` against the schema and writes `summary.txt` and `commit-message.txt`.
   If validation fails, re-run the sub-agent.

## Review Loop

While waiting for promotion decision, support:

- `show summary`
  - Run: `core/ai/skills/nvim-pack-audit/scripts/show-summary <state-json>`
- `show plugin <name>`
  - Run: `core/ai/skills/nvim-pack-audit/scripts/show-plugin <state-json> <name>`
- `open audit report`
  - Run: `core/ai/skills/nvim-pack-audit/scripts/open-audit-report <state-json>`
- `edit commit message`
  - Run: `core/ai/skills/nvim-pack-audit/scripts/edit-commit-message <state-json> <output-file>`

Free-form follow-up questions are expected in this state.

## Decision Actions

- `approve`
  - Run:
    `core/ai/skills/nvim-pack-audit/scripts/approve-update <state-json> [--commit-message-file <path>]`
- `abort`
  - Run: `core/ai/skills/nvim-pack-audit/scripts/abort-update <state-json>`

## Artifact Lifecycle

- Keep artifacts through `done-auditing` and review Q&A.
- Keep artifacts on `abort` and `block`.
- Clean artifacts only after successful `approve` flow.
- Optional manual cleanup: `core/ai/skills/nvim-pack-audit/scripts/cleanup <state-json>`
