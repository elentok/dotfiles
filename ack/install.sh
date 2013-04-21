#!/bin/bash

source `dirname $0`/../config.sh

header "Ack-grep"

if [ "$OS" == "mac" ]; then
  brew_install ack
else
  apt_install ack-grep
fi

symlink "$DOTF/ack/ackrc" ~/.ackrc
