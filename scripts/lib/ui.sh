#!/usr/bin/env bash
# vim: foldmethod=marker

# Colors {{{1
export BLACK="\\033[30m"
export GRAY="\\033[1;30m"
export RED="\\033[31m"
export GREEN="\\033[32m"
export YELLOW="\\033[33m"
export BLUE="\\033[34m"
export CYAN="\\033[36m"
export UNDERLINE="\\033[4m"
export RESET="\\033[0m"
export CLEAR_LINE="\\r\\033[K"

function color-green() {
  echo -e "$GREEN"
}

function color-blue() {
  echo -e "$BLUE"
}

function color-reset() {
  echo -e "$RESET"
}

# Special Characters {{{1

export HOURGLASS="⏳ "

# Display methods (header/bullet/info/success/error) {{{1
title() {
  echo -e "$YELLOW"
  print-padded-border "$@"
  echo -e "$RESET"
}

header() {
  echo -e "$BLUE"
  print-border "$@"
  echo -e "$RESET"
}

print-padded-border() {
  local text="$*"
  # replace all characters with "="
  local lines="${text//?/─}"
  local spaces="${text//?/ }"

  echo "┌───${lines}───┐"
  echo "│   ${spaces}   │"
  echo "│   ${text}   │"
  echo "│   ${spaces}   │"
  echo "└───${lines}───┘"
}

print-border() {
  local text="$*"
  # replace all characters with "="
  local lines="${text//?/─}"

  echo "┌─${lines}─┐"
  echo "│ ${text} │"
  echo "└─${lines}─┘"
}

bullet() {
  echo -e -n "${YELLOW}•$RESET $*"
}

clear_line() {
  echo -e -n "$CLEAR_LINE"
}

info() {
  echo -e "${CYAN}$*$RESET"
}

success() {
  echo -e "${GREEN}✔ $*$RESET"
}

error() {
  echo -e "${RED}✘ $*$RESET"
}

show_result() {
  if [ $? -eq 0 ]; then
    success 'done'
  else
    error 'FAIL'
    if [ "$1" = "die_on_error" ]; then
      exit 1
    else
      return 1
    fi
  fi
}

# Confirm {{{1
confirm() {
  local default=${2:-no}
  ask "${1} (yes/no)?" yesno $default
  [ "$yesno" = "yes" -o "$yesno" = "y" ]
  return $?
}

# Ask {{{1
# (by @n0nick)
# Usage:
#   ask "What's up?" answer "ok"
#   echo $answer
ask() {
  local question=$1
  local default=${3:-}
  local resultvar=$2

  echo -ne "$question "
  if [ "$default" ]; then
    echo -n "[$default] "
  fi
  read ${read_args:-} reply
  echo

  reply="${reply:-$default}"
  reply=$(echo $reply | sed "s/'/'\"'\"'/g")
  eval $resultvar="'$reply'"
}

ask_password() {
  local question=$1
  local resultvar=$2

  read_args="-s" ask "$question" password1
  read_args="-s" ask "Enter again to confirm: " password2

  if [ "$password1" = "$password2" ]; then
    eval $resultvar=$(printf %q $password1)
  else
    echo "The passwords don't match, please try again."
    ask_password "$@"
  fi
}

pause() {
  local text=${1:-Press any key to continue... }
  echo -ne "$text"
  read -n 1
}
