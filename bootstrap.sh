#!/usr/bin/env bash
#
# This scripts makes sure all requirements to run the "core/scripts/dotf2"
# script are installed and then runs it.

set -euo pipefail

function main() {
  echo "Checking requirements are installed..."
  echo

  echo -n "- Checking for python3... "
  if has-command python3; then
    echo "installed."
  else
    echo "missing, installing."
    if has-command apt; then
      sudo apt install -y python3
    else
      echo 'ERROR: Only Debian is currently supported.'
      exit 1
    fi
  fi

  echo
  echo "All requirements are ready, running dotf2 install."
  echo
  dotf2 install
}

function has-command() {
  type "$1" > /dev/null 2>&1
}

main "$@"
