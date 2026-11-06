#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/nginx.conf"
install -v -m 644 files/proxy.conf		"${ROOTFS_DIR}/etc/nginx/proxy.conf"

# The TLS key is created on the device at first boot (automatica-secrets tls), never at build
# time: a key baked into the image would be the same on every device.
rm -f "${ROOTFS_DIR}/etc/ssl/certs/automatica.key" "${ROOTFS_DIR}/etc/ssl/certs/automatica.crt"
install -v -m 644 files/automatica-tls.service "${ROOTFS_DIR}/lib/systemd/system/automatica-tls.service"

on_chroot << EOF2
systemctl enable automatica-tls.service
EOF2
