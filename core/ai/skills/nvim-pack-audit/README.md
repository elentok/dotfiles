# nvim-pack-audit

Skill-first workflow for staged `vim.pack.update()` with a security review before promotion.

## Primary Interface

Use the `nvim-pack-audit` skill from Claude Code or Codex.

## Helper Scripts

- `core/ai/skills/nvim-pack-audit/scripts/start-audit`
- `core/ai/skills/nvim-pack-audit/scripts/record-audit <state-json>`
- `core/ai/skills/nvim-pack-audit/scripts/show-summary <state-json>`
- `core/ai/skills/nvim-pack-audit/scripts/show-plugin <state-json> <plugin-name>`
- `core/ai/skills/nvim-pack-audit/scripts/open-audit-report <state-json>`
- `core/ai/skills/nvim-pack-audit/scripts/edit-commit-message <state-json> <output-file>`
- `core/ai/skills/nvim-pack-audit/scripts/approve-update <state-json> [--commit-message-file <path>]`
- `core/ai/skills/nvim-pack-audit/scripts/abort-update <state-json>`
- `core/ai/skills/nvim-pack-audit/scripts/cleanup <state-json>`

## Flow

1. Validate lockfile conflict state and prerequisites.
2. Create temporary staging clone and isolated XDG dirs.
3. Run `vim.pack.update()` headlessly (`force = true`) in staged Neovim.
4. Spawn a sub-agent to audit changed revisions, then record its verdict.
5. Enter interactive review loop for follow-up questions.
6. On `approve`, promote lockfile and commit.
7. On `abort`, keep artifacts for inspection.

## Artifact Policy

Artifacts are retained through the review loop and only removed after successful promotion+commit
completion.

## Promotion Gate

Promotion is refused only when audit verdict is `block`.
