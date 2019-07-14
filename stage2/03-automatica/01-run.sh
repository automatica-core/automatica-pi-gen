#!/bin/bash -e

INSTALL_NATIVE=${INSTALL_NATIVE:-0}

if [ "${INSTALL_NATIVE}" != "1" ];
then
    echo "ignore installing automatica native"
    exit 0
fi

install -v -d	"${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d"
install -v -m 644 files/service-automatica-config "${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d/automatica.core.service"
dos2unix ${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d/automatica.core.service

install -v -m 644 files/10-usb.rules "${ROOTFS_DIR}/etc/udev/rules.d/10-usb.rules"

pwd=$(pwd)
cd ${ROOTFS_DIR}/etc/systemd/system/
rm -f automatica.core.service
rm -f ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/automatica.core.service
ln -s automatica.core.service.d/automatica.core.service automatica.core.service
ln -s automatica.core.service.d/automatica.core.service ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/automatica.core.service

cd $pwd

rm -rf ${ROOTFS_DIR}/opt/automatica
cp -avr files/automatica ${ROOTFS_DIR}/opt/automatica
cp -avr files/automatica.boot ${ROOTFS_DIR}/opt/automatica.boot

chmod 755 ${ROOTFS_DIR}/opt/automatica/Automatica.Core
chmod 755 ${ROOTFS_DIR}/opt/automatica/Automatica.Core.Watchdog
chmod 755 ${ROOTFS_DIR}/opt/automatica.boot/Automatica.Core.Bootloader


mkdir -p "${ROOTFS_DIR}/opt/automatica/config"
#install automatica config file
install -v -m 644 files/automatica.config "${ROOTFS_DIR}/opt/automatica/config/appsettings.json"

install -v -m 644 files/database/automatica.core.init.db ${ROOTFS_DIR}/opt/automatica/automatica.core.init.db

cd $pwd
