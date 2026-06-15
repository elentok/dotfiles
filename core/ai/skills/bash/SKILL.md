---
name: Bash
description: How to write bash scripts. Use when editing bash scripts.
---

## Bash scripts rules

- When done run `shfmt` to format and `shellcheck` for linting (and fix any issues you find)
- Prefer `if [[ ]]; then ... fi` over `[[ ]] && ...`
- Use functions when possible to clean up the code
- Prefer `echo` to `printf`
