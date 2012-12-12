#!/bin/bash

echo ""
echo "========================================"
echo "Installing Git"
echo "========================================"

if [ "`uname -s`" == "Darwin" ]; then
  brew install git
  brew install tig
else
  sudo apt-get install -y git giggle
fi

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/gitconfig" ~/.gitconfig
ln -sf "$DIR/tigrc" ~/.tigrc

#cd /tmp
#git clone https://github.com/apenwarr/git-subtree/
#cd git-subtree
#sudo make install
