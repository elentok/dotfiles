#!/bin/bash

echo ""
echo "========================================"
echo "Installing Git"
echo "========================================"

if [ "`uname -s`" == "Darwin" ]; then
  brew install git
else
  sudo apt-get install -y git giggle
fi

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/gitconfig" ~/.gitconfig

#cd /tmp
#git clone https://github.com/apenwarr/git-subtree/
#cd git-subtree
#sudo make install
