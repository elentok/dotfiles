#!/bin/bash

sudo apt-get install mesa-utils

# add the ironhide repository 
# (see https://launchpad.net/~mj-casalogic/+archive/ironhide/)
sudo apt-add-repository ppa:mj-casalogic/ironhide

sudo apt-get update

sudo apt-get install ironhide ironhide-ui
