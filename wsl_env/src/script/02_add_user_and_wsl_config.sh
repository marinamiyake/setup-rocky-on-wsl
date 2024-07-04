#!/bin/bash

# Show current directory (start directory=unset, user=unset)
echo --------------------
echo current user: 
echo whoami
echo current directory: 
pwd
echo --------------------

# Install essential packages
yum install -y systemd sudo passwd which vim wget glibc-langpack-ja glibc-langpack-en

# Create user
useradd -m $1
echo type password
passwd $1
usermod -aG wheel $1

# Create WSL config file for this Rocky environment
cat <<EOF > /etc/wsl.conf
[boot]
systemd=true

[user]
default=$1

EOF

# Show created file
echo /etc/wsl.conf created:
echo ----------
cat /etc/wsl.conf
echo ----------

# Add host(Windows) path to mount.
cat <<EOF >> /home/$1/.bashrc

# Move to user's home directory when Rocky init process finishes.
cd ~

# Mount Host (Windows machine)
export PATH=\$PATH:/mnt/c/WINDOWS/

EOF

# Show modified file
echo /home/$1/.bashrc modified:
echo ----------
cat /home/$1/.bashrc
echo ----------
