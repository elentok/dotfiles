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

function dotf-color() {
  if [ $# -lt 1 ]; then
    echo "Usage: dotf-color <color> [optional: text]"
    return 1
  fi

  color="$1"
  shift

  case "$color" in
    black) echo -ne "\\033[30m" ;;
    gray) echo -ne "\\033[1;30m" ;;
    red) echo -ne "\\033[31m" ;;
    green) echo -ne "\\033[32m" ;;
    yellow) echo -ne "\\033[33m" ;;
    blue) echo -ne "\\033[34m" ;;
    purple) echo -ne "\\033[35m" ;;
    cyan) echo -ne "\\033[36m" ;;
    underline) echo -ne "\\033[4m" ;;
    reset) echo -ne "\\033[0m" ;;
  esac

  if [ $# -gt 0 ]; then
    echo -n "$@"
    dotf-color reset
  fi
}

# Special Characters {{{1

export HOURGLASS="⏳ "

# Border {{{1

function dotf-border() {
  if [ $# -lt 3 ]; then
    echo "Usage: dotf-border <normal|padded> <color> <text>"
    return 1
  fi
  local type="$1"
  local color="$2"
  shift 2

  dotf-color "$color"

  local text="$*"

  if [ "$type" = 'padded' ]; then
    text="    ${text}    "
    local lines="${text//?/─}"
    local spaces="${text//?/ }"
    echo "┌─${lines}─┐"
    echo "│ ${spaces} │"
    echo "│ ${text} │"
    echo "│ ${spaces} │"
    echo "└─${lines}─┘"
  else
    text="  ${text}  "
    local lines="${text//?/─}"
    echo "┌─${lines}─┐"
    echo "│ ${text} │"
    echo "└─${lines}─┘"
  fi

  dotf-color reset
}

# Print {{{1
function dotf-header() {
  if [ $# -lt 1 ]; then
    echo "Usage: dotf-header <h1|h2|h3> <text>"
    return 1
  fi

  local level="$1"
  shift

  case "$level" in
    h1) dotf-border padded yellow "   $*   " ;;
    h2) dotf-border normal blue "  $*  " ;;
    h3) dotf-border normal purple "$@" ;;
    demo)
      dotf-header h1 "Header 1"
      dotf-header h2 "Header 2"
      dotf-header h3 "Header 3"
      ;;
    *)
      echo "ERROR: Invalid header argument '$level' for dotf-header"
      return 1
      ;;
  esac
}

dotf-bullet() {
  echo "$(dotf-color yellow •) $*"
}

dotf-info() {
  dotf-color cyan "$@"
  echo
}

dotf-success() {
  dotf-color green "✔ $*"
  echo
}

dotf-error() {
  dotf-color red "✔ $*"
  echo
}

clear_line() {
  echo -e -n "$CLEAR_LINE"
}

show_result() {
  if [ $? -eq 0 ]; then
    dotf-success 'done'
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
