# 1. Bypass-in-container for the autonomous loop, auto mode for interactive

Date: 2026-07-02

## Status

Accepted

## Context

`claude-box` runs Claude Code with reduced or no permission prompts. Two
mechanisms are available to keep that safe, and they defend against different
threats:

- **Auto mode** — a classifier model reviews each action before it runs, blocking
  destructive, exfiltrating, or escalating operations. It is a *behavioral* net.
  It runs against the real environment it is launched in, using whatever
  credentials are present, and is a research preview that "does not guarantee
  safety." A prompt-injection that fools the classifier acts on the host.
- **Container isolation** — a *hard* boundary. Whatever runs can only reach the
  mounted workspace, holds no host secrets, and is limited to a network allowlist.
  It caps blast radius but provides no behavioral judgment inside the box.

They compose rather than substitute. The design has two entry points with
different needs:

- **Interactive** (`claude-box`): a human is present; a pause-and-ask on a risky
  action is acceptable and useful.
- **Autonomous** (`claude-beads {epic}`): runs unattended via headless `claude -p`,
  draining a backlog for a long time with no human to answer prompts.

A decisive constraint surfaced during design: **auto mode aborts a headless `-p`
session after repeated classifier blocks** (3 consecutive / 20 total). For an
unattended loop, that turns a few false-positive blocks into a dead run — the
opposite of what an autonomous tool needs.

## Decision

- The **autonomous `claude-beads` loop uses bypass mode**
  (`--dangerously-skip-permissions`). The **container is the safety boundary**:
  cwd-only mount, non-root user, isolated `~/.claude`, egress firewall, and no
  push credentials. There is deliberately no behavioral classifier inside the loop.
- **Interactive `claude-box` defaults to auto mode**, still inside the same
  container. Here both layers apply (classifier + hard boundary), and auto mode's
  pause-on-block behavior is fine because a human is watching. Shift+Tab can reach
  bypass when wanted.

## Consequences

- The unattended loop never stalls on a classifier false positive, and its safety
  rests on isolation we control and can reason about, not on a research-preview
  classifier.
- We accept that inside the `claude-beads` loop there is no behavioral net: within
  the box, a bad action executes. This is bounded by the container, not prevented.
  Untrusted code is therefore only as contained as the mounts and firewall make it.
- Two permission modes must be supported by one image and wired per wrapper, adding
  a little complexity versus a single mode.
- If auto mode later gains a non-aborting headless behavior, revisit whether the
  loop should adopt it as an added net on top of the container.
