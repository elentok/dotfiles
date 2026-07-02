#!/usr/bin/env bats

setup() {
	source "${BATS_TEST_DIRNAME}/../lib/common.sh"

	TEST_TMPDIR="$(mktemp -d)"
	# Isolate git's global config so tests never touch the real user's config.
	export HOME="${TEST_TMPDIR}/home"
	mkdir -p "$HOME"
	git config --global user.name "Global User"
	git config --global user.email "global@example.com"

	REPO_DIR="${TEST_TMPDIR}/repo"
	mkdir -p "$REPO_DIR"
	git -C "$REPO_DIR" init -q

	unset CLAUDE_BOX_PROVIDER CLAUDE_BOX_BEDROCK_MODEL EXTRA_ALLOWED_DOMAINS CLAUDE_BOX_EXTRA_DIRS CLAUDE_BOX_CONFIG AWS_REGION || true
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

fake_aws_success() {
	local bin_dir="${TEST_TMPDIR}/bin"
	mkdir -p "$bin_dir"
	cat >"${bin_dir}/aws" <<'EOF'
#!/usr/bin/env bash
if [[ "$1 $2" == "configure export-credentials" ]]; then
	cat <<'CREDS'
export AWS_ACCESS_KEY_ID=AKIAFAKE
export AWS_SECRET_ACCESS_KEY=secretfake
export AWS_SESSION_TOKEN=tokenfake
CREDS
	exit 0
fi
exit 1
EOF
	chmod +x "${bin_dir}/aws"
	PATH="${bin_dir}:${PATH}"
}

fake_aws_expired() {
	local bin_dir="${TEST_TMPDIR}/bin"
	mkdir -p "$bin_dir"
	cat >"${bin_dir}/aws" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
	chmod +x "${bin_dir}/aws"
	PATH="${bin_dir}:${PATH}"
}

# --- provider defaulting ---

@test "resolve_run_context defaults provider to subscription" {
	resolve_run_context "$REPO_DIR"
	[ "$CLAUDE_BOX_PROVIDER" = "subscription" ]
}

@test "resolve_run_context honors CLAUDE_BOX_PROVIDER env var" {
	export CLAUDE_BOX_PROVIDER="bedrock"
	resolve_run_context "$REPO_DIR"
	[ "$CLAUDE_BOX_PROVIDER" = "bedrock" ]
}

@test "resolve_run_context reads provider from per-machine config file" {
	export CLAUDE_BOX_CONFIG="${TEST_TMPDIR}/config.sh"
	echo 'CLAUDE_BOX_PROVIDER=bedrock' >"$CLAUDE_BOX_CONFIG"
	resolve_run_context "$REPO_DIR"
	[ "$CLAUDE_BOX_PROVIDER" = "bedrock" ]
}

@test "resolve_run_context env var outranks the per-machine config file" {
	export CLAUDE_BOX_CONFIG="${TEST_TMPDIR}/config.sh"
	echo 'CLAUDE_BOX_PROVIDER=bedrock' >"$CLAUDE_BOX_CONFIG"
	export CLAUDE_BOX_PROVIDER="subscription"
	resolve_run_context "$REPO_DIR"
	[ "$CLAUDE_BOX_PROVIDER" = "subscription" ]
}

# --- git identity ---

@test "resolve_git_identity uses the global identity with no repo-local override" {
	resolve_git_identity "$REPO_DIR"
	[ "$GIT_AUTHOR_NAME" = "Global User" ]
	[ "$GIT_AUTHOR_EMAIL" = "global@example.com" ]
	[ "$GIT_COMMITTER_NAME" = "Global User" ]
	[ "$GIT_COMMITTER_EMAIL" = "global@example.com" ]
}

@test "resolve_git_identity: repo-local override wins over global" {
	git -C "$REPO_DIR" config user.name "Repo User"
	git -C "$REPO_DIR" config user.email "repo@example.com"

	resolve_git_identity "$REPO_DIR"
	[ "$GIT_AUTHOR_NAME" = "Repo User" ]
	[ "$GIT_AUTHOR_EMAIL" = "repo@example.com" ]
	[ "$GIT_COMMITTER_NAME" = "Repo User" ]
	[ "$GIT_COMMITTER_EMAIL" = "repo@example.com" ]
}

@test "resolve_run_context wires git identity through" {
	git -C "$REPO_DIR" config user.name "Repo User"
	git -C "$REPO_DIR" config user.email "repo@example.com"

	resolve_run_context "$REPO_DIR"
	[ "$GIT_AUTHOR_NAME" = "Repo User" ]
	[ "$GIT_AUTHOR_EMAIL" = "repo@example.com" ]
}

# --- credential resolution ---

@test "resolve_credentials: subscription uses the claude-box-home volume" {
	resolve_credentials subscription
	[ "$CLAUDE_BOX_CRED_VOLUME" = "claude-box-home" ]
	[ "${#CLAUDE_BOX_CRED_ENV[@]}" -eq 0 ]
}

@test "resolve_credentials: bedrock injects AWS creds and required env" {
	fake_aws_success
	export AWS_REGION="eu-west-1"
	export CLAUDE_BOX_BEDROCK_MODEL="anthropic.claude-x"

	resolve_credentials bedrock

	local joined="${CLAUDE_BOX_CRED_ENV[*]}"
	[[ "$joined" == *"AWS_ACCESS_KEY_ID=AKIAFAKE"* ]]
	[[ "$joined" == *"AWS_SECRET_ACCESS_KEY=secretfake"* ]]
	[[ "$joined" == *"AWS_SESSION_TOKEN=tokenfake"* ]]
	[[ "$joined" == *"AWS_REGION=eu-west-1"* ]]
	[[ "$joined" == *"CLAUDE_CODE_USE_BEDROCK=1"* ]]
	[[ "$joined" == *"CLAUDE_CODE_ENABLE_AUTO_MODE=1"* ]]
	[[ "$joined" == *"ANTHROPIC_MODEL=anthropic.claude-x"* ]]
}

@test "resolve_credentials: bedrock fails fast with an aws sso login message on an expired session" {
	fake_aws_expired

	run resolve_credentials bedrock
	[ "$status" -ne 0 ]
	[[ "$output" == *"aws sso login"* ]]
}

# --- docker run-args builder ---

@test "build_run_args: subscription provider mounts the claude-box-home volume" {
	resolve_run_context "$REPO_DIR"
	resolve_credentials
	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"${REPO_DIR}:/workspace"* ]]
	[[ "$joined" == *"claude-box-home:/home/dev/.claude"* ]]
	[[ "$joined" == *"--cap-add=NET_ADMIN"* ]]
	[[ "$joined" == *"--cap-add=NET_RAW"* ]]
	[[ "$joined" != *"-e AWS_"* ]]
}

