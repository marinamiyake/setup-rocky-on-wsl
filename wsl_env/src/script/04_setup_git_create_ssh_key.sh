#!/bin/bash

# Show current directory (start directory=~(changed after .bashrc file was loaded), user=created user(specified by /etc/wsl.conf))
echo --------------------
echo current user: 
whoami
echo current directory: 
pwd
echo --------------------

# Install git
sudo yum -y install git

# Create SSH key
echo Create SSH key. Press Enter to all the questions.
ssh-keygen
echo Created SSH public key:
cat ~/.ssh/id_rsa.pub
echo Add the public key to your GitHub account.
echo URL: 
echo https://github.com/settings/ssh/new
