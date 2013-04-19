#!/bin/bash

export BLACK="\033[30m"
export RED="\033[31m"
export GREEN="\033[32m"
export YELLOW="\033[33m"
export BLUE="\033[34m"
export CYAN="\033[36m"
export UNDERLINE="\033[4m"
export RESET="\033[0m"

if [ "`uname -s`" = "Darwin" ]; then
  export OS=mac
else
  export OS=linux
fi

DOTF=`dirname ${BASH_SOURCE[0]}`
export DOTF=`cd $DOTF && pwd`

header() {
  echo -e "\n${BLUE}${UNDERLINE}☻ $*$RESET"
}

bullet() {
  echo -e -n "${YELLOW}➜$RESET $*"
}

info() {
  echo -e "${BLACK}$*$RESET"
}

success() {
  echo -e "${GREEN}✔ $*$RESET"
}

error() {
  echo -e "${RED}✘ $*$RESET"
}

backup() {
  mv -f $1 ${1}.backup
}

symlink() {
  source=$1
  target=$2

  bullet "Linking $source\n      ==> ${target}..."
  if [ -e $target ]; then
    if [ -h $target ]; then
      if [ "$source" == "`readlink $target`" ]; then
        info " already exists"
        return
      fi
    fi

    info "backing up existing target to ${target}.backup"
    backup $target
  fi

  ln -sf $source $target
  success "done"
}

npm_install() {
  bullet "Installing ${1}..."

  if [ "`npm_cache | grep \"\\b$1\\b\"`" ]; then
    info " already installed"
  else
    npm install -g $*
  fi
}

rm -f /tmp/npm_cache

npm_cache() {
  if [ ! -e /tmp/npm_cache ]; then
    npm ls -g 2>/dev/null > /tmp/npm_cache
  fi
  cat /tmp/npm_cache
}

rm -f /tmp/gem_cache

gem_cache() {
  if [ ! -e /tmp/gem_cache ]; then
    gem list > /tmp/gem_cache
  fi
  cat /tmp/gem_cache
}

brew_install() {
  bullet "Installing ${1}... "

  if [ "`brew ls -1 | grep \"^$1\$\"`" != "" ]; then
    info "already installed"
  else
    brew install $*
  fi
}

gem_install() {
  for gem in $*; do
    gem_install_single $gem
  done
}

gem_install_single() {
  bullet "Installing gem ${1}... "
  if [ "`gem_cache | grep \"^$1\\b\"`" != "" ]; then
    info "already installed"
  else
    gem install $*
    rm -f /tmp/gem_cache
  fi
}

python_install() {
  bullet "Installing ${1}... "
  if [ "`which $1`" != "" ]; then
    info " already installed"
  else
    sudo easy_install $1
  fi
}

git_clone() {
  origin=$1
  target=$2
  bullet "Cloning $origin => ${target}..."
  if [ -d $target ]; then
    if [ -d $target/.git ]; then
      current_origin=`cd $target && git_get_origin`
      if [ "$current_origin" == "$origin" ]; then
        info " already cloned"
        # thought: (cd $target && git pull)
        return
      fi
    fi
    backup $target
  fi

  git clone $*
}

git_get_origin() {
  git remote -v | grep fetch | awk '{print $2}'
}