@test "build_run_args: subscription provider enables auto mode" {
	resolve_run_context "$REPO_DIR"
	resolve_credentials
	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"CLAUDE_CODE_ENABLE_AUTO_MODE=1"* ]]
}

@test "build_run_args: bedrock provider injects env vars instead of the home volume" {
	fake_aws_success
	export CLAUDE_BOX_PROVIDER="bedrock"
	resolve_run_context "$REPO_DIR"
	resolve_credentials

	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"AWS_ACCESS_KEY_ID=AKIAFAKE"* ]]
	[[ "$joined" != *"claude-box-home:/home/dev/.claude"* ]]
}

@test "build_run_args: no extra dirs means no extra -v mounts beyond the base set" {
	resolve_run_context "$REPO_DIR"
	resolve_credentials
	build_run_args

	local count=0
	local arg
	for arg in "${CLAUDE_BOX_RUN_ARGS[@]}"; do
		[[ "$arg" == "-v" ]] && count=$((count + 1))
	done
	# workspace, dotfiles core/ai (ro), claude-box-home
	[ "$count" -eq 3 ]
}

@test "build_run_args: --add-dir opts an extra directory into the mounts" {
	resolve_run_context "$REPO_DIR" "/extra/dir"
	resolve_credentials
	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"/extra/dir:/extra/dir"* ]]
}

@test "build_run_args: multiple --add-dir directories are all mounted" {
	resolve_run_context "$REPO_DIR" "/extra/one:/extra/two"
	resolve_credentials
	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"/extra/one:/extra/one"* ]]
	[[ "$joined" == *"/extra/two:/extra/two"* ]]
}

@test "build_run_args: sets git identity env vars" {
	git -C "$REPO_DIR" config user.name "Repo User"
	git -C "$REPO_DIR" config user.email "repo@example.com"

	resolve_run_context "$REPO_DIR"
	resolve_credentials
	build_run_args

	local joined="${CLAUDE_BOX_RUN_ARGS[*]}"
	[[ "$joined" == *"GIT_AUTHOR_NAME=Repo User"* ]]
	[[ "$joined" == *"GIT_AUTHOR_EMAIL=repo@example.com"* ]]
	[[ "$joined" == *"GIT_COMMITTER_NAME=Repo User"* ]]
	[[ "$joined" == *"GIT_COMMITTER_EMAIL=repo@example.com"* ]]
}
