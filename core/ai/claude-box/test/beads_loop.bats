#!/usr/bin/env bats

setup() {
	source "${BATS_TEST_DIRNAME}/../lib/beads_loop.sh"

	TEST_TMPDIR="$(mktemp -d)"

	REPO_DIR="${TEST_TMPDIR}/repo"
	mkdir -p "$REPO_DIR"
	git -C "$REPO_DIR" init -q
	git -C "$REPO_DIR" config user.email "test@example.com"
	git -C "$REPO_DIR" config user.name "Test User"
	git -C "$REPO_DIR" commit -q --allow-empty -m "init"

	BIN_DIR="${TEST_TMPDIR}/bin"
	mkdir -p "$BIN_DIR"

	FAKE_BD_LOG="${TEST_TMPDIR}/bd.log"
	FAKE_BD_READY_QUEUE="${TEST_TMPDIR}/bd_ready_queue"
	: >"$FAKE_BD_LOG"
	: >"$FAKE_BD_READY_QUEUE"
	export FAKE_BD_LOG FAKE_BD_READY_QUEUE

	FAKE_CLAUDE_LOG="${TEST_TMPDIR}/claude.log"
	FAKE_CLAUDE_QUEUE="${TEST_TMPDIR}/claude_queue"
	: >"$FAKE_CLAUDE_LOG"
	: >"$FAKE_CLAUDE_QUEUE"
	export FAKE_CLAUDE_LOG FAKE_CLAUDE_QUEUE

	FAKE_VERIFY_QUEUE="${TEST_TMPDIR}/verify_queue"
	: >"$FAKE_VERIFY_QUEUE"
	export FAKE_VERIFY_QUEUE

	write_fake_bd
	write_fake_claude
	write_fake_verify

	PATH="${BIN_DIR}:${PATH}"
	cd "$REPO_DIR"

	unset CLAUDE_BEADS_MAX_REPAIRS CLAUDE_BEADS_MAX_ITER CLAUDE_BEADS_VERIFY_CMD CLAUDE_BEADS_MODEL CLAUDE_BEADS_STREAM CLAUDE_BEADS_LOG_DIR CLAUDE_BEADS_WAIT_ON_LIMIT CLAUDE_BEADS_MAX_WAIT CLAUDE_BEADS_REQUIRE_ACTIVITY || true
}

teardown() {
	cd "${BATS_TEST_DIRNAME}"
	rm -rf "$TEST_TMPDIR"
}

# fake bd: logs every invocation; `ready ... --claim` pops one task id off
# FAKE_BD_READY_QUEUE (or reports empty), everything else just succeeds. This
# lets tests assert both the sequence of bd calls (state transitions are
# wrapper-owned) and their arguments (which task got closed/blocked).
write_fake_bd() {
	cat >"${BIN_DIR}/bd" <<'FAKE'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$FAKE_BD_LOG"

if [[ "$1" == "ready" ]]; then
	if [[ -s "$FAKE_BD_READY_QUEUE" ]]; then
		id="$(head -n1 "$FAKE_BD_READY_QUEUE")"
		tail -n +2 "$FAKE_BD_READY_QUEUE" >"${FAKE_BD_READY_QUEUE}.tmp" && mv "${FAKE_BD_READY_QUEUE}.tmp" "$FAKE_BD_READY_QUEUE"
		# A queue entry "__ERROR__<msg>" makes the claim fail like a real bd
		# claim error: error JSON on stdout plus a non-zero exit.
		if [[ "$id" == __ERROR__* ]]; then
			printf '{"error":"%s"}\n' "${id#__ERROR__}"
			exit 1
		fi
		printf '{"id":"%s"}\n' "$id"
	else
		printf '[]\n'
	fi
	exit 0
fi

exit 0
FAKE
	chmod +x "${BIN_DIR}/bd"
}

