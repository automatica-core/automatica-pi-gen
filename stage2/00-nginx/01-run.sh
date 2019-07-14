#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/default"

install -v -m 644 files/nginx-automatica-config		"${ROOTFS_DIR}/etc/nginx/sites-available/automatica-app"
rm -f "${ROOTFS_DIR}/etc/nginx/sites-enabled/automatica-app"

pwd=$(pwd)
cd "${ROOTFS_DIR}/etc/nginx/sites-enabled"
ln -s "../sites-available/automatica-app" .
cd $pwd
