#!/bin/bash

echo ""
echo "========================================"
echo "Installing tmux"
echo "========================================"

if [ "`uname -s`" == "Darwin" ]; then
  brew install tmux
else
  sudo apt-get install -y tmux
fi

echo ""
echo "========================================"
echo "Setting up .tmux.conf"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/tmux.conf" ~/.tmux.conf
