#!/bin/bash

# Add proxy setting to yum config file. Modify if you use proxy.
cat <<EOF >> /etc/yum.conf

# proxy={[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}

EOF

# Show modified file
echo /etc/yum.conf modified
cat /etc/yum.conf

# Update package
yum -y update
