#!/bin/bash

source `dirname $0`/../config.sh

header "NodeJS"

if [ "$OS" == "mac" ]; then
  brew_install node
  #curl https://npmjs.org/install.sh | sh
else
  sudo apt-get install -y python-software-properties
  sudo add-apt-repository ppa:chris-lea/node.js
  sudo apt-get update
  sudo apt-get install -y nodejs nodejs-dev npm
fi



npm_install coffee-script
npm_install supervisor
npm_install grunt
npm_install grunt-cli
npm_install bower
npm_install json
npm_install mocha

npm_install dns-switcher
npm_install tailr
npm_install logparty
