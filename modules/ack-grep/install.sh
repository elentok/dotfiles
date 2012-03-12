#!/bin/bash

echo ""
echo "========================================"
echo "Installing Ack-grep"
echo "========================================"
sudo apt-get install ack-grep

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -sf "$DIR/ackrc" ~/.ackrc
