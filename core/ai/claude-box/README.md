# claude-box

A hardened Docker sandbox for running Claude Code with reduced or no
permission prompts, plus an autonomous beads-loop wrapper. One image, two
entry points:

- **`claude-box`** — interactive session in **auto mode** (Shift+Tab reaches
  bypass inside the box). For exploring untrusted repos or general sandboxed
  work.
- **`claude-beads <epic-id>`** — autonomous loop that drains a beads epic in
  **bypass** mode: claim next ready task, implement with a fresh `claude -p`,
  verify, commit, repeat, with fix-and-continue on failure and a circuit
  breaker.

Full rationale: [`docs/prds/claude-box.md`](../../../docs/prds/claude-box.md)
and [`docs/adr/0001-bypass-in-container-vs-auto-mode.md`](../../../docs/adr/0001-bypass-in-container-vs-auto-mode.md).

## Security model

- Only the current project directory is mounted read-write (`--add-dir` to
  opt in more, explicitly, per launch).
- Runs as non-root user `dev` inside the container.
- Outbound network is default-deny, allowlisted per provider (see
  `init-firewall.sh`); extend with `EXTRA_ALLOWED_DOMAINS`.
- `~/.claude` inside the container is an isolated named Docker volume — never
  the host's `~/.claude`.
- The host's configured MCP servers (`mcpServers` from `~/.claude.json`) are
  synced into the container's `~/.claude.json` fresh on every launch — only
  that key, never the rest of the host file (OAuth tokens, project history,
  etc.). If a server's config carries a secret in its `env` block, that
  secret enters the box the same way Bedrock credentials and the
  subscription OAuth token already do — treat it with the same care.
- No git push credentials and no commit signing key are ever placed in the
  container; commits use the host repo's `user.name`/`user.email`, injected
  via `GIT_AUTHOR_*`/`GIT_COMMITTER_*`.
- `claude-beads` uses bypass mode (`--dangerously-skip-permissions`) with the
  container itself as the safety boundary — there is deliberately no
  behavioral classifier inside the loop, because auto mode aborts headless
  `claude -p` sessions after repeated classifier blocks. `claude-box` defaults
  to auto mode since a human is present to answer prompts. See the ADR above
  for the full tradeoff.

## Setup

Requires Docker Desktop (or another Docker engine) running locally. The image
builds automatically on first run of either wrapper; rebuild with
`docker build -t claude-box:latest core/ai/claude-box`.

**Docker Desktop file sharing:** only mount paths Docker Desktop is
configured to share (by default `/Users`, `/Volumes`, `/private`, `/tmp`) will
actually contain your files inside the container — a path outside that scope
silently bind-mounts as an *empty* directory instead of failing loudly. Run
`claude-box`/`claude-beads` from a project under your home directory.

### Provider selection

Provider is a per-machine setting, read (in precedence order) from the
`CLAUDE_BOX_PROVIDER` env var, then a git-ignored config file at
`~/.config/claude-box/config.sh` (override with `CLAUDE_BOX_CONFIG`), then
defaults to `subscription`.

```bash
# ~/.config/claude-box/config.sh
CLAUDE_BOX_PROVIDER=bedrock
CLAUDE_BOX_BEDROCK_MODEL=anthropic.claude-...
```

- **`subscription`** (default, e.g. home): uses the $20 Pro subscription.
  Auth is a one-time in-container browser login (`claude` prompts for it on
  first use); the OAuth token persists in the `claude-box-home` named volume
  across runs. macOS's Keychain-based token storage is why this can't just be
  a host mount — the box does its own login instead.
- **`bedrock`** (e.g. work): resolves your existing AWS auth (SSO/profile/role)
  via `aws configure export-credentials --format env` and injects short-lived
  credentials as container env vars — no long-lived keys, no `~/.aws` mount.
  Fails fast with a `run 'aws sso login'` message if the host AWS session is
  expired. Set `CLAUDE_BOX_BEDROCK_MODEL` to your model id; auto mode may not
  be available for Bedrock **inference profiles** (vs. direct model ids) —
  verify against your actual work model.

## `claude-box`

```
claude-box [--add-dir DIR]... [-- CMD...]
```

Launches an isolated, interactive Claude Code session. Only `$PWD` is mounted
read-write at `/workspace`, plus any `--add-dir` paths (mounted at their same
absolute path). With no `CMD`, drops into an interactive shell; pass a `CMD`
after `--` to run something else, e.g. `claude-box -- claude`.

## `claude-beads`

```
claude-beads <epic-id> [--add-dir DIR]...
```

Autonomously drains a beads epic: claims the next ready task
(`bd ready --parent=<epic> --claim`), implements it with a fresh
`claude -p --dangerously-skip-permissions`, verifies, repairs on failure, and
marks exhausted tasks blocked. The wrapper — not `claude` — owns all beads
state transitions (claim/close/blocked+note); each task's prompt explicitly
tells the model not to touch bead status.

