#!/bin/bash

echo ""
echo "========================================"
echo "Installing tmux"
echo "========================================"

sudo apt-get install -y tmux

echo ""
echo "========================================"
echo "Setting up .tmux.conf"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/tmux.conf" ~/.tmux.conf
