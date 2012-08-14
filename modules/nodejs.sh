#!/bin/bash

if [ "`uname -s`" == "Darwin" ]; then
  brew install nodejs
  curl https://npmjs.org/install.sh | sh
else
  sudo apt-get install -y python-software-properties
  sudo add-apt-repository ppa:chris-lea/node.js
  sudo apt-get update
  sudo apt-get install -y nodejs nodejs-dev npm
fi



sudo npm install -g coffee-script
sudo npm install -g supervisor
