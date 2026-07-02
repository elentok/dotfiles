#!/usr/bin/env bash
# Run the claude-box bats test suite.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v bats >/dev/null 2>&1; then
	echo "bats-core is required: brew install bats-core" >&2
	exit 1
fi

exec bats "${SCRIPT_DIR}"
