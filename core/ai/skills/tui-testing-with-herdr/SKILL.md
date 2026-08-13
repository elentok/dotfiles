---
name: tui-testing-with-herdr
description: >-
  Debug or e2e-test a TUI app using Herdr: launch it in an isolated tui-test workspace, drive it
  with keystrokes, read its rendered frames, and assert against expected output. Use only when the
  user explicitly asks to debug or test a TUI app with/via Herdr. Requires HERDR_ENV=1.
---

# TUI Testing with Herdr

This skill layers TUI-specific technique on top of the `herdr` skill. Invoke `herdr` first for CLI
mechanics (IDs, JSON responses, workspace/tab/pane primitives) — this document does not restate
them.

## Setup: isolated tui-test workspace

Every run gets a fresh, isolated workspace so runs never interfere with each other or the user's
layout:

```bash
herdr workspace create --label tui-test --cwd "$PWD" --no-focus
```

Read `.result.workspace.workspace_id` and `.result.root_pane.pane_id` from the response, then launch
the app under test in the root pane:

```bash
herdr pane run <root_pane_id> "<launch command>"
```

Wait for its first frame before interacting:

```bash
herdr pane wait-output <root_pane_id> --match "<text expected once it's up>" --timeout 15000
```

## Reading rendered output

Default to `--source visible`:

```bash
herdr pane read <root_pane_id> --source visible --lines 60
```

TUI apps repaint the full screen instead of scrolling like a log, almost always on the terminal's
alternate screen. `recent`/`recent-unwrapped` only capture host scrollback, so once the app is on
the alternate screen those sources can't see it — `visible` is the one source that reflects what the
app is actually showing right now. Reach for `recent-unwrapped` only after confirming the specific
app doesn't use the alternate screen.

## Sending input

Two primitives, pick per keystroke:

- `herdr pane send-text <pane_id> "<literal characters>"` — typing into a text field or search box.
- `herdr pane send-keys <pane_id> <key> [key...]` — navigation and control: `Enter`, `Tab`,
  `ArrowDown`, `ctrl+c`, `esc`, etc.

Do not use `herdr agent *` commands against this pane — the process under test is an ordinary TUI,
not a Herdr-recognized coding agent, and `agent` commands won't resolve it.

## Waiting for a frame to settle

Redraws are asynchronous after any input. Wait for the expected result instead of guessing at a
delay:

```bash
herdr pane wait-output <pane_id> --match "<expected text>" --timeout 10000
# or
herdr pane wait-output <pane_id> --regex "<pattern>" --timeout 10000
```

When the expected text isn't known in advance (waiting out a spinner or animation), poll instead:
read `--source visible` twice a beat apart and compare, proceeding once two consecutive reads are
identical.

## Debugging workflow

1. Setup: launch the app in a fresh tui-test workspace.
2. Reproduce: send the keystrokes that trigger the reported problem, using the wait-then-read loop
   between each step.
3. Inspect: `pane read --source visible` for the broken frame; `pane process-info` if the process
   may have exited or hung.
4. Diagnose against the source, not guesses — the workspace stays alive for as many rounds of
   poke-and-read as needed.
5. Teardown: `herdr workspace close <workspace_id>`.

## E2E testing workflow

1. Setup: launch the app in a fresh tui-test workspace.
2. Drive the scenario: alternate `send-text`/`send-keys` with the settle strategy above.
3. Assert: each `pane wait-output --match`/`--regex` for an expected transition IS the assertion — a
   timeout means the assertion failed.
4. All assertions passed: teardown — `herdr workspace close <workspace_id>`.
5. An assertion failed or the app crashed: skip teardown, report the workspace/tab/pane IDs plus the
   last `pane read --source visible` output, so the failure can be inspected live instead of guessed
   at from a log.
