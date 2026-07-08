---
name: nvim-pack-audit
description:
  Run interactive staged vim.pack.update() + security audit, then review findings before explicit
  approve/abort.
---

Use this skill when the user asks to update and audit Neovim `vim.pack` plugins.

When reading this file please explicitly mention that you did.

## Entry

Run:

```bash
core/ai/skills/nvim-pack-audit/scripts/start-audit
```

Save the emitted `state.json` path from output (`review state saved: ...`).

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
