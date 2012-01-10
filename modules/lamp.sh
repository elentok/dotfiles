#!/bin/bash

echo ""
echo "========================================"
echo "Installing LAMP (Linux Apache MySQL PHP)"
echo "========================================"
apt-get install -y tasksel
tasksel install lamp-server
apt-get install -y php5-sqlite
service apache2 restart
