#!/bin/bash

if [ "$2" == "" ]; then
  echo "Usage:"
  echo ""
  echo "  add-smb-user.sh {username} {password}"
  exit 1
fi

username=$1
password=$2

#sudo useradd $username -p $password -g users
echo ""
echo "* Setting smb password"
smbpasswd -a $username

echo ""
echo "* Adding to smbusers"
echo "'$username' = \"$username\"'" >> /etc/samba/smbusers

echo ""
echo "* Restartin SMB service"
service smbd restart
