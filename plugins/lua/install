#!/bin/bash

source `dirname $0`/../../config.sh

if is_mac; then
  brew_install luarocks
  brew_install libyaml
  luarocks install lyaml YAML_DIR=$BREW_HOME
fi
