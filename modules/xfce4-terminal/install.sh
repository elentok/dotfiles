#!/bin/bash

echo ""
echo "========================================"
echo "Installing XFCE4-Terminal"
echo "========================================"
sudo apt-get install -y xfce4-terminal

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.config/Terminal
ln -sf "$DIR/terminalrc" ~/.config/Terminal/terminalrc

# use xfce4-terminal as the default
sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
