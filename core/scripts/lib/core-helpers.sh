#!/usr/bin/env bash

if type dotf-has-command &> /dev/null; then
  return
fi

function dotf-has-command() {
  type "$1" > /dev/null 2>&1
}

function dotf-command-missing() {
  ! dotf-has-command "$1"
}

function dotf-is-zsh() {
  [ -n "${ZSH_VERSION:-}" ]
}

function dotf-is-bash() {
  [ -n "${BASH_VERSION:-}" ]
}

function dotf-plugin-list() {
  if [ ! -e "$DOTP" ]; then
    return
  fi

  if dotf-is-zsh; then
    files=("$DOTP"/*(N))
    for file in "${files[@]}"; do
      echo "$file"
    done
  else
    shopt -s nullglob
    for file in "$DOTP"/*; do
      echo "$file"
    done
    shopt -u nullglob
  fi
}

function dotf-plugin-list-files() {
  local filepath="$1"

  for plugin in $(dotf-plugin-list); do
    if [ -e "$plugin/$filepath" ]; then
      echo "$plugin/$filepath"
    fi
  done
}
