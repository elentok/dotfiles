#!/bin/bash

echo ""
echo "========================================"
echo 'Installing the "Ubuntu Mono for Powerline" and "Monaco for Powerline" fonts'
echo "========================================"

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir -p ~/.fonts
cp -R "$DIR/ubuntu-mono-for-powerline" ~/.fonts
cp -R "$DIR/monaco-for-powerline" ~/.fonts
fc-cache -vf

echo "========================================"
echo "Installation complete."
echo ""
echo "Check https://github.com/Lokaltog/vim-powerline/wiki/Patched-fonts for more patched fonts"
echo "========================================"
