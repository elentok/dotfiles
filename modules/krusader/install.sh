#!/bin/bash

echo ""
echo "========================================"
echo "Installing Krusader"
echo "========================================"

sudo apt-get install -y kruader

echo ""
echo "========================================"
echo "Setting up krusaderrc"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

target=~/.kde/share/config
mkdir -p $target

ln -sf "$DIR/krusaderrc" "$target/krusaderrc"
