---
name: vitest
description: How to use Vitest. Use when writing or reviewing Vitest tests.
---

# Vitest best practices

- **ALWAYS ALWAYS ALWAYS** prefer `vi.spyOn` over `vi.mock` when writing unit tests., even if the
  existing code uses `vi.mock`. **ONLY** use `vi.mock` when `vi.spyOn` won't work. The reason for
  this is that `vi.mock` isn't type safe - if the mocked module is removed or changed you won't see
  any errors.
- Always add a blank line between "describe/it" blocks
