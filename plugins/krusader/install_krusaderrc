#!/bin/bash

echo ""
echo "========================================"
echo "Setting up krusaderrc"
echo "========================================"
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

target=~/.kde/share/config
mkdir -p $target

cp -f "$DIR/krusaderrc" "$target/krusaderrc"
