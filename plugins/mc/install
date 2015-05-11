#!/bin/bash

echo ""
echo "========================================"
echo "Installing Midnight Commander"
echo "========================================"

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

if [ "`uname -s`" == "Darwin" ]; then
  brew install mc
  mkdir -p ~/.config/mc
  ln -sf "$DIR/ini" ~/.config/mc/ini
else
  sudo apt-get install -y mc
  mkdir -p ~/.mc
  ln -sf "$DIR/ini" ~/.mc/ini
fi

