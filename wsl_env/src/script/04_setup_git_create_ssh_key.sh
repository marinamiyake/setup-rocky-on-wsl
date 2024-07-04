#!/bin/bash

# Install git
sudo -S $1 yum -y install git

# Create SSH key
echo Generate SSH key. Press Enter to all the question.
ssh-keygen
echo SSH Key generated.
echo Public key:
cat ~/.ssh/id_rsa/
echo Add the public key to your GitHub account.
echo URL: 
echo https://github.com/settings/ssh/new
