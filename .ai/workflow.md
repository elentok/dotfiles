# AI Agent Workflow

When reading this file please explicitly mention that you did.

## Plan mode

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

## Subagents

- Use subagents liberally to keep main contect window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

## Self-improvement loop

- After ANY correction from the user: update 'docs/lessons.md' with the pattern
- Write rules for yourself in `.ai/` that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

## Verification

- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

## Demand elegance (Balanced)

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

## Autonomous bug fixing

- When given a bug report: just fix it. Don't ask for hand-holding
- Before fixing a bug try to write tests that catch it and after you fix it verify the test passes
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task management

1. **Plan first**: Write plan to tasks/todo.md with checkable items
2. **Verify plan**: Check in before starting implementation
3. **Track progress**: Mark items complete as you go
4. **Explain changes**: High-level summary at each step
5. **Document results**: Add review section to tasks/todo.md
6. **Capture lessons**: Update tasks/lessons.md after corrections

## Core Principles

- **Simplicity first**: Make every change as simple as possible. Impact minimal code.
- **No laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal impact**: Changes should only touch what's necessary. Avoid introducing bugs.
