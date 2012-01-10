#!/bin/bash

# This script should be run directly from the online repository like this:
# curl -L https://bitbucket.org/3david/linux-config/raw/1b4675df052a/online_install.sh | sh
#
# Prerequisits:
# sudo apt-get install mercurial curl

(
  mkdir -p ~/projects
  cd ~/projects

  echo ""
  echo "========================================"
  echo "Cloning linux-config"
  hg clone ssh://hg@bitbucket.org/3david/linux-config

  echo ""
  echo "========================================"
  echo "Cloning vimconfig"
  hg clone ssh://hg@bitbucket.org/3david/vimconfig

  echo "========================================"
  echo "setting up vim"
  (
    cd vimconfig
    ./create-symlinks.sh
  )

  echo "========================================"
  echo "setting up linux"
  (
    cd linux-config
    ./install.sh
  )
)
