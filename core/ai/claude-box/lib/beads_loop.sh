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
# <epic> via `bd ready --claim`. Echoes the claimed issue id, or nothing (and
# returns 1) when no ready task exists.
bl_claim_next_task() {
	local epic="${1:?bl_claim_next_task requires an epic id}"
	local claim_json task_id

	claim_json="$(bd ready --parent="$epic" --claim --json --limit=1 2>/dev/null)" || claim_json=""
	task_id="$(jq -r 'if type == "array" then (.[0].id // empty) else (.id // empty) end' <<<"$claim_json" 2>/dev/null || true)"

	if [[ -z "$task_id" ]]; then
		return 1
	fi

	printf '%s\n' "$task_id"
}

# bl_run_claude_implement <task_id> - first attempt at a task: fresh `claude
# -p` in bypass mode, told to implement the task and not touch bead status.
bl_run_claude_implement() {
	local task_id="${1:?bl_run_claude_implement requires a task id}"

	claude -p --dangerously-skip-permissions \
		"Implement beads issue ${task_id}. Run 'bd show ${task_id}' for details. Commit your work when done. Do not change the bead's status; the wrapper owns that."
}

# bl_run_claude_repair <task_id> <seed> - a fresh `claude -p`, seeded with the
# previous attempt's diff/output (or a note that no commit landed), asked to
# fix the task.
bl_run_claude_repair() {
	local task_id="${1:?bl_run_claude_repair requires a task id}"
	local seed="${2:-}"

	claude -p --dangerously-skip-permissions \
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

# bl_attempt_task <task_id> - run the implement-then-repair ladder for one
# task, up to CLAUDE_BEADS_MAX_REPAIRS (default 2) repair attempts beyond the
# first. Returns 0 on a verified commit, 1 once repairs are exhausted.
bl_attempt_task() {
	local task_id="${1:?bl_attempt_task requires a task id}"
	local max_repairs="${CLAUDE_BEADS_MAX_REPAIRS:-2}"
	local attempt=0
	local seed=""
	local before_sha after_sha claude_output

	while [[ "$attempt" -le "$max_repairs" ]]; do
		before_sha="$(git rev-parse HEAD 2>/dev/null || true)"

		if [[ "$attempt" -eq 0 ]]; then
			echo "claude-beads: [${task_id}] implementing..." >&2
			claude_output="$(bl_run_claude_implement "$task_id" 2>&1 | tee /dev/stderr)" || true
		else
			echo "claude-beads: [${task_id}] repair attempt ${attempt}/${max_repairs}..." >&2
			claude_output="$(bl_run_claude_repair "$task_id" "$seed" 2>&1 | tee /dev/stderr)" || true
		fi

		after_sha="$(git rev-parse HEAD 2>/dev/null || true)"

		if [[ -n "$after_sha" && "$before_sha" != "$after_sha" ]]; then
			if bl_run_verify; then
				echo "claude-beads: [${task_id}] verified" >&2
				return 0
			fi
			echo "claude-beads: [${task_id}] verify failed, will repair" >&2
			seed="$(git diff "$before_sha" "$after_sha" 2>/dev/null)

verify output:
${BL_VERIFY_OUTPUT}"
		else
			echo "claude-beads: [${task_id}] no commit landed, will repair" >&2
			seed="No commit landed. claude output:
${claude_output}"
		fi

		attempt=$((attempt + 1))
	done

	return 1
}

# run_beads_loop <epic> - drain an epic: claim -> attempt (implement + bounded
# repairs) -> close on success / mark blocked + note on exhaustion, repeating
# until no ready tasks remain, 3 consecutive tasks are blocked (circuit
# breaker), or CLAUDE_BEADS_MAX_ITER is reached. Sets BEADS_LOOP_ITER and
# BEADS_LOOP_STOP_REASON (one of: no_ready_tasks, circuit_breaker, max_iter).
run_beads_loop() {
	local epic="${1:?run_beads_loop requires an epic id}"
	local max_iter="${CLAUDE_BEADS_MAX_ITER:-0}"
	local iter=0
	local consecutive_blocked=0
	local task_id

	# Set for the caller (and bats tests) to inspect; not read within this
	# function, hence unused-looking to shellcheck.
	# shellcheck disable=SC2034
	BEADS_LOOP_STOP_REASON=""

	while true; do
		if [[ "$max_iter" -gt 0 && "$iter" -ge "$max_iter" ]]; then
			BEADS_LOOP_STOP_REASON="max_iter"
			break
		fi

		if ! task_id="$(bl_claim_next_task "$epic")"; then
			BEADS_LOOP_STOP_REASON="no_ready_tasks"
			break
		fi

		iter=$((iter + 1))
		echo "claude-beads: [${task_id}] claimed (task ${iter})" >&2

		if bl_attempt_task "$task_id"; then
			bd close "$task_id" --reason="claude-beads: verified and closed by loop" >/dev/null
			echo "claude-beads: [${task_id}] closed" >&2
			consecutive_blocked=0
		else
			bd update "$task_id" --status=blocked >/dev/null 2>&1 || true
			bd note "$task_id" "claude-beads: exhausted ${CLAUDE_BEADS_MAX_REPAIRS:-2} repair attempt(s); marked blocked" >/dev/null 2>&1 || true
			echo "claude-beads: [${task_id}] blocked" >&2
			consecutive_blocked=$((consecutive_blocked + 1))

			if [[ "$consecutive_blocked" -ge 3 ]]; then
				# shellcheck disable=SC2034 # read by callers/tests
				BEADS_LOOP_STOP_REASON="circuit_breaker"
				break
			fi
		fi
	done

	# shellcheck disable=SC2034 # read by callers/tests
	BEADS_LOOP_ITER="$iter"
}
