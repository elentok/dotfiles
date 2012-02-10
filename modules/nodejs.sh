#!/bin/bash

sudo apt-get install python-software-properties
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs nodejs-dev npm

sudo npm install -g coffee-script
sudo npm install -g supervisor
