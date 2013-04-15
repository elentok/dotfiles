#!/bin/bash

source `dirname $0`/../config.sh

install_git() {
  if [ "$OS" == "mac" ]; then
    brew_install git
    brew_install tig
  else
    sudo apt-get install -y git giggle tig
  fi
}

install_symlinks() {
  symlink "$DOTF/git/gitconfig" ~/.gitconfig
  symlink "$DOTF/git/tigrc" ~/.tigrc
}

header "Git"
if [ "$1" != "symlinks" ]; then
  install_git
fi
install_symlinks
