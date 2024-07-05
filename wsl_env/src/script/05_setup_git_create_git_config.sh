#!/bin/bash

# Create git config
git config --global user.email = "$1"
git config --global user.name = "$2"
git config --global pull.rebase false

# Check connection
echo Type yes to continue:
ssh -T git@github.com
