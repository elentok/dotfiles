#!/bin/bash

source `dirname $0`/../config.sh

install_git() {
  if [ "$OS" == "mac" ]; then
    brew_install git
    brew_install tig
  else
    apt_install git tig
  fi
}

install_gitconfig() {
  bullet 'Installing ~/.gitconfig... '
  if [ -e ~/.gitconfig ]; then
    if [ -h ~/.gitconfig ]; then
      backup ~/.gitconfig

      echo "[include]" > ~/.gitconfig
      echo "  path = $DOTF/git/gitconfig" >> ~/.gitconfig
      success 'done'
    else
      if [ -n "$(grep "path = $DOTF/git/gitconfig" ~/.gitconfig)" ]; then
        info 'already installed'
      else
        echo >> ~/.gitconfig
        echo "[include]" >> ~/.gitconfig
        echo "  path = $DOTF/git/gitconfig" >> ~/.gitconfig
        success 'done'
      fi
    fi

  fi
}

install_symlinks() {
  symlink "$DOTF/git/tigrc" ~/.tigrc
}

header "Git"
if [ "$1" != "symlinks" ]; then
  install_git
fi

install_gitconfig
install_symlinks
