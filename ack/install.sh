#!/bin/bash

source `dirname $0`/../config.sh

header "Ack-grep"

if [ "$OS" == "mac" ]; then
  brew_install ack
else
  sudo apt-get install -y ack-grep
fi

symlink "$DOTF/ack/ackrc" ~/.ackrc
