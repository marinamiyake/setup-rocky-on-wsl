#!/bin/bash

# Show current directory (start directory=unset, user=unset)
echo --------------------
echo current user: 
echo $user
echo current directory: 
pwd
echo --------------------

# Add proxy setting to yum config file. Modify if you use proxy.
cat <<EOF >> /etc/yum.conf

# proxy={[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}

EOF

# Show modified file
echo /etc/yum.conf modified:
echo ----------
cat /etc/yum.conf
echo ----------
# Update package
yum -y update
