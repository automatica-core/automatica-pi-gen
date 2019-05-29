#!/bin/bash -e


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

install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/sites-available/automatica-app"
rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/automatica-app"

pwd=$(pwd)
cd "${ROOTFS_DIR}/etc/nginx/sites-enabled"
ln -s "../sites-available/automatica-app" .
cd $pwd


install -v -d"${ROOTFS_DIR}/var/lib/automatica"
install -v -d"${ROOTFS_DIR}/var/log/automatica"

install -v -d"${ROOTFS_DIR}/var/lib/slave"
install -v -d"${ROOTFS_DIR}/var/log/slave"

install -v -d"${ROOTFS_DIR}/var/lib/supervisor"
install -v -d"${ROOTFS_DIR}/var/log/supervisor"

if [ -z "$INSTALL_SLAVE" ]
then
    echo "installing master system config"
    install -v -m 644 files/supervisor-master.config "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
else
    echo "installing slave system config"
    install -v -m 644 files/supervisor-slave.config "${ROOTFS_DIR}/var/lib/supervisor/appsettings.json"
fi

