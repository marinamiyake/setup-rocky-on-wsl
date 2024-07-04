#!/bin/bash

# Show current directory (start directory=~(changed after .bashrc file was loaded), user=created user(specified by /etc/wsl.conf))
echo --------------------
echo current user: 
echo whoami
echo current directory: 
pwd
echo --------------------

# Create git config
git config --global user.email = $1
git config --global user.name = $2
git config --global pull.rebase false

# Check connection
echo Type yes to continue:
ssh -T git@github.com
