#!/bin/bash

source `dirname $0`/../config.sh

uninstall_symlinks() {
  CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"

  while read dir; do
    if [ -e "$DOTF/chrome/Custom.css" ]; then
      echo "Deleting $DOTF/chrome/Custom.css"
      rm "$DOTF/chrome/Custom.css"
    fi
  done < <(find "$CHROME_DIR" -iname 'User StyleSheets')

}

header "Chrome"
uninstall_symlinks
