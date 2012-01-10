#!/bin/bash

# ========================================
# Install LAMP (Linux Apache MySQL PHP)
apt-get install tasksel
tasksel install lamp-server
apt-get install php5-sqlite
service apache2 restart
