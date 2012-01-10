#!/bin/bash

echo ""
echo "========================================"
echo "Installing Java"
echo "========================================"

add-apt-repository -y ppa:ferramroberto/java
apt-get update
apt-get install -y sun-java6-jdk sun-java6-plugin
