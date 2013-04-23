#!/bin/bash

source `dirname $0`/../config.sh

install_symlinks() {
  symlink "$DOTF/slate/config" ~/.slate
}

header "Slate"
install_symlinks
