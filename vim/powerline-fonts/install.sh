#!/bin/bash

source `dirname $0`/../../config.sh

header 'Installing the Powerline fonts'

if [ "$OS" == "mac" ]; then
  font_dir="$HOME/Library/Fonts"
else
  font_dir="$HOME/.fonts"
  mkdir -p $font_dir
fi

find "$DOTF/vim/powerline-fonts" -name '*.[o,t]tf' -type f | \
  while read file; do
    copy_to_dir "$file" "$font_dir"
  done

# For linux
if [ "$OS" == "linux" ]; then
  bullet "Updating font cache"
  fc-cache -v -f $font_dir
fi
