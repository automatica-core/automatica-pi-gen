#!/bin/bash -e

INSTALL_DOCKER=${INSTALL_DOCKER:-0}
IMAGE_TAG=${IMAGE_TAG:-"latest-develop"}
env=${USE_ENV:-"dev"}

echo "Install docker = $INSTALL_DOCKER"

if [ "$INSTALL_DOCKER" != "1" ]; 
then
    echo "ignore installing automatica docker"
    
    rm -f "${ROOTFS_DIR}/lib/systemd/system/supervisor.service"
    rm -f "${ROOTFS_DIR}/lib/systemd/system/mariadb.service"
    exit 0
fi

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

rm -f files/service-supervisor-config-out
IMAGE_TAG=$IMAGE_TAG envsubst < "files/service-supervisor-config" > "files/service-supervisor-config-out"
    
install -v -m 644 files/service-supervisor-config-out "${ROOTFS_DIR}/lib/systemd/system/supervisor.service"
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

echo "Using env: ${env}"
echo "Using IMAGE_TAG: ${IMAGE_TAG}"

if [ "$INSTALL_DOCKER_SLAVE" == "0" ]
then
    echo "installing master system config"
    install -v -d "${ROOTFS_DIR}/var/log/automatica"
    
    install -v -d "${ROOTFS_DIR}/var/lib/automatica"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/config"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins/drivers"
    install -v -d "${ROOTFS_DIR}/var/lib/automatica/plugins/logics"

    rm -f files/supervisor-master-out.json
    rm -f files/automatica-out.json
    IMAGE_TAG=$IMAGE_TAG envsubst < "files/supervisor-master-${env}.json" > "files/supervisor-master-out.json"
    IMAGE_TAG=$IMAGE_TAG envsubst < "files/automatica-${env}.json" > "files/automatica-out.json"

    install -v -m 644 files/supervisor-master-out.json "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
    install -v -m 644 files/automatica-out.json "${ROOTFS_DIR}/var/lib/automatica/config/appsettings.json"


else
    echo "installing slave system config"
    install -v -d "${ROOTFS_DIR}/var/log/slave"

    install -v -d "${ROOTFS_DIR}/var/lib/slave"
    install -v -d "${ROOTFS_DIR}/var/lib/slave/config"


    rm -f files/supervisor-slave-out.json
    rm -f files/automatica-slave-out.json
    IMAGE_TAG=$IMAGE_TAG envsubst < "files/supervisor-slave-${env}.json" > "files/supervisor-slave-out.json"
    IMAGE_TAG=$IMAGE_TAG envsubst < "files/automatica-slave-${env}.json" > "files/automatica-slave-out.json"


    install -v -m 644 files/supervisor-slave-out.json "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
    install -v -m 644 files/automatica-slave-out.json "${ROOTFS_DIR}/var/lib/slave/appsettings.json"

fi