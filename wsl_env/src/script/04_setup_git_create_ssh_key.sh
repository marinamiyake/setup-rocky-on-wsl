#!/bin/bash

# Install git
sudo yum install git

# Create SSH key
ssh-keygen -p "" -f ~/.ssh
echo SSH Key generated.
echo Public key:
cat ~/.ssh/id_rsa/
echo Add the public key to your GitHub account.
echo URL: 
echo https://github.com/settings/ssh/new
