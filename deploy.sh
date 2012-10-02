#!/bin/bash
 
# Usage: ./deploy.sh [host] [role.json] [ssh key]
COOKBOOKS=''
 
host="${1:-aaron@192.168.2.105}"
role="${2}"
key="${3:-~/.ssh/id_rsa}" 

# if options have been speicified source them
if [ -f ./opts ]; then
  . ./opts 
fi

# copy over the cookbooks if they have been specified
if [ -d ${COOKBOOKS} ]; then
 # cp -R ${COOKBOOKS} .
  rsync -av --exclude='.git' ${COOKBOOKS} .
fi

# copy the role over 
if [ -f ${role} ]; then
  cp ${role} solo.json
  echo "Role ${role} copied, using run list from that"
else
  echo ${role} not found, exiting
  exit 1 
fi

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null
 
tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" -i "$key" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install-ubuntu-10.04.sh'
