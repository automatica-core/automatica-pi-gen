#!/bin/bash -e

INSTALL_DOCKER=${INSTALL_DOCKER:-0}

echo "Install docker = $INSTALL_DOCKER"

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore installing automatica docker"
    exit 0
fi

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

install -v -m 644 files/service-supervisor-config "${ROOTFS_DIR}/lib/systemd/system/supervisor.service"
install -v -m 644 files/service-mariadb-config "${ROOTFS_DIR}/lib/systemd/system/mariadb.service"
dos2unix ${ROOTFS_DIR}/lib/systemd/system/supervisor.service
dos2unix ${ROOTFS_DIR}/lib/systemd/system/mariadb.service

# install -v -m 644 files/10-usb.rules "${ROOTFS_DIR}/etc/udev/rules.d/10-usb.rules"

pwd=$(pwd)
cd ${ROOTFS_DIR}/etc/systemd/system/
rm -f supervisor.service
rm -f ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/docker.service
rm -f ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/mariadb.service
rm -f ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/supervisor.service

cd $pwd

install -v -d "${ROOTFS_DIR}/var/lib/supervisor"
install -v -d "${ROOTFS_DIR}/var/log/supervisor"

INSTALL_DOCKER_SLAVE=${INSTALL_DOCKER_SLAVE:-0}

if [ "$INSTALL_DOCKER_SLAVE" == "0" ]
then
    echo "installing master system config"
    install -v -d "${ROOTFS_DIR}/var/log/automatica"
    
    install -v -d "${ROOTFS_DIR}/var/lib/automatica"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/config"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins/drivers"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins/logics"

    install -v -m 644 files/supervisor-master.config "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
    install -v -m 644 files/automatica.config "${ROOTFS_DIR}/var/lib/automatica/config/appsettings.json"

else
    echo "installing slave system config"
    install -v -d "${ROOTFS_DIR}/var/log/slave"

    install -v -d "${ROOTFS_DIR}/var/lib/slave"
    install -v -d "${ROOTFS_DIR}/var/lib/slave/config"

    install -v -m 644 files/supervisor-slave.config "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
    install -v -m 644 files/automatica-slave.config "${ROOTFS_DIR}/var/lib/slave/appsettings.json"
fi