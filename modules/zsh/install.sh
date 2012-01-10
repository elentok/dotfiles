#!/bin/bash

# ========================================
# Install ZSH
apt-get install zsh

# ========================================
# Install oh-my-zsh

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
usermod -s /bin/zsh david

# ========================================
# Setup .zshrc
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

ln -s "$DIR/zshrc" ~/.zshrc
