#!/bin/bash

echo ""
echo "========================================"
echo "Installing Zsh"
echo "========================================"

if [ "`uname -s`" == "Darwin" ]; then
  brew install zsh
  chsh -s /bin/zsh
else
  sudo apt-get install -y zsh
  sudo usermod -s /bin/zsh $USER
fi

echo ""
echo "========================================"
echo "Installing Oh-My-Zsh"
echo "========================================"

if [ ! -d ~/.oh-my-zsh ]; then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

echo ""
echo "========================================"
echo "Setting up .zshrc"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/zshrc" ~/.zshrc

if [ "`uname -s`" == "Linux" ]; then
  ln -sf "$DIR/zshenv" ~/.zshenv
fi
