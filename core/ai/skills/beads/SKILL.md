---
name: beads
description:
  Use for project task tracking, dependency management, and multi-session handoff with Beads.
  Trigger when the user explicitly asks for Beads/task tracking, when a side-quest/follow-up issue
  is identified (offer to create it in Beads), or when finalizing a plan so plan tasks are tracked
  in Beads.
---

Use Beads as the shared project task system. Local plans, scratch files, and personal memories are
useful, but they are not the durable source of truth for project work.

# Beads

## First step

Run `bd where` to check that the project has **beads** set up, if not tell the user they should run
`bd init`.

## Arguments

This skill can be executed in 3 ways:

### 1. With issue ID (`/beads <id>`)

Follow the "Resolving an issue" instructions

### 2. No arguments (`/beads`)

1. Run `bd ready` and ask the user which one to start with (recommend which one we should start
   with) - use Claude's question UI to pick
2. Run the first workflow ("With issue ID")

### 3. Add (`/beads add ...`)

1. Follow the "Creating an issue" instructions

## Creating an issue

1. Before creating the issue, make sure it's clear enough, interview me relentlessly about every
   aspect of this issue until we reach a shared understanding. Walk down each branch of the design
   tree, resolving dependencies between decisions one-by-one. For each question, provide your
   recommended answer.
2. Once the issue is clear create it by running:
   ```bash
   bd create "Short title" --description="Why this exists and what needs to be done" --type=task --priority=2
   ```
3. If the issue is complex create sub-tasks (use sub-agents to create multiple in parallel)
   ```bash
   bd create "Subtask" --description="..." --type=task --parent={parent-id}
   ```

## Resolving an issue

1. Run `bd show <id>`, if it's not open tell the user and stop
2. Run `bd update <id> --claim` to claim the issue
3. If implementation reveals new tasks, create follow-up issues (use sub-agents to run multiple
   command in parallel):

   ```bash
   bd create "Short title" --description="Why this exists and what needs to be done" --type=task --priority=2
   ```

4. When done ask the user for permission to close the ticket and run:

   ```bash
   bd close <id> --reason="Completed"
   ```

   You can close multiple tickets with `bd close <id1> <id2> ...` (more efficient)

## Essential Commands

- **WARNING**: Do NOT use `bd edit` - it opens $EDITOR (vim/nano) which blocks agents
- **DO NOT** inject `bd prime`, it forces a commit & push workflow which I don't want.
- `bd supersede <id> --with=<new-id>` - Mark issue as superseded
- `bd human list` / `bd human respond <id>` / `bd human dismiss <id>` - Human-decision workflow
- `bd stale` - Find issues with no recent activity (including abandoned in-progress)
- `bd orphans` - Find issues referenced in commits that are still open
- `bd dep cycles` - Find issues with circular/broken dependencies
- `bd search <query>` - Search issues by keyword
- `bd note <id> "text"` - Append a note (agent-safe; no editor)
- `bd dep add <issue> <depends-on>` - Add dependency (issue depends on depends-on)
- `bd dep <blocker-id> --blocks <blocked-id>` - Alternative: mark blocker explicitly

## What Belongs In Beads

Use Beads for:

- shared project tasks
- blockers and dependencies
- discovered follow-up work
- work that must survive thread reset, compaction, or handoff
- status that another person or agent should be able to resume

Use agent-local planning tools only for the current turn's execution checklist. Do not treat them as
shared project state.

## Rules

- Do not create markdown TODO files as the source of truth when Beads is available.
- Do not use `bd edit`; it opens an interactive editor. Use `bd update` flags instead.
- Prefer `--json` when parsing `bd` output programmatically.
- **DO NOT** inject `bd prime`, it forces a commit & push workflow which I don't want.
- Do not auto-close or mutate tasks unless the work is actually complete.
