#!/bin/bash

if [ -z "$INSTALL_NATIVE" ]
then
    exit 0
fi


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
