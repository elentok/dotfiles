#!/usr/bin/env bash
#
# Various helper functions.
#

source "$DOTF/core/scripts/lib/core-helpers.sh"

dotf-is-running() {
  pgrep "$1" > /dev/null 2>&1
}

dotf-to-uppercase() {
  if [ $# -gt 0 ]; then
    echo "$@" | awk '{print toupper($0)}'
  else
    awk '{print toupper($0)}'
  fi
}

dotf-trim() {
  sed -E 's/(^\s+|\s+$)//g'
}

dotf-filesize() {
  stat -c%s "$1"
}

function file-owner() {
  if is-gnu-stat; then
    stat --format=%U "$*"
  else
    stat -f '%Su' "$*"
  fi
}

function is-gnu-stat() {
  if dotf-is-mac; then
    [[ "$(which stat)" =~ /gnubin/ ]]
  else
    return 0
  fi
}
