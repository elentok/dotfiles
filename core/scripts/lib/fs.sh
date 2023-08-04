#!/usr/bin/env bash

function dotf-symlink() {
  source=$1
  target=$2

  dotf-bullet "Linking $source"
  echo -ne "\n      ==> ${target}... "
  if [ -e "$target" ]; then
    if [ -h "$target" ]; then
      if [ "$source" == "$(readlink "$target")" ]; then
        dotf-info " already exists"
        return
      fi
    fi

    dotf-backup "$target"
  fi

  if ! ln -sf "$source" "$target"; then
    dotf-info "  Can't create link, trying with sudo:"
    if ! sudo ln -sf "$source" "$target"; then
      dotf-error "failed"
      exit 1
    fi
  fi
  dotf-success "done"
}

function dotf-backup() {
  echo
  dotf-info "  backing up to ${1}.backup"
  if mv -f "$1" "${1}.backup"; then
    return
  fi

  dotf-info "  trying with sudo:"
  if ! sudo mv -f "$1" "${1}.backup"; then
    dotf-error "FAILED"
    exit 1
  fi
}
