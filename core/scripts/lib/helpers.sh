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
