#!/bin/bash

echo ""
echo "========================================"
echo "Installing Midnight Commander"
echo "========================================"
sudo apt-get install -y mc

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.mc
ln -sf "$DIR/ini" ~/.mc/ini