**Verify gate:** a task passes if a commit landed and, when
`CLAUDE_BEADS_VERIFY_CMD` is set, that command exits 0. With no verify command
configured, a landed commit alone is accepted (a commit-landed-only gate) —
set `CLAUDE_BEADS_VERIFY_CMD` to something like `npm test` for a real gate.
As a safety net against no-op closes, a task is also never closed if claude
made **zero tool calls** that attempt (a session limit, a refusal, or an empty
response), since real work always makes tool calls — the commit would have to
be stale or pre-existing. This guard needs streaming on and can be turned off
with `CLAUDE_BEADS_REQUIRE_ACTIVITY=0`.

**Failure ladder:** implement → up to `CLAUDE_BEADS_MAX_REPAIRS` (default `2`)
repair passes, each a fresh `claude -p` seeded with the previous diff and
verify output → mark blocked with a note on exhaustion. The loop halts after
3 consecutive blocked tasks (circuit breaker — a systemic problem like a
broken build or expired creds should stop the run, not thrash task after
task) or after `CLAUDE_BEADS_MAX_ITER` tasks if set (unset/`0` = unbounded).

**Output & logs:** each `claude -p` runs in `stream-json` mode, formatted into
readable lines (assistant text plus a one-liner per tool call) so a running
task shows progress live instead of going silent until the turn ends (the
default buffered `text` output prints only at the very end). The same stream is
written to a per-run transcript at `.claude-beads/logs/<timestamp>-<epic>.log`
— because `$PWD` is bind-mounted into the container, you can `tail -f` it from
the host while the loop runs. The `.claude-beads/` dir is self-gitignored.
Relocate with `CLAUDE_BEADS_LOG_DIR`; set `CLAUDE_BEADS_STREAM=0` to revert to
plain buffered output.

**Session/usage limits:** when `claude -p` bails with "You've hit your session
limit · resets ...", the loop detects it and refuses to close or block that
task — the work never actually happened, so it's handed back to the ready pool
untouched (this also avoids the failure mode where a stale or coincidental
commit made a limited task read as `verified`). By default
(`CLAUDE_BEADS_WAIT_ON_LIMIT=1`) the loop then sleeps until the reported reset
time (capped by `CLAUDE_BEADS_MAX_WAIT`, default 6h) and resumes on the same
task; set it to `0` to stop instead and just re-run later — the released task
is picked up again from where it left off. The stop reason `session_limit` is
reported when it stops rather than waits.

## Environment variables

| Variable | Applies to | Default | Purpose |
|---|---|---|---|
| `CLAUDE_BOX_PROVIDER` | both | `subscription` | `subscription` or `bedrock` |
| `CLAUDE_BOX_BEDROCK_MODEL` | both | — | Model id for the `bedrock` provider |
| `CLAUDE_BOX_CONFIG` | both | `~/.config/claude-box/config.sh` | Per-machine config file path |
| `CLAUDE_BOX_IMAGE` | both | `claude-box:latest` | Image tag to build/run |
| `EXTRA_ALLOWED_DOMAINS` | both | — | Comma-separated extra firewall-allowed domains |
| `CLAUDE_BEADS_VERIFY_CMD` | `claude-beads` | — | Shell command run to verify a task; non-zero fails the task |
| `CLAUDE_BEADS_MAX_REPAIRS` | `claude-beads` | `2` | Repair passes allowed beyond the first attempt |
| `CLAUDE_BEADS_MAX_ITER` | `claude-beads` | `0` (unbounded) | Hard cap on tasks attempted per run |
| `CLAUDE_BEADS_MODEL` | `claude-beads` | `sonnet` | Model passed to `claude -p` for implement/repair; empty = account default |
| `CLAUDE_BEADS_STREAM` | `claude-beads` | `1` | Stream `claude -p` output live (stream-json); `0` reverts to buffered text |
| `CLAUDE_BEADS_LOG_DIR` | `claude-beads` | `.claude-beads` | Directory for per-run transcripts (`<dir>/logs/`, self-gitignored) |
| `CLAUDE_BEADS_WAIT_ON_LIMIT` | `claude-beads` | `1` | On a session/usage limit, sleep until the reported reset and resume; `0` stops instead |
| `CLAUDE_BEADS_MAX_WAIT` | `claude-beads` | `21600` (6h) | Max seconds to sleep waiting for a limit reset before giving up and stopping |
| `CLAUDE_BEADS_REQUIRE_ACTIVITY` | `claude-beads` | `1` | Refuse to close a task if claude made zero tool calls (no real work); `0` disables. Needs streaming on |
| `--add-dir DIR` | both (CLI flag) | — | Additional host directory to mount read-write, at the same path |

