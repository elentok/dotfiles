#!/usr/bin/env bash
#
# This scripts makes sure all requirements to run "dotf install"
# script are installed and then runs it.

set -euo pipefail

DOTF="$(dirname "${BASH_SOURCE[0]-$0}")"
DOTF="$(cd "$DOTF" && pwd)"
export DOTF

function main() {
  echo "=================================================="
  echo "Checking requirements are installed..."
  echo

  install-if-missing python3 python3
  install-if-missing pip3 python3-pip

  echo "- Upgrading pip3..."
  pip3 install pip --upgrade --user

  echo "- Updating git submodules..."
  git submodule update --init --recursive

  echo
  echo "All requirements are ready, running dotf bootstrap."
  echo "=================================================="
  echo

  "$DOTF/core/scripts/dotf" bootstrap
}

function install-if-missing() {
  local command="$1"
  local pkg="$2"

  echo -n "- Checking for ${command}... "
  if has-command "${command}"; then
    echo "installed."
  else
    echo "missing, installing."
    if has-command apt; then
      sudo apt install -y "${pkg}"
    else
      echo 'ERROR: Only Debian is currently supported.'
      exit 1
    fi
  fi

}

function has-command() {
  type "$1" > /dev/null 2>&1
}

main "$@"
