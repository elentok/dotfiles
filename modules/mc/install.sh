#!/bin/bash

# ========================================
# Install Midnight Commander
apt-get install mc

# ========================================
# Create Symlinks

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

mkdir ~/.mc
ln -s "$DIR/ini" ~/.mc/ini
