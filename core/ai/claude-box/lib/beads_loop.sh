#!/usr/bin/env bash
# claude-beads loop engine: drains a beads epic by running fresh `claude -p`
# per task in bypass mode, with a bounded repair ladder and a circuit
# breaker. Pure control flow over injected commands (`bd`, `claude`, and an
# optional verify command) plus git, so it's testable with fakes on PATH and
# a real throwaway git repo — no Docker/network/real Claude. See
# docs/prds/claude-box.md and docs/adr/0001-bypass-in-container-vs-auto-mode.md.
#
# The loop OWNS all beads state transitions (claim/close/blocked+note); the
# prompt sent to `claude -p` instructs it not to touch bead status itself.
set -euo pipefail

# bl_claim_next_task <epic> - atomically claim the next ready task under
# <epic> via `bd ready --claim`. Echoes the claimed issue id and returns 0 on
# success; returns 1 when no ready task exists; returns 2 when the claim
# itself failed (bd reported an error), leaving stdout empty.
bl_claim_next_task() {
	local epic="${1:?bl_claim_next_task requires an epic id}"
	local claim_json err_msg task_id

	# Keep stdout even when bd exits non-zero: a failed claim prints its
	# error there. `|| true` only stops set -e from aborting.
	claim_json="$(bd ready --parent="$epic" --claim --json --limit=1 2>/dev/null)" || true

	# A top-level {"error": ...} object means the claim itself failed (e.g. a
	# bd/DB schema mismatch or a stuck lock), which is NOT the same as an
	# empty ready queue and must not be swallowed as "no work left".
	err_msg="$(jq -r 'if type == "object" then (.error // empty) else empty end' <<<"$claim_json" 2>/dev/null || true)"
	if [[ -n "$err_msg" ]]; then
		echo "claude-beads: claim failed: ${err_msg}" >&2
		return 2
	fi

	task_id="$(jq -r 'if type == "array" then (.[0].id // empty) else (.id // empty) end' <<<"$claim_json" 2>/dev/null || true)"

	if [[ -z "$task_id" ]]; then
		return 1
	fi

	printf '%s\n' "$task_id"
}

# bl_release_task <task_id> - return a claimed-but-unresolved task to the
# ready pool by clearing its in_progress status and assignee. Best-effort
# (never fails the caller). Used by the interrupt handler: `bd ready --claim`
# skips assigned tasks, so a crashed/cancelled run would otherwise leave the
# task stuck in_progress and unclaimable by the next run.
bl_release_task() {
	local task_id="${1:?bl_release_task requires a task id}"
	bd update "$task_id" --status=open --assignee="" >/dev/null 2>&1 || true
}

# bl_set_model_args - populate the BL_MODEL_ARGS array with the claude
# `--model` flag from CLAUDE_BEADS_MODEL (default: sonnet, i.e. Sonnet 5).
# Set CLAUDE_BEADS_MODEL to another alias/id to override, or to the empty
# string to fall back to the account default (no --model flag).
bl_set_model_args() {
	local model="${CLAUDE_BEADS_MODEL-sonnet}"

	BL_MODEL_ARGS=()
	if [[ -n "$model" ]]; then
		BL_MODEL_ARGS=(--model "$model")
	fi
}

# bl_set_stream_args - populate BL_STREAM_ARGS so `claude -p` emits events as
# they happen (assistant text, tool calls) instead of buffering the whole turn
# and printing once at the end — the latter is why a running task looked
# silent. stream-json requires --verbose in print mode. Set CLAUDE_BEADS_STREAM=0
# to go back to the buffered text output (bl_format_stream passes it through).
bl_set_stream_args() {
	BL_STREAM_ARGS=()
	if [[ "${CLAUDE_BEADS_STREAM:-1}" != "0" ]]; then
		BL_STREAM_ARGS=(--output-format stream-json --verbose)
	fi
}

