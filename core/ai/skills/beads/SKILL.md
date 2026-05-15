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

## Workflow

This skill can be executed in 3 ways:

### 1. No arguments (`/beads`)

1. Run `bd ready` and ask the user which one to start with
2. Run the next workflow

### 2. With issue ID (`/beads <id>`)

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
- `bd human <id>` - Flag for human decision (list/respond/dismiss)
- `bd stale` - Find issues with no recent activity
- `bd orphans` - Find issues with broken dependencies
- `bd search <query>` - Search issues by keyword
- `bd dep add <issue> <depends-on>` - Add dependency (issue depends on depends-on)

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
