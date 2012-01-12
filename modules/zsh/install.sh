#!/bin/bash

echo ""
echo "========================================"
echo "Installing Zsh"
echo "========================================"

sudo apt-get install -y zsh

echo ""
echo "========================================"
echo "Installing Oh-My-Zsh"
echo "========================================"

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
usermod -s /bin/zsh david

echo ""
echo "========================================"
echo "Setting up .zshrc"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/zshrc" ~/.zshrc
ln -sf "$DIR/zshenv" ~/.zshenv