# fake claude: logs every invocation; pops one action ("commit"/"nocommit")
# off FAKE_CLAUDE_QUEUE per call and either lands an empty commit or not, so
# tests can control the implement/repair ladder deterministically.
write_fake_claude() {
	cat >"${BIN_DIR}/claude" <<'FAKE'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$FAKE_CLAUDE_LOG"

action="nocommit"
if [[ -s "$FAKE_CLAUDE_QUEUE" ]]; then
	action="$(head -n1 "$FAKE_CLAUDE_QUEUE")"
	tail -n +2 "$FAKE_CLAUDE_QUEUE" >"${FAKE_CLAUDE_QUEUE}.tmp" && mv "${FAKE_CLAUDE_QUEUE}.tmp" "$FAKE_CLAUDE_QUEUE"
fi

# "limit" simulates claude bailing on a session limit: it prints the CLI's
# limit line (optionally landing a commit too, to prove the loop still refuses
# to close the task) and exits.
if [[ "$action" == limit* ]]; then
	echo "You've hit your session limit · resets 10:10am (UTC)"
	if [[ "$action" == "limit-commit" ]]; then
		git commit -q --allow-empty -m "half-done work"
	fi
	exit 0
fi

# "commit" simulates real work: emit a stream-json tool_use event (so
# bl_format_stream renders a "[tool: ...]" line the activity guard can see) and
# land a commit. "commit-notool" lands a commit WITHOUT any tool_use event, to
# exercise the guard that refuses to close a commit claude didn't actually
# produce. The tool_use JSON is one line so `jq -R` parses it.
if [[ "$action" == "commit" ]]; then
	echo '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Bash","input":{"command":"git commit"}}]}}'
	git commit -q --allow-empty -m "fake work"
elif [[ "$action" == "commit-notool" ]]; then
	git commit -q --allow-empty -m "commit without tool activity"
fi
exit 0
FAKE
	chmod +x "${BIN_DIR}/claude"
}

# fake verify: pops one result ("pass"/"fail", default "pass") off
# FAKE_VERIFY_QUEUE and exits accordingly. Wired in via CLAUDE_BEADS_VERIFY_CMD.
write_fake_verify() {
	FAKE_VERIFY_SCRIPT="${TEST_TMPDIR}/fake_verify.sh"
	cat >"$FAKE_VERIFY_SCRIPT" <<'FAKE'
#!/usr/bin/env bash
result="pass"
if [[ -s "$FAKE_VERIFY_QUEUE" ]]; then
	result="$(head -n1 "$FAKE_VERIFY_QUEUE")"
	tail -n +2 "$FAKE_VERIFY_QUEUE" >"${FAKE_VERIFY_QUEUE}.tmp" && mv "${FAKE_VERIFY_QUEUE}.tmp" "$FAKE_VERIFY_QUEUE"
fi
[[ "$result" == "pass" ]]
FAKE
	chmod +x "$FAKE_VERIFY_SCRIPT"
	export FAKE_VERIFY_SCRIPT
}

@test "run_beads_loop: closes a task that succeeds on the first attempt" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "no_ready_tasks" ]
	[ "$BEADS_LOOP_ITER" -eq 1 ]
	grep -q "close task-1" "$FAKE_BD_LOG"
}

@test "run_beads_loop: a repair pass fixes a task whose first attempt fails verify" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	echo "fail" >>"$FAKE_VERIFY_QUEUE"
	echo "pass" >>"$FAKE_VERIFY_QUEUE"
	export CLAUDE_BEADS_VERIFY_CMD="$FAKE_VERIFY_SCRIPT"

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "no_ready_tasks" ]
	grep -q "close task-1" "$FAKE_BD_LOG"
	[ "$(grep -c -- "--dangerously-skip-permissions" "$FAKE_CLAUDE_LOG")" -eq 2 ]
}

@test "run_beads_loop: exhausting repairs marks the task blocked with a note" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	export CLAUDE_BEADS_MAX_REPAIRS=1
	echo "nocommit" >>"$FAKE_CLAUDE_QUEUE"
	echo "nocommit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	grep -q "update task-1 --status=blocked" "$FAKE_BD_LOG"
	grep -q "note task-1" "$FAKE_BD_LOG"
	! grep -q "close task-1" "$FAKE_BD_LOG"
}

