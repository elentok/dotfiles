#!/usr/bin/env bash
#
# Various helper functions.
#

has_command() {
  type "$1" > /dev/null 2>&1
}

command_missing() {
  ! has_command "$1"
}

is_running() {
  pgrep "$1" > /dev/null 2>&1
}

to_uppercase() {
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
