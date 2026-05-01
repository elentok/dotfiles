# nvim-pack-audit

Single-entry workflow for staged `vim.pack.update()` runs with a security
review before promotion.

## Entry Point

```sh
core/ai/nvim-pack-audit/nvim-pack-update
```

## Flow

1. Validate the real lockfile is not in an unmerged/conflicted state.
2. Create a temporary clone of the dotfiles repo.
3. Launch Neovim in that staging clone with isolated XDG directories.
4. `vim.pack.update()` runs automatically; review the confirmation buffer and
   confirm with `:write`.
5. Audit changed plugin revisions with Codex using
   `security-audit-prompt.md`.
6. Show a concise summary and ask whether to promote.
7. If accepted and not blocked, copy the staged
   `core/nvim/nvim-pack-lock.json` into the real repo and commit it.

## Artifacts

Each run writes artifacts under the temporary staging directory:

- `artifacts/audit.json`
- `artifacts/audit.md`
- `artifacts/summary.txt`

On success, the temp directory is removed. On failure, `block`, or declined
promotion, it is kept for inspection.

## Refusal Policy

Promotion is refused only when the audit verdict is `block`.
