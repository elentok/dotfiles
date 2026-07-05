# PRD: claude-box — sandboxed Claude Code

## Problem Statement

I want to run `claude --dangerously-skip-permissions` without risking my machine.
Bypass mode removes every confirmation prompt, so a malicious repo, a bad
dependency, or a prompt-injection could delete files, exfiltrate my Claude
credentials, or reach arbitrary network endpoints — all on my real home directory
with my real secrets. I also want to run Claude fully unattended against a beads
epic (implement each task, commit, move on), which is only sane if it's boxed in.
And I need the same setup to work on two machines with two different auth backends:
the $20 Pro subscription at home, and AWS Bedrock at work.

## Solution

A hardened Docker image plus two terminal wrappers:

- **`claude-box`** — launches an interactive, isolated Claude session in **auto
  mode** (Shift+Tab reaches bypass inside the box). For sandboxed interactive work
  and exploring untrusted repos.
- **`claude-beads {epic}`** — an autonomous outer loop that drains a beads epic in
  **bypass** mode: take the next unblocked task, implement, verify, commit, repeat,
  with fix-and-continue on failure and a circuit breaker.

The container mounts only the current project, keeps its own isolated `~/.claude`,
firewalls outbound traffic to an allowlist, and never receives push credentials.
Provider (subscription vs Bedrock) is a per-machine setting, so one image serves
both machines.

## User Stories

1. As a developer, I want to launch Claude in a container from any terminal, so that a bypass-mode session cannot touch anything outside the project.
2. As a developer, I want only my current project directory mounted into the box, so that a rogue session cannot read the rest of my home directory.
3. As a developer, I want to opt specific extra directories in explicitly, so that legitimate cross-repo work is possible but never accidental.
4. As a developer, I want the container to run as a non-root user, so that Claude Code will accept `--dangerously-skip-permissions` and the blast radius is smaller.
5. As a developer, I want outbound network traffic restricted to an allowlist, so that a compromised session cannot exfiltrate my credentials to an arbitrary host.
6. As a developer, I want to extend the network allowlist per launch, so that a task needing a new registry or internal host can proceed without editing the image.
7. As a home user, I want the box to use my $20 Pro subscription, so that I don't pay per token.
8. As a home user, I want to log in once and have the token persist across runs, so that I'm not re-authenticating every session.
9. As a work user, I want the box to use AWS Bedrock, so that my source code stays in my VPC and never routes to api.anthropic.com.
10. As a work user, I want my existing AWS auth (SSO/profile/role) resolved into short-lived credentials injected into the box, so that no long-lived keys or `~/.aws` files enter the container.
11. As a work user, I want a clear "run aws sso login" message when my AWS session is expired, so that I'm not debugging a cryptic failure.
12. As a developer, I want the provider chosen per machine via one setting, so that home "just works" and work sets it once.
13. As a developer, I want my Claude skills and CLAUDE.md available inside the box, so that the sandboxed Claude behaves like my real setup.
14. As a developer, I want my skills mounted read-only and always current, so that editing a skill on the host takes effect without rebuilding the image and a bypass session can't corrupt my dotfiles.
15. As a developer, I want the container's `~/.claude` isolated from my host's, so that my host settings, history, and MCP config are neither read nor corrupted by the box.
16. As a developer, I want commits made in the box to use my correct identity, so that history is attributed properly — my work email at work, personal at home.
17. As a developer, I want no push credentials in the box, so that I review and push results myself and nothing can push on my behalf.
18. As a developer, I want commit signing disabled in the box, so that no signing key needs to live there.
19. As a developer, I want `claude-beads {epic}` to pick the next unblocked task, implement it, and commit, repeating until the epic is drained, so that a backlog can be worked unattended.
20. As a developer, I want each task run with fresh context, so that context bloat and mid-epic derailing don't accumulate.
21. As a developer, I want the loop to own beads state transitions, so that task status is deterministic and doesn't depend on Claude remembering to update it.
22. As a developer, I want a task's result verified (a commit landed, and optionally tests pass) before it's accepted, so that broken work isn't silently marked done.
23. As a developer, I want a failing task to trigger a repair pass by a fresh agent rather than being skipped, so that flaky tasks still make progress.
24. As a developer, I want the repair passes bounded, so that one unfixable task can't burn my whole token budget.
25. As a developer, I want a task that exhausts its repairs marked blocked with a note, so that I can find and address it later without halting the epic.
26. As a developer, I want the loop to halt after several consecutive blocked tasks, so that a systemic problem (bad build, expired creds) stops the run instead of thrashing.
27. As a developer, I want an optional hard iteration cap, so that a runaway loop can't run indefinitely overnight.
28. As a developer, I want a per-run verify command via env, so that repos with tests get a real gate and repos without one still work (commit-landed gate).
29. As a developer, I want the image to be lean and separate from my dotfiles-testing image, so that the attack surface stays small and rebuilds stay fast.
30. As a developer, I want `rtk` available in the box, so that my mounted CLAUDE.md's "prefix commands with rtk" rule works unmodified.
31. As a developer, I want `bd` available in the box, so that the beads loop and beads skill operate on the project's `.beads/` directory.
32. As a developer, I want the same import in my CLAUDE.md to resolve on both macOS and Linux, so that no per-platform path juggling is needed.
33. As a maintainer, I want the core logic (loop engine, run-args, resolvers, firewall allowlist) testable without Docker or network, so that I can trust changes without a full end-to-end run.
34. As a developer, I want my host's configured MCP servers available inside the box, so that tools like `gopls-mcp` work the same as they do outside the sandbox.
35. As a developer, I want only the `mcpServers` key copied out of `~/.claude.json`, so that the rest of my host's Claude config (OAuth tokens, project history, machine id) never enters the box.
36. As a developer, I want the MCP server list re-synced on every launch, so that adding or removing a server on the host takes effect on the next run without a rebuild.
37. As a developer, I want `playwright-cli` and a headless Chromium available in the box, so that the `playwright-cli` skill works for sandboxed browser automation.

