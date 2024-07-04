#!/bin/bash

# Show current directory (start directory=~(changed after .bashrc file was loaded), user=created user(specified by /etc/wsl.conf))
echo --------------------
echo current user: 
echo $user
echo current directory: 
pwd
echo --------------------

# Add proxy to user config file. Modify if you use proxy.
cat <<EOF >> ~/.bashrc

# export HTTP_PROXY="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"
# export HTTPS_PROXY="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"
# export NO_PROXY="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"
# export http_proxy="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"
# export https_proxy="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"
# export no_proxy="{[CHANGEME]your proxy(e.g. http://proxy.example.com:8080/)}"

EOF

# Show modified file
echo ~/.bashrc modified:
echo ----------
cat ~/.bashrc
echo ----------
