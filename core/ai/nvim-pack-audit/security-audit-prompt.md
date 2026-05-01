# Neovim Pack Security Audit

You are auditing a staged `vim.pack.update()` result for a Neovim config.

## Goal

Review only the plugins whose locked revisions changed between the old and new
lockfiles, then produce:

1. a machine-readable final JSON object matching the provided schema;
2. a human-readable Markdown report written to the `audit_md_path`.

The workflow promotes the staged lockfile unless any plugin verdict is
`block`, so use `block` only for concrete high-risk findings.

## Focus

This is a supply-chain and trust-boundary audit. Prioritize:

- subprocess and shell execution
- network access
- dynamic code loading
- filesystem writes outside the plugin directory
- install/build hooks
- vendored binaries or executable blobs
- secret/token/SSH/GPG access
- widened autocmd or user-command trust boundaries
- repository/source anomalies

Do not spend time on style, formatting, or generic refactoring advice.

## Inputs

The caller will append a `## Runtime Context` section containing:

- `mode`
- `old_lockfile_path`
- `new_lockfile_path`
- `plugin_root`
- `audit_md_path`

Use only those paths. Do not assume different locations.

## Lockfile Format

The lockfiles are JSON with a top-level `plugins` object keyed by plugin name.
Each plugin entry includes at least:

- `rev`
- `src`

Some entries may also include `version`.

## Procedure

1. Read both lockfiles.
2. Determine which plugins changed revision.
3. For each changed plugin:
   - inspect the plugin repo under `plugin_root/<plugin_name>`;
   - compare `old_rev` to `new_rev`;
   - review commit range, changed files, and security-relevant code paths;
   - calculate the number of added and removed lines across the revision diff;
   - note any audit limitations if the repo does not contain enough history.
4. Write a concise Markdown report to `audit_md_path`.
5. Return a final JSON object matching the schema exactly.

## Plugin Inspection Guidance

Prefer direct repository inspection over guessing:

- use `git log`, `git diff --stat`, `git diff old..new`, `git show`
- search for risky APIs with `rg`
- inspect changed files directly

Examples of relevant searches:

- `vim.system`
- `vim.fn.system`
- `jobstart`
- `termopen`
- `os.execute`
- `io.popen`
- `curl`
- `wget`
- `socket`
- `luv`
- `vim.uv`
- `loadstring`
- `load(`
- `dofile`
- `require`
- `autocmd`
- `vim.api.nvim_create_user_command`

Treat plain `require(...)` usage as normal Lua behavior unless it is combined
with dynamic user-controlled module names or code loading.

## Verdict Rules

Use exactly one of:

- `approve`
- `manual_review`
- `block`

Use `approve` when:

- no concrete risky behavior was introduced; or
- risky behavior exists but remains bounded and non-exploitable based on the
  inspected diff.

Use `manual_review` when:

- there are meaningful trust-boundary changes but no clear exploit path;
- repo history is insufficient for a clean conclusion;
- large or unusual changes need a human to look more closely.

Use `block` only when there is a concrete high-risk issue, such as:

- newly introduced shell execution on untrusted input;
- suspicious network or credential exfiltration behavior;
- dynamic code execution from untrusted content;
- unexpected binary dropper or installer behavior;
- obviously malicious or dangerously widened behavior.

## Output Requirements

### Markdown Report

Write `audit_md_path` with these sections:

- `# Overview`
- `# Changed Plugins`
- `# Findings`
- `# Per-Plugin Verdicts`
- `# Promotion Recommendation`

Keep it concise and terminal-friendly.

### Final JSON

Return a JSON object matching the output schema exactly.

Requirements:

- `workflow_version` must be `1`
- `mode` must be copied from runtime context
- `overall_verdict` must be:
  - `block` if any plugin is `block`
  - else `manual_review` if any plugin is `manual_review`
  - else `approve`
- `commit.subject` must be exactly `nvim: update pack lockfile`
- `commit.body_markdown` must be a condensed commit body derived from the audit
  suitable for `git commit`, not the full Markdown report

For each plugin:

- `name` should be the repo source if available, otherwise plugin name
- `plugin_name` should be the lockfile key
- `old_rev` and `new_rev` should be the full revisions from the lockfile
- `lines_added` and `lines_removed` should be integer totals for the diff from
  `old_rev` to `new_rev`
- `findings` should be ordered by severity, highest first
- `change_summary` should be 2-4 short bullets

If there are zero changed plugins:

- return empty `plugins`
- set all summary counters to `0`
- set `overall_verdict` to `approve`
- make `commit.body_markdown` explain there were no staged plugin revision
  changes

Include line counts in both outputs:

- `audit.md` should mention per-plugin line totals in the changed plugin
  summary
- `commit.body_markdown` should include per-plugin `+added/-removed` totals
  when there are changed plugins

## Constraints

- Be concrete.
- Cite exact files when you identify a finding.
- Do not invent evidence you cannot inspect locally.
- If you must infer, say so in the finding details.
