#!/bin/bash

source `dirname $0`/../../config.sh

install_symlinks() {
  symlink "$DOTF/slate/slate.js" ~/.slate.js
}

header "Slate"
brew_cask_install slate
install_symlinks
