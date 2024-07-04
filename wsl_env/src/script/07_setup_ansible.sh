#!/bin/bash

# Install required packages for Ansible
sudo yum -y install python3 epel-release
curl $1 -o get-pip.py
python3 get-pip.py --user

# Install Ansible
python3 -m pip install --user ansible==4.10.0
