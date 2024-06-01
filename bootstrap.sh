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

  mkdir -p ~/.config

  echo "- Updating git submodules..."
  git submodule update --init --recursive

  if dotf-is-mac; then
    setup-mac
  fi

  setup-deno

  echo
  echo "All requirements are ready, running dotf setup."
  echo "=================================================="
  echo

  "$DOTF/core/scripts/dotf" setup
}

function setup-mac() {
  setup-homebrew

  # Mac comes with an ancient bash version
  if ! has-bash5; then
    brew install bash
  fi
}

function setup-homebrew() {
  if ! has-command brew; then
    install-homebrew
  else
    echo '- Updating brew... '
    brew update
  fi
}

function setup-deno() {
  echo "- Setting up deno..."
  if has-command deno; then
    echo "  Deno is already installed."
    echo
  else
    if dotf-is-mac; then
      brew install deno
    else
      dotf-apt curl
      curl -fsSL https://deno.land/x/install/install.sh | sh
    fi
  fi

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
  sudo xcodebuild -license accept
  sudo xcode-select --install

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function has-command() {
  type "$1" > /dev/null 2>&1
}

main "$@"
