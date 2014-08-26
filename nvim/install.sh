#!/bin/bash

source `dirname $0`/../config.sh

install_neovim() {
  brew install --HEAD https://raw.github.com/neovim/neovim/master/neovim.rb
}

install_symlinks() {
  symlink "$DOTF/nvim/nvimrc" ~/.nvimrc
}

install_neovim
install_symlinks
