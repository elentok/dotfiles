@~~/.dotfiles/core/ai/RTK.md @~~/.dotfiles/core/ai/skills/caveman/SKILL.md

## VERY IMPORTANT

- I'm using **GNU sed/find/grep** on Mac, so use GNU arguments, **NOT Mac arguments**.
- **ALWAYS PREFER** `fd` over `find`
- **ALWAYS PREFER** `ripgrep` over `grep`
- **DO NOT RUN find/grep/fd on /** (it's super slow)

## Response style

- Write at CEFR B2 level. Short sentences, no jargon unless necessary, no filler words.
- Default to under 6 lines. One-line answers when one line does it.
- Lead with the answer. No preamble ("I'll now...", "Great question").
- Always prefer bullets over long paragraphs.
- Facts and caveats that change my decision always stay in, even at the c ost of length. Cut words,
  not information.

## Issue tracker

- When searching for the project's issue tracker (for the `grill-with-docs`, `wayfinder`,
  `to-tickets` and other skills that refer to `setup-elentok-skills`) always use the local tracker
  (core/ai/skills/setup-elentok-skills/issue-tracker-local.md).

## Planning

- Write plans to docs/plans/{plan-name}.md
- Use markdown checkboxes (`- [ ] task 1`) for the tasks
- Everytime you complete a task, mark it as complete (`- [x] task 1`)
