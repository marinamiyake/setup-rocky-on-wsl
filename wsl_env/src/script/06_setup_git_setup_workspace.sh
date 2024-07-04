#!/bin/bash

# Show current directory (start directory=~(changed after .bashrc file was loaded), user=created user(specified by /etc/wsl.conf))
echo --------------------
echo current user: 
$user
echo current directory: 
pwd
echo --------------------

# Create workspace
mkdir -p ~/ws/ws1

# Clone Ansible setup repository
cd ~/ws/ws1
echo Type yes to continue:
git clone git@github.com:marinamiyake/setup-localenv.git
