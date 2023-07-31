#!/bin/bash -e

INSTALL_DOCKER=${INSTALL_DOCKER:-0}

echo "Install docker = $INSTALL_DOCKER"


rm -f /etc/systemd/system/multi-user.target.wants/docker.service
rm -f /etc/systemd/system/multi-user.target.wants/mariadb.service
rm -f /etc/systemd/system/multi-user.target.wants/supervisor.service

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore installing automatica docker"
    exit 0
fi

ln -s /lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service
ln -s /lib/systemd/system/mariadb.service /etc/systemd/system/multi-user.target.wants/mariadb.service
ln -s /lib/systemd/system/supervisor.service /etc/systemd/system/multi-user.target.wants/supervisor.service
