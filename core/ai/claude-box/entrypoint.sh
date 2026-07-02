#!/usr/bin/env bash
# Container entrypoint: apply the egress firewall as root, then drop to the
# non-root 'dev' user and exec the workload (a shell or `claude ...`).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./init-firewall.sh
source "${SCRIPT_DIR}/init-firewall.sh"
apply_firewall

exec gosu dev "$@"
