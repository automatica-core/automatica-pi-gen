#!/bin/bash -e
install -v -m 644 files/libnserial.so.1.1		"${ROOTFS_DIR}/usr/local/lib/libnserial.so.1.1"

echo copy libnsererial
pwd=$(pwd)
cd ${ROOTFS_DIR}/usr/local/lib

rm -f libnserial.so.1
rm -f libnserial.so
ln -s libnserial.so.1.1 libnserial.so.1 2>/dev/null
ln -s libnserial.so.1.1 libnserial.so 2>/dev/null

cd $pwd
