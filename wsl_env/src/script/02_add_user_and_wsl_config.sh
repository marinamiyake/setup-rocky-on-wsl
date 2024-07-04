#!/bin/bash

# Install essential packages
yum install -y systemd sudo passwd which vim wget glibc-langpack-ja glibc-langpack-en

# Create user
useradd -m $1
echo type password
passwd $1
usermod -aG wheel $1

# Create WSL config file for this Rocky environment
cat <<EOF >> /etc/yum.conf
[boot]
systemd=true

[user]
default=$1

EOF
