---
name: security-audit
description:
  Audit a git-hosted dependency — CLI tool, editor/IDE plugin, or library — for security risk before
  installing or updating it — clone the repo, check it against a supply-chain checklist and a
  code-vulnerability checklist, and report findings with a verdict.
disable-model-invocation: true
---

You are auditing a git-hosted dependency's source repository for security risk — a CLI tool, an
editor/IDE plugin (Neovim, VS Code, ...), or a library about to be added somewhere. The user hands
you a git link (GitHub or otherwise) and, optionally, one or two refs (tag/commit/branch).

Two threat classes, both in scope:

- **Supply chain** — code an attacker _planted_: it crosses a **trust boundary** by running, phoning
  home, or touching credentials without the user asking, right now or the moment the tool is
  installed/updated. The maintainer didn't write it on purpose.
- **Code vulnerabilities** — bugs the _maintainer_ wrote by accident that a malicious input or
  environment can exploit: injection, unsafe deserialization, weak crypto, race conditions. No
  attacker touched the repo; the danger is latent in ordinary code.

Both checklists below apply to every audit — a clean supply chain can still ship exploitable code.

## Inputs and mode

- **One ref given (or none)** — **snapshot mode**: audit that ref (default: the repo's default
  branch) as a whole.
- **Two refs given** — **diff mode**: audit only what changed between them, the way you'd review a
  version bump before upgrading.

Clone shallow into the scratchpad directory. Diff mode needs enough history to diff the two refs —
fetch just those two refs' history, not the full log.

## Procedure

1. **Clone and orient.** Clone the repo (both refs, if diff mode). Identify language(s), package
   manager(s), build system, and whether it ships prebuilt binaries. Done when you can name what
   kind of project this is and what its install/build entrypoint is.
2. **Establish the scan set.** Snapshot mode: the whole tree at the ref, minus vendored dependencies
   you don't control (note them, don't skip noting them). Diff mode: the changed files between the
   two refs, plus any file the diff touches that runs at install/build time even if the change looks
   small. Done when you have a concrete file list, not "the repo."
3. **Walk both checklists** (below) over the scan set, citing exact files and line ranges for every
   hit. A category with nothing found is a line saying so, not silence.
4. **Write the report** (below) and give it a verdict.

Within each checklist below, order matters: lead with whatever an attacker reaches with the least
effort — the cheapest win, the least trusted input — and work down from there.

## Checklist: supply chain

- **Install-time execution** — anything that runs the moment the tool is installed or built, before
  the user has run the tool itself: `postinstall`/`preinstall` in `package.json`, `setup.py`/build
  hooks in `pyproject.toml`, `Makefile`/`configure` install targets, shipped git hooks. This is the
  single most common real-world vector (event-stream, node-ipc, the 2025 npm chalk/debug/Shai-Hulud
  compromises) because it needs zero action from the user beyond installing.