@test "run_beads_loop: halts after 3 consecutive blocked tasks" {
	printf 'task-1\ntask-2\ntask-3\ntask-4\n' >"$FAKE_BD_READY_QUEUE"
	export CLAUDE_BEADS_MAX_REPAIRS=0
	echo "nocommit" >>"$FAKE_CLAUDE_QUEUE"
	echo "nocommit" >>"$FAKE_CLAUDE_QUEUE"
	echo "nocommit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "circuit_breaker" ]
	[ "$BEADS_LOOP_ITER" -eq 3 ]
	! grep -q "task-4" "$FAKE_BD_LOG"
}

@test "run_beads_loop: stops after CLAUDE_BEADS_MAX_ITER tasks even with more ready" {
	printf 'task-1\ntask-2\n' >"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_MAX_ITER=1

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "max_iter" ]
	[ "$BEADS_LOOP_ITER" -eq 1 ]
	grep -q "close task-1" "$FAKE_BD_LOG"
	! grep -q "task-2" "$FAKE_BD_LOG"
}

@test "run_beads_loop: implement runs claude with the default Sonnet model" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	grep -q -- "--model sonnet" "$FAKE_CLAUDE_LOG"
}

@test "run_beads_loop: CLAUDE_BEADS_MODEL overrides the model passed to claude" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_MODEL="opus"

	run_beads_loop "epic-1"

	grep -q -- "--model opus" "$FAKE_CLAUDE_LOG"
	! grep -q -- "--model sonnet" "$FAKE_CLAUDE_LOG"
}

@test "run_beads_loop: empty CLAUDE_BEADS_MODEL falls back to no --model flag" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_MODEL=""

	run_beads_loop "epic-1"

	! grep -q -- "--model" "$FAKE_CLAUDE_LOG"
}

@test "run_beads_loop: streams claude output as stream-json by default" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	grep -q -- "--output-format stream-json" "$FAKE_CLAUDE_LOG"
	grep -q -- "--verbose" "$FAKE_CLAUDE_LOG"
}

@test "run_beads_loop: CLAUDE_BEADS_STREAM=0 disables stream-json" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_STREAM=0

	run_beads_loop "epic-1"

	! grep -q -- "--output-format stream-json" "$FAKE_CLAUDE_LOG"
}

@test "run_beads_loop: writes a per-run log capturing status lines" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	local log
	log="$(ls "${REPO_DIR}"/.claude-beads/logs/*.log)"
	[ -f "$log" ]
	grep -q "claimed (task 1)" "$log"
	grep -q "\[task-1\] closed" "$log"
	# the log dir self-ignores so transcripts never get committed
	grep -qx '*' "${REPO_DIR}/.claude-beads/.gitignore"
}

@test "run_beads_loop: CLAUDE_BEADS_LOG_DIR relocates the run log" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_LOG_DIR="${TEST_TMPDIR}/custom-logs"

	run_beads_loop "epic-1"

	local log
	log="$(ls "${TEST_TMPDIR}"/custom-logs/logs/*.log)"
	[ -f "$log" ]
	grep -q "claimed (task 1)" "$log"
}

@test "run_beads_loop: a claim error stops the loop distinctly from an empty queue" {
	echo "__ERROR__schema boom" >>"$FAKE_BD_READY_QUEUE"

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "claim_error" ]
	[ "$BEADS_LOOP_ITER" -eq 0 ]
	! grep -q "close" "$FAKE_BD_LOG"
}

@test "run_beads_loop: a commit with no tool activity is not trusted as done" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	export CLAUDE_BEADS_MAX_REPAIRS=0
	echo "commit-notool" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	# a landed commit with zero tool calls is not real work: never closed,
	# blocked once repairs are exhausted
	! grep -q "close task-1" "$FAKE_BD_LOG"
	grep -q "update task-1 --status=blocked" "$FAKE_BD_LOG"
}

