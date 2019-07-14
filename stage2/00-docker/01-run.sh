#!/bin/bash

printenv
INSTALL_DOCKER=${INSTALL_DOCKER:-0}

echo "Install as docker app = $INSTALL_DOCKER"

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore install docker..."
    exit 0
fi

on_chroot << EOF
# Get the Docker signing key for packages
echo "installing docker deb key"
curl --insecure https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

echo "adding docker deb to packages"
# Add the Docker official repos
echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     stretch stable" | \
    tee /etc/apt/sources.list.d/docker.list

apt-get update

apt-get -y install docker-ce --no-install-recommends

usermod -aG docker automatica
EOF