## Implementation Decisions

- **Two wrappers, one image.** `claude-box` (interactive, auto mode) and `claude-beads` (autonomous, bypass) share one lean Debian/Ubuntu image with a non-root user. Auto mode is unsuitable for the unattended loop because it aborts headless `-p` sessions after repeated classifier blocks; the container is the safety boundary there instead. See ADR on bypass-in-container vs auto-mode.
- **Image toolchain:** Node (for Claude Code), Python, Go, `git`, `bd` (Linux), `rtk` (Linux), `rg`/`fd`/`jq`, firewall tooling. Claude Code version pinned with `DISABLE_AUTOUPDATER=1`.
- **Modules:**
  - *Run-context resolver* (`lib/common.sh`): env + cwd + per-machine config → resolved context (provider, mounts, git identity, extra dirs).
  - *Credential resolver*: subscription → named volume `claude-box-home`; Bedrock → `aws configure export-credentials --format env` injected as short-lived env creds, plus `AWS_REGION`, `CLAUDE_CODE_USE_BEDROCK=1`, `CLAUDE_CODE_ENABLE_AUTO_MODE=1`, model from `CLAUDE_BOX_BEDROCK_MODEL`.
  - *Docker run-args builder*: resolved context → array of `docker run` flags (mounts, `NET_ADMIN`/`NET_RAW` caps, volumes, env). Pure function.
  - *Beads loop engine*: the fix-and-continue state machine, with `claude`/`bd`/verify-command injected as commands so control flow is testable against fakes.
  - *Verify gate*: commit-landed check + optional `CLAUDE_BEADS_VERIFY_CMD` → pass/fail.
  - *Firewall* (`init-firewall.sh`): allowlist-assembly (pure, extracted) + iptables application (root, integration). Provider-aware base list + `EXTRA_ALLOWED_DOMAINS`.
  - *entrypoint.sh*: run firewall as root, then exec the workload as the non-root user.
