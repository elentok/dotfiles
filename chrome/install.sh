#!/bin/bash

source `dirname $0`/../config.sh

install_symlinks() {
  symlink "$DOTF/chrome/Custom.css" "$HOME/Library/Application Support/Google/Chrome/Default/User StyleSheets/Custom.css"
}

header "Chrome"
install_symlinks
