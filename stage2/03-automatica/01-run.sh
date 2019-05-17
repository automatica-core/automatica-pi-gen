#!/bin/bash -e




# rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

# install -v -d	"${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d"
# install -v -m 644 files/service-automatica-config "${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d/automatica.core.service"
# dos2unix ${ROOTFS_DIR}/etc/systemd/system/automatica.core.service.d/automatica.core.service

# install -v -m 644 files/10-usb.rules "${ROOTFS_DIR}/etc/udev/rules.d/10-usb.rules"

# pwd=$(pwd)
# cd ${ROOTFS_DIR}/etc/systemd/system/
# rm -f automatica.core.service
# rm -f ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/automatica.core.service
# ln -s automatica.core.service.d/automatica.core.service automatica.core.service
# ln -s automatica.core.service.d/automatica.core.service ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/automatica.core.service

# cd $pwd

# install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/sites-available/automatica-app"
# rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/automatica-app"

# pwd=$(pwd)
# cd "${ROOTFS_DIR}/etc/nginx/sites-enabled"
# ln -s "../sites-available/automatica-app" .
# cd $pwd

# rm -rf ${ROOTFS_DIR}/opt/automatica
# cp -avr files/automatica ${ROOTFS_DIR}/opt/automatica
# cp -avr files/automatica.boot ${ROOTFS_DIR}/opt/automatica.boot

# chmod 755 ${ROOTFS_DIR}/opt/automatica/Automatica.Core
# chmod 755 ${ROOTFS_DIR}/opt/automatica/Automatica.Core.Watchdog
# chmod 755 ${ROOTFS_DIR}/opt/automatica.boot/Automatica.Core.Bootloader

# install -v -m 644 files/database/automatica.core.init.db ${ROOTFS_DIR}/opt/automatica/automatica.core.init.db

# install -v -m 644 files/libnserial.so.1.1		"${ROOTFS_DIR}/usr/local/lib/libnserial.so.1.1"


# echo copy libnsererial
# pwd=$(pwd)
# cd ${ROOTFS_DIR}/usr/local/lib

# rm -f libnserial.so.1
# rm -f libnserial.so
# ln -s libnserial.so.1.1 libnserial.so.1 2>/dev/null
# ln -s libnserial.so.1.1 libnserial.so 2>/dev/null

# cd $pwd
