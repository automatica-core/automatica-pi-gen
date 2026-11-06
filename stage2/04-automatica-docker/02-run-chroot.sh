#!/bin/bash -e

INSTALL_DOCKER=${INSTALL_DOCKER:-0}

echo "Install docker = $INSTALL_DOCKER"


rm -f /etc/systemd/system/multi-user.target.wants/docker.service
rm -f /etc/systemd/system/multi-user.target.wants/mariadb.service
rm -f /etc/systemd/system/multi-user.target.wants/supervisor.service
rm -f /etc/systemd/system/multi-user.target.wants/timescaledb.service
rm -f /etc/systemd/system/multi-user.target.wants/automatica-secrets.service

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore installing automatica docker"
    exit 0
fi

ln -s /lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service
ln -s /lib/systemd/system/automatica-secrets.service /etc/systemd/system/multi-user.target.wants/automatica-secrets.service
ln -s /lib/systemd/system/mariadb.service /etc/systemd/system/multi-user.target.wants/mariadb.service
ln -s /lib/systemd/system/supervisor.service /etc/systemd/system/multi-user.target.wants/supervisor.service

if [ "$INSTALL_DOCKER_SATELLITE" == "0" ]
then
    echo "installing timescaledb"
    ln -s /lib/systemd/system/timescaledb.service /etc/systemd/system/multi-user.target.wants/timescaledb.service
fi

# The first-boot user wizard (userconfig.service) stays enabled: the image ships without a
# password, the user picks name and password on first boot or via userconf.txt (Raspberry Pi Imager).
