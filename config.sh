#!/bin/bash

export BLACK="\033[30m"
export RED="\033[31m"
export GREEN="\033[32m"
export YELLOW="\033[33m"
export BLUE="\033[34m"
export CYAN="\033[36m"
export RESET="\033[0m"

DOTF=`dirname ${BASH_SOURCE[0]}`
export DOTF=`cd $DOTF && pwd`

header() {
  echo -e "${BLUE}☻ $*$RESET"
}

bullet() {
  echo -e "${CYAN}  ☻$RESET $*"
}

info() {
  echo -e "${BLACK}    ☻ $*$RESET"
}

success() {
  echo -e "${GREEN}    ✔ $*$RESET"
}

backup() {
  mv -f $1 ${1}.backup
}

symlink() {
  source=$1
  target=$2

  bullet "Linking $source => $target"
  if [ -e $target ]; then
    if [ -h $target ]; then
      if [ "$source" == "`readlink $target`" ]; then
        info "skipping, already exists"
        return
      fi
    fi

    info "backing up existing target to ${target}.backup"
    backup $target
  fi

  ln -sf $source $target
  success "done"
}

