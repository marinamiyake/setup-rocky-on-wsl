#!/bin/bash

echo ----------
cat pwd
echo ----------

echo ----------
cat sudo -S $1 /etc/wsl.conf
echo ----------

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
