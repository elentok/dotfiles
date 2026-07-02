#!/usr/bin/env bash
# claude-box core logic: run-context resolution, credential resolution, and
# the docker run-args builder. Pure functions (no docker/network calls) that
# set well-known variables, so they're unit-testable with bats and callable
# in isolation by the claude-box/claude-beads wrappers.
set -euo pipefail

# resolve_git_identity <cwd> - set GIT_AUTHOR_NAME/EMAIL and
# GIT_COMMITTER_NAME/EMAIL from `git -C <cwd> config --get user.{name,email}`.
# git's own config layering means a repo-local user.name/email already wins
# over the global one; we just read the resolved value.
resolve_git_identity() {
	local cwd="${1:?resolve_git_identity requires a cwd}"

	GIT_AUTHOR_NAME="$(git -C "$cwd" config --get user.name || true)"
	GIT_AUTHOR_EMAIL="$(git -C "$cwd" config --get user.email || true)"
	GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
	GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
}

# resolve_run_context [cwd] [extra_dirs] - resolve the run context from (in
# precedence order) environment variables, a per-machine git-ignored config
# file (CLAUDE_BOX_CONFIG, default ~/.config/claude-box/config.sh), then
# built-in defaults. Sets CLAUDE_BOX_PROVIDER, CLAUDE_BOX_BEDROCK_MODEL,
# EXTRA_ALLOWED_DOMAINS, CLAUDE_BOX_CWD, CLAUDE_BOX_EXTRA_DIRS (colon-joined)
# and the GIT_AUTHOR_*/GIT_COMMITTER_* vars via resolve_git_identity.
resolve_run_context() {
	local cwd="${1:-$PWD}"
	local extra_dirs_arg="${2:-}"
	local config_file="${CLAUDE_BOX_CONFIG:-$HOME/.config/claude-box/config.sh}"

	# Preserve caller-set env vars so they outrank the per-machine config file.
	local env_provider="${CLAUDE_BOX_PROVIDER:-}"
	local env_bedrock_model="${CLAUDE_BOX_BEDROCK_MODEL:-}"
	local env_extra_domains="${EXTRA_ALLOWED_DOMAINS:-}"
	local env_extra_dirs="${CLAUDE_BOX_EXTRA_DIRS:-}"

	if [[ -f "$config_file" ]]; then
		# shellcheck disable=SC1090
		source "$config_file"
	fi

	CLAUDE_BOX_PROVIDER="${env_provider:-${CLAUDE_BOX_PROVIDER:-subscription}}"
	CLAUDE_BOX_BEDROCK_MODEL="${env_bedrock_model:-${CLAUDE_BOX_BEDROCK_MODEL:-}}"
	EXTRA_ALLOWED_DOMAINS="${env_extra_domains:-${EXTRA_ALLOWED_DOMAINS:-}}"
	CLAUDE_BOX_EXTRA_DIRS="${extra_dirs_arg:-${env_extra_dirs:-${CLAUDE_BOX_EXTRA_DIRS:-}}}"
	CLAUDE_BOX_CWD="$cwd"

	resolve_git_identity "$cwd"
}

# resolve_credentials [provider] - resolve provider credentials into
# CLAUDE_BOX_CRED_ENV (array of KEY=VALUE docker -e assignments) and
# CLAUDE_BOX_CRED_VOLUME (named volume for the subscription path). Fails fast
# with a clear message if the host AWS session is expired.
resolve_credentials() {
	local provider="${1:-${CLAUDE_BOX_PROVIDER:-subscription}}"

	CLAUDE_BOX_CRED_ENV=()
	CLAUDE_BOX_CRED_VOLUME=""

	case "$provider" in
	bedrock)
		local aws_creds
		if ! aws_creds="$(aws configure export-credentials --format env 2>/dev/null)"; then
			echo "claude-box: AWS session expired or not configured. Run 'aws sso login' and try again." >&2
			return 1
		fi

		local line
		while IFS= read -r line; do
			line="${line#export }"
			[[ -n "$line" ]] && CLAUDE_BOX_CRED_ENV+=("$line")
		done <<<"$aws_creds"

		CLAUDE_BOX_CRED_ENV+=(
			"AWS_REGION=${AWS_REGION:-us-east-1}"
			"CLAUDE_CODE_USE_BEDROCK=1"
			"CLAUDE_CODE_ENABLE_AUTO_MODE=1"
		)
		if [[ -n "${CLAUDE_BOX_BEDROCK_MODEL:-}" ]]; then
			CLAUDE_BOX_CRED_ENV+=("ANTHROPIC_MODEL=${CLAUDE_BOX_BEDROCK_MODEL}")
		fi
		;;
	subscription | *)
		CLAUDE_BOX_CRED_VOLUME="claude-box-home"
		;;
	esac
}

# build_run_args - assemble CLAUDE_BOX_RUN_ARGS (an array of `docker run`
# flags) from the context resolved by resolve_run_context/resolve_credentials.
# Pure: only reads already-resolved variables, never touches docker itself.
build_run_args() {
	local cwd="${CLAUDE_BOX_CWD:?build_run_args requires resolve_run_context to run first}"
	local provider="${CLAUDE_BOX_PROVIDER:-subscription}"

	CLAUDE_BOX_RUN_ARGS=(
		--rm -it
		--cap-add=NET_ADMIN --cap-add=NET_RAW
		-v "${cwd}:/workspace"
		-w /workspace
		-v "${HOME}/.dotfiles/core/ai:/home/dev/.dotfiles/core/ai:ro"
	)

	case "$provider" in
	bedrock)
		local kv
		for kv in "${CLAUDE_BOX_CRED_ENV[@]}"; do
			CLAUDE_BOX_RUN_ARGS+=(-e "$kv")
		done
		;;
	subscription | *)
		CLAUDE_BOX_RUN_ARGS+=(
			-v "${CLAUDE_BOX_CRED_VOLUME:-claude-box-home}:/home/dev/.claude"
			-e "CLAUDE_CODE_ENABLE_AUTO_MODE=1"
		)
		;;
	esac

	if [[ -n "${CLAUDE_BOX_EXTRA_DIRS:-}" ]]; then
		local dir
		local extra_dirs=()
		IFS=':' read -ra extra_dirs <<<"$CLAUDE_BOX_EXTRA_DIRS"
		for dir in "${extra_dirs[@]}"; do
			if [[ -n "$dir" ]]; then
				CLAUDE_BOX_RUN_ARGS+=(-v "${dir}:${dir}")
			fi
		done
	fi

	CLAUDE_BOX_RUN_ARGS+=(
		-e "GIT_AUTHOR_NAME=${GIT_AUTHOR_NAME:-}"
		-e "GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL:-}"
		-e "GIT_COMMITTER_NAME=${GIT_COMMITTER_NAME:-}"
		-e "GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL:-}"
	)
}
