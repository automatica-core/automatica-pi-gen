#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/nginx.conf"
install -v -m 644 files/proxy.conf		"${ROOTFS_DIR}/etc/nginx/proxy.conf"

echo create certificate
openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 \
    -subj "/C=AT/ST=Upper Austria/L=Wels/O=p3-software/CN=automatica.core" \
    -keyout files/automatica.key  -out files/automatica.crt
    
install -v -m 644 files/automatica.crt "${ROOTFS_DIR}/etc/ssl/certs/automatica.crt"
install -v -m 644 files/automatica.key "${ROOTFS_DIR}/etc/ssl/certs/automatica.key"


