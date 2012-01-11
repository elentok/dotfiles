#!/bin/bash

echo ""
echo "========================================"
echo "Installing Git"
echo "========================================"
sudo apt-get install git 

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/gitconfig" ~/.gitconfig
