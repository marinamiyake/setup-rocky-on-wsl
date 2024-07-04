#!/bin/bash

# Show current directory (start directory=~(changed after .bashrc file was loaded), user=created user(specified by /etc/wsl.conf))
echo --------------------
echo current user: 
$user
echo current directory: 
pwd
echo --------------------

# Install git
sudo yum -y install git

# Create SSH key
ssh-keygen -p "" -f ~/.ssh
echo SSH Key generated.
echo Public key:
cat ~/.ssh/id_rsa.pub
echo Add the public key to your GitHub account.
echo URL: 
echo https://github.com/settings/ssh/new
