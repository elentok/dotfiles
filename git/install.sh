#!/bin/bash

source `dirname $0`/../config.sh

install_git() {
  header "Installing Git"

  if [ "$OS" == "mac" ]; then
    brew install git
    brew install tig
  else
    sudo apt-get install -y git giggle tig
  fi
}

install_symlinks() {
  header "Installing git symlinks"
  symlink "$DOTF/git/gitconfig" ~/.gitconfig
  symlink "$DOTF/git/tigrc" ~/.tigrc
}

if [ "$1" == "symlinks" ]; then
  install_symlinks
else
  install_git
  install_symlinks
fi
