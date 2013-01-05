#!/bin/bash

echo ""
echo "========================================"
echo "Installing tmux"
echo "========================================"

if [ "`uname -s`" == "Darwin" ]; then
  brew install tmux

  brew install reattach-to-user-namespace
  # for more info, see:
  #   http://robots.thoughtbot.com/post/19398560514/how-to-copy-and-paste-with-tmux-on-mac-os-x
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
