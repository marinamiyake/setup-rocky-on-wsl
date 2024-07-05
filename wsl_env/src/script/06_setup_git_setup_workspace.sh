#!/bin/bash

# Create workspace
mkdir -p ~/ws/ws1

# Clone Ansible setup repository
cd ~/ws/ws1
echo Type yes to continue:
git clone git@github.com:marinamiyake/setup-localenv.git