MCP servers configured in the host's `~/.claude.json` (`mcpServers`) sync
into the container automatically — no separate variable or flag. A server's
config syncs even if its binary isn't installed in the image; it just won't
start until the binary is added (the image currently bundles `gopls-mcp`
and Playwright/Chromium for the `playwright-cli` skill, to match the two
tools actually referenced by mounted skills).

**Known limitation — `playwright-cli` page navigation:** the browser
launches successfully inside the container, but `playwright-cli goto`
currently hangs/times out even against firewall-allowlisted domains, while
plain `curl` to the same hosts succeeds. Neither a `--no-sandbox` Chromium
launch arg nor `--cap-add=SYS_ADMIN` fixed it, so it isn't a container
sandbox-capability issue. Leading unconfirmed theory: `init-firewall.sh`
resolves each allowlisted domain to specific IPs once at container startup;
if a domain round-robins across multiple IPs, Chromium's own DNS lookup at
request time can land on an IP the firewall never allowlisted. Not yet
root-caused — flagged here rather than worked around with a broader
capability grant.

## Testing

Pure logic (loop engine, run-args builder, resolvers, firewall allowlist
assembly) is unit-tested with [bats-core](https://github.com/bats-core/bats-core)
against fakes — no Docker or network required:

```bash
core/ai/claude-box/test/run.sh
```

## End-to-end verification

Run manually after image or wrapper changes (not part of CI — needs Docker
and, for some checks, real credentials):

1. **Subscription build + login persists across runs.** First run: `claude`
   prompts for browser login; token lands in the `claude-box-home` volume.
   Subsequent runs (and a live `claude -p "..."` call) reuse it without
   re-prompting.
2. **Bedrock temp-cred injection + auto mode on the work model.** Verified on
   the work machine — tracked separately (task T4b) since it needs real AWS
   SSO and the actual work Bedrock model.
3. **Firewall blocks a non-allowlisted domain.** From inside the container: an
   allowlisted host (e.g. `github.com`) succeeds; a non-allowlisted host
   (e.g. `example.com`, or a bare IP) times out / fails to connect.
4. **`claude-beads` dry-run on a small throwaway epic**, exercising claim →
   implement → verify → close, with `CLAUDE_BEADS_MAX_ITER` set to bound the
   run.
5. **Mounted skills + `CLAUDE.md` resolve in-container.** `~/.claude/CLAUDE.md`
   imports `@~/.dotfiles/core/ai/AGENTS.md`; `~/.claude/skills` symlinks to
   the live (host-editable) skills directory; `rtk`, `bd`, `claude`, `fd`,
   `rg`, `jq` are all on `PATH`.

### Results (2026-07-02, home machine, subscription provider)

- **(1) Subscription login persistence:** pass. Credentials in the
  `claude-box-home` volume survived across separate `docker run` invocations;
  a live `claude -p "say hi in one word"` call succeeded. Note: Claude Code
  also maintains `~/.claude.json` directly under `$HOME` (outside
  `~/.claude/`), which is *not* covered by the named volume, so that specific
  file does not persist between runs — global config normally kept there gets
  rebuilt each time. Filed as a follow-up.
- **(2) Bedrock:** not run here — this machine has no AWS CLI/credentials by
  design (subscription is the home provider). Deferred to task T4b on the
  work machine.
- **(3) Firewall allowlist:** pass. `github.com` and `api.anthropic.com`
  reachable; `example.com` and a bare unlisted IP both blocked.
- **(4) `claude-beads` dry run:** pass. Ran against a real throwaway epic
  (one task, real `claude -p` call, `CLAUDE_BEADS_VERIFY_CMD` checking a file
  the task was asked to create): task was claimed, implemented, verified,
  and closed by the loop; the resulting commit carried the injected
  `GIT_AUTHOR_*`/`GIT_COMMITTER_*` identity. The repair-ladder and
  circuit-breaker paths were not re-exercised live here (real failures would
  need deliberately broken tasks/burned tokens for the same coverage the bats
  suite already gives with fakes); those paths are covered by
  `test/beads_loop.bats`.
- **(5) Skills + `CLAUDE.md`:** pass, see command output captured during this
  verification pass — symlink resolves, `rtk`/`bd`/`claude`/`fd`/`rg`/`jq` all
  present.
- **Gotcha found:** a project mounted from a path outside Docker Desktop's
  shared paths (e.g. under `/private/tmp/...` on this machine) bind-mounts as
  an *empty* directory with no error — `claude-beads` then reports
  `no_ready_tasks` because it can't see the project's `.beads/` dir. Not a
  claude-box bug, but easy to hit; documented above under Setup.
