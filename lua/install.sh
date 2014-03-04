#!/bin/bash

brew install luarocks

brew install libyaml
luarocks install lyaml YAML_DIR=$BREW_HOME
