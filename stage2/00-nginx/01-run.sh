#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/sites-available/automatica-app"
install -v -m 644 files/proxy.conf		"${ROOTFS_DIR}/etc/nginx/proxy.conf"

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/automatica-app"

pwd=$(pwd)
cd "${ROOTFS_DIR}/etc/nginx/sites-enabled"
ln -s "../sites-available/automatica-app" .
cd $pwd


echo create certificate

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout files/automatica.key -out files/automatica.crt -config files/localhost.conf
install -v -m 644 files/automatica.crt "${ROOTFS_DIR}/etc/ssl/certs/automatica.crt"
install -v -m 644 files/automatica.key "${ROOTFS_DIR}/etc/ssl/certs/automatica.key"