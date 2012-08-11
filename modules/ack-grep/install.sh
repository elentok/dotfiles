#!/bin/bash

echo ""
echo "========================================"
echo "Installing Ack-grep"
echo "========================================"
if [ "`uname -s`" == "Darwin" ]; then
  brew install ack
else
  sudo apt-get install -y ack-grep
fi

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/ackrc" ~/.ackrc
