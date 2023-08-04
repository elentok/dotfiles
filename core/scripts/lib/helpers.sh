#!/usr/bin/env bash
#
# Various helper functions.
#
if type dotf-has-command &> /dev/null; then
  echo 'helpers.sh is already loaded'
  return
fi

dotf-has-command() {
  type "$1" > /dev/null 2>&1
}

dotf-command-missing() {
  ! dotf-has-command "$1"
}

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