- **Provider selection:** `CLAUDE_BOX_PROVIDER` (default `subscription`) read from a git-ignored per-machine config.
- **Mounts:** cwd → `/workspace` (rw); `--add-dir`-style opt-in for extra dirs; read-only host `~/.dotfiles/core/ai` → `$HOME/.dotfiles/core/ai`; isolated named volume at `~/.claude`; baked `~/.claude/skills` symlink → `$HOME/.dotfiles/core/ai/skills`.
- **Git identity:** injected via `GIT_AUTHOR_*`/`GIT_COMMITTER_*` from `git -C <cwd> config --get user.{name,email}` (repo-local override wins). No `~/.gitconfig` mount, no push creds, signing off.
- **Beads data** rides in via the `/workspace` mount (per-project `.beads/`); `bd` runs in-container; embeddeddolt backend must run headless.
- **MCP server sync:** `resolve_mcp_config` (`lib/common.sh`) extracts just the `mcpServers` key from the host's `~/.claude.json` (default `{}` if absent) into a temp file on every launch, mounted **read-write** at the container's `/home/dev/.claude.json` — read-write because that file already gets rebuilt fresh each run (it sits outside the `claude-box-home` named volume) and Claude Code writes to it continuously. The file is created under `$HOME/.cache/claude-box/` (pruned on each call), not the system temp dir — Docker Desktop on macOS did not reliably bind-mount `mktemp`'s default `$TMPDIR` location (`/var/folders/...`) or even `/private/tmp` paths in testing, silently mounting an empty directory instead of the file despite both being in Docker Desktop's documented default share list; only `$HOME` paths mounted reliably. Config sync is generic and doesn't provision binaries per server; `gopls-mcp` (the one server in active use) and `playwright-cli` + headless Chromium (for the `playwright-cli` skill) are installed explicitly in the Dockerfile. A remote/HTTP-type MCP server's domain would need `EXTRA_ALLOWED_DOMAINS` like any other new host — no special-casing.
- **Loop failure ladder:** implement → repair×K (default 2, `CLAUDE_BEADS_MAX_REPAIRS`) → mark blocked + note → halt after 3 consecutive blocked. Optional `CLAUDE_BEADS_MAX_ITER` hard cap. Wrapper owns beads state; the task prompt instructs Claude not to change bead status.
- **Dotfiles prerequisite:** change `~/.claude/CLAUDE.md` import from absolute `/Users/david/...` to home-relative `@~/.dotfiles/core/ai/AGENTS.md` (`~` expands to `$HOME` on both platforms; officially supported).
- **Layout:** `core/ai/claude-box/{Dockerfile,init-firewall.sh,entrypoint.sh,bin/{claude-box,claude-beads},lib/common.sh}`.

## Testing Decisions

- **What makes a good test:** assert external behavior of a module through its
  interface, not internals. Inject dependencies (the `claude`, `bd`, `aws`, and
  verify commands) as fakes so tests never touch Docker, the network, or a real
  Claude session. A test feeds inputs (env, cwd, fake command outputs) and asserts
  the observable result (the built arg list, the sequence of bead state
  transitions, the pass/fail verdict, the assembled allowlist).
- **Framework:** introduce **bats-core** (added to the Brewfile). No shell test
  framework exists today; scripts must be structured so pure logic is callable in
  isolation. Continue using `shfmt` (format) and `shellcheck` (lint) as today.
- **Modules under test:**
  - *Beads loop engine* — fake `claude`/`bd`/verify; assert the failure ladder
    (success, repair-then-pass, repair-exhausted→blocked, consecutive-blocked→halt,
    max-iter cap, no-ready-tasks stop) and that the wrapper owns state transitions.
  - *Docker run-args builder* — assert the flag array per provider, with/without
    `--add-dir`, correct caps, mounts, and volumes.
  - *Run-context + credential resolver* — fake env and stubbed `aws`; assert
    provider defaulting, git-identity resolution (repo-local override), and
    Bedrock env/cred injection incl. the expired-session fail-fast.
  - *Firewall allowlist assembly* — assert the domain list per provider and that
    `EXTRA_ALLOWED_DOMAINS` extends it (the extracted pure function, not iptables).
- **Prior art:** none in-repo; establish the `bats` convention with this feature.

## Out of Scope

- VS Code / JetBrains devcontainer integration (terminal-only by decision).
- Pushing from inside the box, or any git write credentials in the container.
- Sharing beads across repos via a host daemon (beads rides the workspace mount).
- Reproducing the full dotfiles environment (fish/nvim) inside the box.
- Auto mode for the unattended loop (uses bypass by decision).
- Multi-user / team rollout, managed-settings policy distribution.

## Further Notes

- Known gotcha: auto mode can be unavailable with Bedrock **inference profiles**
  (vs direct model IDs). Verify against the actual work model.
- macOS stores the subscription OAuth token in Keychain, not a file, so the
  subscription path must be a fresh in-container browser login persisted in the
  named volume — mounting host creds is not an option.
- The `rtk` decision is load-bearing: without it in the image, the mounted
  CLAUDE.md's "prefix with rtk" rule makes every command fail.