@test "run_beads_loop: CLAUDE_BEADS_REQUIRE_ACTIVITY=0 disables the activity guard" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit-notool" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_REQUIRE_ACTIVITY=0

	run_beads_loop "epic-1"

	grep -q "close task-1" "$FAKE_BD_LOG"
}

@test "run_beads_loop: activity guard is inactive when streaming is off" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit-notool" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_STREAM=0

	run_beads_loop "epic-1"

	# with no stream we can't see tool calls, so a commit alone still closes
	grep -q "close task-1" "$FAKE_BD_LOG"
}

@test "bl_had_activity: true only when a tool-call marker is present" {
	run bl_had_activity "[tool: Bash] {\"command\":\"git commit\"}"
	[ "$status" -eq 0 ]

	run bl_had_activity "I have finished the task and committed everything."
	[ "$status" -ne 0 ]
}

@test "bl_detect_session_limit: matches the CLI limit line, not incidental mentions" {
	run bl_detect_session_limit "You've hit your session limit · resets 10:10am (UTC)"
	[ "$status" -eq 0 ]

	run bl_detect_session_limit "Claude usage limit reached"
	[ "$status" -eq 0 ]

	# a task's own output merely discussing a limit must not trip it
	run bl_detect_session_limit "Added a rate limit of 100 requests per minute"
	[ "$status" -ne 0 ]
}

@test "bl_reset_time_token: extracts the reset clock time" {
	run bl_reset_time_token "You've hit your session limit · resets 10:10am (UTC)"
	[ "$output" = "10:10am" ]
}

@test "run_beads_loop: a session limit pauses the run without closing the task" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "limit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_WAIT_ON_LIMIT=0

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "session_limit" ]
	[ "$BEADS_LOOP_ITER" -eq 0 ]
	# the task is neither closed nor blocked...
	! grep -q "close task-1" "$FAKE_BD_LOG"
	! grep -q "update task-1 --status=blocked" "$FAKE_BD_LOG"
	# ...it is handed back to the ready pool for a later run
	grep -q "update task-1 --status=open --assignee=" "$FAKE_BD_LOG"
}

@test "run_beads_loop: a session limit does not close even if a commit landed" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "limit-commit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_WAIT_ON_LIMIT=0

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "session_limit" ]
	! grep -q "close task-1" "$FAKE_BD_LOG"
}

@test "run_beads_loop: session limit stops before draining the rest of the queue" {
	printf 'task-1\ntask-2\n' >"$FAKE_BD_READY_QUEUE"
	echo "limit" >>"$FAKE_CLAUDE_QUEUE"
	export CLAUDE_BEADS_WAIT_ON_LIMIT=0

	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "session_limit" ]
	# task-2 is never claimed — the run paused on the limit
	! grep -q "task-2" "$FAKE_BD_LOG"
}

@test "bl_release_task: hands a claimed task back to the ready pool" {
	bl_release_task "task-9"

	grep -q "update task-9 --status=open --assignee=" "$FAKE_BD_LOG"
}

@test "run_beads_loop: stops immediately when there is no ready work" {
	run_beads_loop "epic-1"

	[ "$BEADS_LOOP_STOP_REASON" = "no_ready_tasks" ]
	[ "$BEADS_LOOP_ITER" -eq 0 ]
	grep -q "^ready " "$FAKE_BD_LOG"
	! grep -q "close" "$FAKE_BD_LOG"
}

@test "run_beads_loop: state transitions are wrapper-owned (claim, close, then re-check, in order)" {
	echo "task-1" >>"$FAKE_BD_READY_QUEUE"
	echo "commit" >>"$FAKE_CLAUDE_QUEUE"

	run_beads_loop "epic-1"

	mapfile -t bd_calls <"$FAKE_BD_LOG"
	[ "${#bd_calls[@]}" -eq 3 ]
	[[ "${bd_calls[0]}" == ready* ]]
	[[ "${bd_calls[1]}" == close* ]]
	[[ "${bd_calls[2]}" == ready* ]]
	# claude is never asked to touch bead status itself.
	! grep -q "^bd " "$FAKE_CLAUDE_LOG"
}
