#!/bin/bash

source `dirname $0`/../config.sh

install_neovim() {
  brew_tap neovim/homebrew-neovim 
  brew_install neovim
}

install_symlinks() {
  symlink "$DOTF/nvim/nvimrc" ~/.nvimrc
}

install_neovim
install_symlinks
