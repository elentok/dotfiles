#!/usr/bin/env bash
#
# This scripts makes sure all requirements to run "dotf bootstrap"
# script are installed and then runs it.

set -euo pipefail

DOTF="$(dirname "${BASH_SOURCE[0]-$0}")"
DOTF="$(cd "$DOTF" && pwd)"
export DOTF

source "$DOTF/core/scripts/lib/os.sh"

function main() {
  echo "=================================================="
  echo "Checking requirements are installed..."
  echo

  install-if-missing python3 python3
  install-if-missing pip3 python3-pip

  mkdir -p ~/.config

  echo "- Upgrading pip3..."
  pip3 install pip --upgrade --user

  echo "- Updating git submodules..."
  git submodule update --init --recursive

  if dotf-is-mac; then
    if ! has-command brew; then
      install-homebrew
    else
      echo '- Updating brew... '
      brew update

      # Mac comes with an ancient bash version
      if ! has-bash5; then
        brew install bash
      fi
    fi
  fi

  echo
  echo "All requirements are ready, running dotf setup."
  echo "=================================================="
  echo

  "$DOTF/core/scripts/dotf" setup
}

function has-bash5() {
  bash --version | grep 'GNU bash, version 5\.[0-9]' > /dev/null
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

function install-homebrew() {
  export BREW_HOME=~/.homebrew

  git clone https://github.com/Homebrew/brew $BREW_HOME

  export PATH=$BREW_HOME/bin:$PATH

  #sudo xcodebuild -license accept
  #sudo xcode-select --install

  eval "$($BREW_HOME/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
}

function has-command() {
  type "$1" > /dev/null 2>&1
}

main "$@"
