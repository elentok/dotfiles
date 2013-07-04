#!/bin/bash

source `dirname $0`/../config.sh

install_symlinks() {
  CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"

  while read dir; do
    symlink "$DOTF/chrome/Custom.css" "$dir/Custom.css"
  done < <(find "$CHROME_DIR" -iname 'User StyleSheets')

}

header "Chrome"
install_symlinks