- **Build-system tampering** — logic hidden in build scripts, autotools macros, or test fixtures
  rather than application code, especially binary blobs disguised as test data that get linked into
  the build (the xz/liblzma backdoor's exact shape). Anywhere a build step decides _what_ to compile
  based on environment checks is worth a second look.
- **CI/workflow tampering** — `.github/workflows/*` (or equivalent) using a third-party action
  pinned to a mutable tag instead of a commit SHA, `pull_request_target` combined with checking out
  and running PR code, secrets referenced in a job triggered by external PRs. This is how an
  attacker compromises the _next_ release without touching the code a human reviews
  (tj-actions/reviewdog, March 2025).
- **Vendored or prebuilt binaries** — compiled blobs, `.so`/`.dll`/`.node`/`.wasm` files, or
  "vendor" directories with no matching source or build recipe in the repo. Can't be diffed at the
  source level, so flag for `manual_review` rather than trying to reverse-engineer it.
- **Obfuscation** — minified/packed JS with no matching source map, base64 or hex strings decoded
  and then `eval`'d/`exec`'d, string concatenation that assembles an API call or URL piece by piece.
  Legitimate build output (a `dist/` bundle with a source map and matching build config) is not
  this; obfuscation with nothing to justify it is.
- **Network and exfiltration** — outbound HTTP/DNS to hosts not documented as the tool's own
  infrastructure, especially paired in the same code path with reads of env vars, `~/.ssh`,
  `~/.aws`, browser cookie stores, cloud-metadata endpoints (`169.254.169.254`), or GPG/SSH keys.
  Reading a secret and calling the network are each fine alone; together in one path is the pattern
  that matters.
- **New or renamed dependencies** — a diff that adds a dependency, especially one with a
  typosquat-shaped name (one edit-distance from a popular package) or a very recent first-publish
  date relative to its claimed popularity.
- **Maintainer/commit anomalies** — a burst of commits from an account with no prior history right
  before a release, a rewritten/force-pushed history, or a published release/tag whose tree doesn't
  match any commit in the visible log (event-stream and node-ipc both surfaced this way: a dormant
  package suddenly active under new hands).

## Checklist: code vulnerabilities

- **Injection** — user- or file-controlled strings reaching a shell (`subprocess.Popen(shell=True)`,
  `child_process.exec`, `os.system`, backtick/`sh -c` construction), a SQL query built by
  concatenation, or a path built from unsanitized input and then read/written/deleted (path
  traversal, zip-slip in archive extraction). The same shape recurs across languages — grep
  `subprocess`, `exec(`, `os/exec.Command`, `Runtime.exec`, string-built SQL, and archive-extraction
  code regardless of the project's primary language. For an editor plugin (Neovim/Lua especially),
  the equivalent surface is `vim.fn.system`/`vim.system`, `jobstart`, `termopen`, `vim.uv`/`luv`,
  `loadstring`/`load(`/`dofile` on dynamic or downloaded content, and any `autocmd` or
  `nvim_create_user_command` that widens what runs automatically or what a command accepts.
- **Insecure deserialization** — `pickle.load`/`yaml.load` (not `safe_load`) on untrusted input,
  `Marshal.load`, Java `ObjectInputStream`, or any format whose parser can execute code on load, fed
  by a file, network response, or config the tool doesn't fully control.
- **Hardcoded secrets** — API keys, private keys, or credentials committed in source, config, or
  test fixtures — not a supply-chain plant, just carelessness, but still handed to anyone who clones
  the repo.
- **Weak or misused crypto** — MD5/SHA1/DES for anything security-sensitive, ECB mode, a hardcoded
  key/IV/salt, `random`/`Math.random` used where a CSPRNG is needed (tokens, session ids, nonces).
- **Unsafe temp files and races** — predictable temp file names, temp files created before their
  permissions are locked down, TOCTOU windows between checking a path and using it, especially in
  code that ever runs with elevated privileges.
- **Overbroad permissions** — files or directories the tool creates with world-writable or
  world-readable permissions, especially anything holding credentials or tokens; `sudo`/setuid usage
  baked into the install or runtime path where a narrower privilege would do.
- **Unvalidated network input** — for a tool that fetches URLs (from args, config, or a remote
  manifest) and does anything beyond a plain download with it — parses it, extracts an archive from
  it, follows redirects to internal/metadata addresses — check what it does when that response is
  hostile.

## Verdict

One of three:

- **approve** — nothing above fires, or what fires is bounded and explainable (e.g. a documented
  telemetry call with no credential access nearby, or a vulnerability with no reachable input path).
- **manual_review** — a real trust-boundary change or vulnerability with no clear exploit path,
  insufficient history/context to rule one out, or a vendored binary that can't be source-reviewed.
- **block** — any checklist item confirmed with a concrete, reachable exploit path: an attacker (or
  the next installer) can actually trigger it, not just hypothetically reach it.

## Report

Write a Markdown report (scratchpad, or wherever the user asks) with:

```markdown
# Overview

<repo, ref(s), mode, what kind of project it is>

# Scan Set

<what was actually reviewed, and what was explicitly out of reach (vendored binaries, etc.)>

# Findings

## Supply chain

<one entry per checklist category with a hit — file, line range, why it matters, severity>

## Code vulnerabilities

<same, for the code-vulnerability checklist>

# Verdict

<approve / manual_review / block, one line of justification>
```

Cite exact files for every finding; if you have to infer intent rather than read it, say so rather
than asserting it. Don't invent evidence you didn't inspect.
