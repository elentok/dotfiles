---
name: markdown
description:
  Print the relevant text as raw copy-able markdown and copy it to the clipboard. Run `/markdown
  file` to copy it as a file reference instead, for pasting into Slack.
disable-model-invocation: true
---

## Relevant text

- If you just produced specific text on request (e.g. "write me a reply for X", "draft a message
  about Y"), that text is relevant — not your surrounding commentary.
- Otherwise, your last reply is relevant.

## Steps

1. Identify the relevant text.
2. Print it in a raw markdown code block (fenced with ` ```markdown `) so it's copy-able from the
   terminal.
3. No argument: pipe the relevant text to `blf copy -`.
4. Argument `file`: write the relevant text to a temp file (`.md` extension), then run
   `blf copy-ref <file>` to copy a file reference instead — pastes as a file in Slack rather than
   inline text.