# bl_format_stream - turn `claude -p --output-format stream-json` events on
# stdin into readable lines (assistant text, plus a one-line summary per tool
# call), flushing each as it arrives so the terminal and log update live.
# Robust to non-JSON input: any line that doesn't parse as a JSON object is
# passed through verbatim, so buffered text output (streaming disabled) and
# stray warnings merged from stderr still show up rather than being dropped.
bl_format_stream() {
	jq -Rr --unbuffered '
	  (try fromjson catch null) as $j
	  | if ($j | type) != "object" then
	      (if $j == null then . else empty end)
	    elif $j.type == "assistant" then
	      ( $j.message.content[]?
	        | if .type == "text" then .text
	          elif .type == "tool_use" then "[tool: " + (.name // "?") + "] " + (((.input // {}) | tojson)[0:200])
	          else empty end )
	    elif $j.type == "result" then
	      # A success result just repeats the final assistant text we already
	      # streamed, so drop it; an error result (e.g. a session/usage limit)
	      # carries text that appears nowhere else, so surface it.
	      (if ((($j.subtype // "") | test("error")) or ($j.is_error == true))
	        then ($j.result // $j.error // empty) else empty end)
	    else empty end
	' 2>/dev/null
}

# bl_detect_session_limit <text> - true when claude bailed on a session/usage
# limit rather than doing the work. Matches the CLI's "You've hit your session
# limit · resets ..." line (and the usage-limit variants), requiring the
# hit/reached verb or a "reset" companion so a task whose own output merely
# mentions a "limit" doesn't trip it.
bl_detect_session_limit() {
	grep -qiE '(hit|reached|reset)[^.]{0,20}(session|usage) limit|(session|usage) limit[^.]{0,40}(hit|reached|reset)' <<<"${1:-}"
}

# bl_reset_time_token <text> - echo the clock time claude said the limit resets
# at (e.g. "10:10am"), or nothing if none is present. Kept separate from the
# wait math so it's unit-testable without a real clock.
bl_reset_time_token() {
	grep -oiE '[0-9]{1,2}(:[0-9]{2})?[[:space:]]*[ap]m' <<<"${1:-}" | head -n1
}

# bl_seconds_until_reset <token> - echo the seconds from now until the next
# occurrence of <token> (a clock time, assumed UTC), or return 1 if it can't
# be parsed. Uses GNU date (present in the container); on a host without
# `date -d` it simply fails, so callers fall back to not waiting.
bl_seconds_until_reset() {
	local token="${1:-}"
	local now target

	if [[ -z "$token" ]]; then
		return 1
	fi

	now="$(date -u +%s)"
	target="$(date -u -d "${token} UTC" +%s 2>/dev/null || true)"
	if [[ -z "$target" ]]; then
		return 1
	fi

	if [[ "$target" -le "$now" ]]; then
		target=$((target + 86400))
	fi

	echo $((target - now))
}

# bl_wait_for_reset <token> - if auto-resume is enabled (CLAUDE_BEADS_WAIT_ON_LIMIT,
# default on) and the reset time is parseable and within CLAUDE_BEADS_MAX_WAIT
# (default 6h), sleep until just past it and return 0 so the loop resumes.
# Returns 1 (don't wait — stop the run) when disabled, unparseable, or too far
# out. Never counts against the circuit breaker; this is not a task failure.
bl_wait_for_reset() {
	local token="${1:-}"
	local secs max_wait

	if [[ "${CLAUDE_BEADS_WAIT_ON_LIMIT:-1}" == "0" ]]; then
		return 1
	fi

	secs="$(bl_seconds_until_reset "$token")" || return 1
	if [[ -z "$secs" || "$secs" -le 0 ]]; then
		return 1
	fi

	max_wait="${CLAUDE_BEADS_MAX_WAIT:-21600}"
	if [[ "$max_wait" -gt 0 && "$secs" -gt "$max_wait" ]]; then
		bl_status "session limit resets in ${secs}s, past CLAUDE_BEADS_MAX_WAIT (${max_wait}s); stopping"
		return 1
	fi

	# A small buffer so we wake just after the quota actually rolls over.
	secs=$((secs + 60))
	bl_status "session limit reached; sleeping ${secs}s until reset (${token}), then resuming"
	sleep "$secs"
	bl_status "session reset; resuming"
}

# bl_init_run_log <epic> - set BL_RUN_LOG to a fresh per-run log file under
# CLAUDE_BEADS_LOG_DIR (default .claude-beads/logs, self-gitignored so run
# transcripts never get committed). Since $PWD is bind-mounted into the
# container, the file is live-tailable from the host. Degrades gracefully:
# if the directory or file isn't writable, leaves BL_RUN_LOG empty and the
# loop still streams to the terminal, just without a persistent transcript.
bl_init_run_log() {
	local epic="${1:-run}"
	local base="${CLAUDE_BEADS_LOG_DIR:-.claude-beads}"
	local ts

	BL_RUN_LOG=""

	if ! mkdir -p "${base}/logs" 2>/dev/null; then
		echo "claude-beads: could not create ${base}/logs; running without a file log" >&2
		return 0
	fi

	if [[ ! -f "${base}/.gitignore" ]]; then
		echo '*' >"${base}/.gitignore" 2>/dev/null || true
	fi

	ts="$(date +%Y%m%d-%H%M%S)"
	BL_RUN_LOG="${base}/logs/${ts}-${epic}.log"

	if ! : >>"$BL_RUN_LOG" 2>/dev/null; then
		echo "claude-beads: ${BL_RUN_LOG} not writable; running without a file log" >&2
		BL_RUN_LOG=""
	fi
}

# bl_status <message> - user-facing progress line: always to stderr, and also
# appended to the run log (when one is open) so the transcript interleaves loop
# status with claude's streamed output. The "claude-beads:" prefix is added
# here so call sites stay terse.
bl_status() {
	echo "claude-beads: $*" >&2
	if [[ -n "${BL_RUN_LOG:-}" ]]; then
		echo "claude-beads: $*" >>"$BL_RUN_LOG" 2>/dev/null || true
	fi
}

# bl_run_claude_implement <task_id> - first attempt at a task: fresh `claude
# -p` in bypass mode, told to implement the task and not touch bead status.
bl_run_claude_implement() {
	local task_id="${1:?bl_run_claude_implement requires a task id}"

	bl_set_model_args
	bl_set_stream_args
	claude -p "${BL_MODEL_ARGS[@]}" "${BL_STREAM_ARGS[@]}" --dangerously-skip-permissions \
		"Implement beads issue ${task_id}. Run 'bd show ${task_id}' for details. Commit your work when done. Do not change the bead's status; the wrapper owns that."
}

# bl_run_claude_repair <task_id> <seed> - a fresh `claude -p`, seeded with the
# previous attempt's diff/output (or a note that no commit landed), asked to
# fix the task.
bl_run_claude_repair() {
	local task_id="${1:?bl_run_claude_repair requires a task id}"
	local seed="${2:-}"

	bl_set_model_args
	bl_set_stream_args
	claude -p "${BL_MODEL_ARGS[@]}" "${BL_STREAM_ARGS[@]}" --dangerously-skip-permissions \
		"The previous attempt at beads issue ${task_id} did not pass verification. Fix it and commit. Do not change the bead's status; the wrapper owns that.

Previous attempt:
${seed}"
}

# bl_run_verify - the verify gate: if CLAUDE_BEADS_VERIFY_CMD is set, run it
# (via bash -c) and report its exit status, capturing output into
# BL_VERIFY_OUTPUT. With no verify command configured, the gate degrades to
# commit-landed-only (always passes here; the commit check happens earlier).
bl_run_verify() {
	BL_VERIFY_OUTPUT=""

	if [[ -z "${CLAUDE_BEADS_VERIFY_CMD:-}" ]]; then
		return 0
	fi

	BL_VERIFY_OUTPUT="$(bash -c "$CLAUDE_BEADS_VERIFY_CMD" 2>&1)" && return 0
	return 1
}

# bl_had_activity <formatted-output> - did claude actually do work this attempt?
# Signal: the "[tool: NAME]" markers bl_format_stream emits for each tool call.
# A real implementation always makes tool calls (edit files, run git); a session
# limit, a refusal, or an empty response makes none. This is a second line of
# defense against no-op closes beyond bl_detect_session_limit's string match.
# Only observable with streaming on (default) — with streaming off we can't see
# tool calls, so we assume activity rather than risk blocking legitimate work.
# Set CLAUDE_BEADS_REQUIRE_ACTIVITY=0 to disable the guard entirely (e.g. if a
# future claude stream schema stops matching the marker).
bl_had_activity() {
	local output="${1:-}"

	if [[ "${CLAUDE_BEADS_REQUIRE_ACTIVITY:-1}" == "0" ]]; then
		return 0
	fi
	if [[ "${CLAUDE_BEADS_STREAM:-1}" == "0" ]]; then
		return 0
	fi

	grep -qE '^\[tool: ' <<<"$output"
}

# bl_attempt_task <task_id> - run the implement-then-repair ladder for one
# task, up to CLAUDE_BEADS_MAX_REPAIRS (default 2) repair attempts beyond the
# first. Returns 0 on a verified commit, 1 once repairs are exhausted, and 2
# when claude bailed on a session/usage limit (the caller must NOT close or
# block the task — it wasn't really attempted). On a 2, BL_SESSION_RESET holds
# the reported reset time (may be empty if unparseable).
bl_attempt_task() {
	local task_id="${1:?bl_attempt_task requires a task id}"
	local max_repairs="${CLAUDE_BEADS_MAX_REPAIRS:-2}"
	local attempt=0
	local seed=""
	local before_sha after_sha claude_output
	local log="${BL_RUN_LOG:-/dev/null}"

	BL_SESSION_RESET=""

	while [[ "$attempt" -le "$max_repairs" ]]; do
		before_sha="$(git rev-parse HEAD 2>/dev/null || true)"

		# Stream claude's output through bl_format_stream (stream-json ->
		# readable lines) so progress shows live instead of dumping at the
		# end, tee it to the run log (persistent transcript, live-tailable
		# from the host) and to fd 2, and still capture it for the repair
		# seed. `tee ... >(cat >&2)` writes the live copy to the already-open
		# fd 2 rather than reopening /dev/stderr — the latter is a root-owned
		# pty under `docker run -it` + gosu and fails for the non-root user
		# with "tee: /dev/stderr: Permission denied".
		if [[ "$attempt" -eq 0 ]]; then
			bl_status "[${task_id}] implementing..."
			claude_output="$(bl_run_claude_implement "$task_id" 2>&1 | bl_format_stream | tee -a "$log" >(cat >&2))" || true
		else
			bl_status "[${task_id}] repair attempt ${attempt}/${max_repairs}..."
			claude_output="$(bl_run_claude_repair "$task_id" "$seed" 2>&1 | bl_format_stream | tee -a "$log" >(cat >&2))" || true
		fi

		# A session/usage limit means claude did no work — do not let a stale
		# or coincidental commit read as success and close the task. Bail with
		# the reset time so the loop can pause (and optionally resume).
		if bl_detect_session_limit "$claude_output"; then
			BL_SESSION_RESET="$(bl_reset_time_token "$claude_output")"
			bl_status "[${task_id}] session limit hit before completion; not closing"
			return 2
		fi

		after_sha="$(git rev-parse HEAD 2>/dev/null || true)"

		if [[ -z "$after_sha" || "$before_sha" == "$after_sha" ]]; then
			bl_status "[${task_id}] no commit landed, will repair"
			seed="No commit landed. claude output:
${claude_output}"
		elif ! bl_had_activity "$claude_output"; then
			# A commit is present but claude made zero tool calls this attempt,
			# so it can't have produced that work — the commit is stale or
			# pre-existing. Refuse to close on it; this is what falsely closed
			# tasks whose run had already hit the session limit.
			bl_status "[${task_id}] commit present but claude did no work (no tool calls); will repair"
			seed="A commit is present but claude made no tool calls, so the task was not actually implemented. claude output:
${claude_output}"
		elif bl_run_verify; then
			bl_status "[${task_id}] verified"
			return 0
		else
			bl_status "[${task_id}] verify failed, will repair"
			seed="$(git diff "$before_sha" "$after_sha" 2>/dev/null)

verify output:
${BL_VERIFY_OUTPUT}"
		fi

		attempt=$((attempt + 1))
	done

	return 1
}

# run_beads_loop <epic> - drain an epic: claim -> attempt (implement + bounded
# repairs) -> close on success / mark blocked + note on exhaustion, repeating
# until no ready tasks remain, 3 consecutive tasks are blocked (circuit
# breaker), or CLAUDE_BEADS_MAX_ITER is reached. Sets BEADS_LOOP_ITER and
# BEADS_LOOP_STOP_REASON (one of: no_ready_tasks, claim_error,
# circuit_breaker, max_iter, session_limit).
run_beads_loop() {
	local epic="${1:?run_beads_loop requires an epic id}"
	local max_iter="${CLAUDE_BEADS_MAX_ITER:-0}"
	local iter=0
	local consecutive_blocked=0
	local claim_rc
	local attempt_rc
	local task_id
	local inflight_task=""

	# Set for the caller (and bats tests) to inspect; not read within this
	# function, hence unused-looking to shellcheck.
	# shellcheck disable=SC2034
	BEADS_LOOP_STOP_REASON=""

	bl_init_run_log "$epic"
	if [[ -n "${BL_RUN_LOG:-}" ]]; then
		bl_status "logging this run to ${BL_RUN_LOG} (tail -f to follow)"
	fi

	# If the run is interrupted (Ctrl-C / kill) while a task is claimed but
	# not yet resolved, hand it back to the ready pool so it isn't left
	# stuck in_progress (bd ready --claim skips assigned tasks — exactly what
	# stalls a later run). Normal resolution clears inflight_task, making the
	# handler a no-op; the traps are removed before returning.
	# shellcheck disable=SC2064
	trap 'if [[ -n "$inflight_task" ]]; then bl_release_task "$inflight_task"; fi; trap - INT TERM; kill -INT "$$"' INT
	# shellcheck disable=SC2064
	trap 'if [[ -n "$inflight_task" ]]; then bl_release_task "$inflight_task"; fi' TERM

	while true; do
		if [[ "$max_iter" -gt 0 && "$iter" -ge "$max_iter" ]]; then
			BEADS_LOOP_STOP_REASON="max_iter"
			break
		fi

		claim_rc=0
		task_id="$(bl_claim_next_task "$epic")" || claim_rc=$?
		if [[ "$claim_rc" -ne 0 ]]; then
			if [[ "$claim_rc" -eq 2 ]]; then
				BEADS_LOOP_STOP_REASON="claim_error"
			else
				BEADS_LOOP_STOP_REASON="no_ready_tasks"
			fi
			break
		fi

		inflight_task="$task_id"
		iter=$((iter + 1))
		bl_status "[${task_id}] claimed (task ${iter})"

		attempt_rc=0
		bl_attempt_task "$task_id" || attempt_rc=$?

		if [[ "$attempt_rc" -eq 2 ]]; then
			# Session/usage limit: claude did no work. Hand the task back to
			# the ready pool (un-attempted, not blocked) and either wait for
			# the reset and resume, or stop cleanly so a later run continues.
			bl_release_task "$task_id"
			inflight_task=""
			iter=$((iter - 1))
			if bl_wait_for_reset "$BL_SESSION_RESET"; then
				continue
			fi
			# shellcheck disable=SC2034 # read by callers/tests
			BEADS_LOOP_STOP_REASON="session_limit"
			# shellcheck disable=SC2034 # read by callers/tests
			BEADS_LOOP_RESET_AT="$BL_SESSION_RESET"
			bl_status "session limit reached; stopping${BL_SESSION_RESET:+ (resets ${BL_SESSION_RESET})}. Re-run to continue after the reset."
			break
		fi

		if [[ "$attempt_rc" -eq 0 ]]; then
			bd close "$task_id" --reason="claude-beads: verified and closed by loop" >/dev/null
			bl_status "[${task_id}] closed"
			consecutive_blocked=0
		else
			bd update "$task_id" --status=blocked >/dev/null 2>&1 || true
			bd note "$task_id" "claude-beads: exhausted ${CLAUDE_BEADS_MAX_REPAIRS:-2} repair attempt(s); marked blocked" >/dev/null 2>&1 || true
			bl_status "[${task_id}] blocked"
			consecutive_blocked=$((consecutive_blocked + 1))
		fi

		# The task is resolved (closed or marked blocked); nothing to hand
		# back if a later iteration is interrupted.
		inflight_task=""

		if [[ "$consecutive_blocked" -ge 3 ]]; then
			# shellcheck disable=SC2034 # read by callers/tests
			BEADS_LOOP_STOP_REASON="circuit_breaker"
			break
		fi
	done

	trap - INT TERM
	# shellcheck disable=SC2034 # read by callers/tests
	BEADS_LOOP_ITER="$iter"
}
