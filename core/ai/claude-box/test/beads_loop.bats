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

	unset CLAUDE_BEADS_MAX_REPAIRS CLAUDE_BEADS_MAX_ITER CLAUDE_BEADS_VERIFY_CMD || true
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

if [[ "$action" == "commit" ]]; then
	git commit -q --allow-empty -m "fake work"
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
