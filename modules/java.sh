#!/bin/bash

echo ""
echo "========================================"
echo "Installing Java"
echo "========================================"

sudo add-apt-repository -y ppa:ferramroberto/java
sudo apt-get update
sudo apt-get install -y sun-java6-jdk sun-java6-plugin
