#!/bin/bash

source `dirname $0`/config.sh

main() {
  plugin nodejs
  plugin git
  plugin zsh
  plugin tmux
  plugin vim
  plugin ruby
  plugin todo
  plugin mpd
}

mac_plugins() {
  plugin keyremap4macbook
  plugin homebrew-cask.sh

  brew_install imagemagick
  brew_install ghostscript
}

linux_plugins() {
  apt_install mercurial htop samba libpam-smbpass unrar

  if [ "$HAS_GUI" != 'yes' ]; then
    plugin linux-gui-apps
  fi
}

plugin() {
  local filename="$DOTF/${1}/install.sh"

  if [ ! -x $filename ]; then
    local filename="$DOTF/plugins/${1}.sh"
  fi

  if [ ! -x $filename ]; then
    filename="$DOTF/plugins/$1/install.sh"
  fi

  $filename
}

main $*
