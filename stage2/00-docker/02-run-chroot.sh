#!/bin/bash

INSTALL_DOCKER=${INSTALL_DOCKER:-0}

echo "Install as docker app = $INSTALL_DOCKER"

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore install docker..."
    exit 0
fi

# Get the Docker signing key for packages
apt-get update
apt-get install ca-certificates curl gnupg

rm -f /etc/apt/keyrings/docker.gpg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=armhf signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  bullseye stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null


apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker automatica
