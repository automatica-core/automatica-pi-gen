#!/bin/bash -e


INSTALL_NATIVE=${INSTALL_NATIVE:-0}
INSTALL_DOCKER=${INSTALL_DOCKER:-0}

if [ "$INSTALL_NATIVE" != "1" ] && [ "$INSTALL_DOCKER" != "1" ]
then
    echo "no built type set"
    exit -1
fi

echo copy libnsererial
mkdir -p "${ROOTFS_DIR}/usr/local/lib/"
install -v -m 644 files/libnserial.so.1.1 "${ROOTFS_DIR}/usr/local/lib/libnserial.so.1.1"

pwd=$(pwd)
cd ${ROOTFS_DIR}/usr/local/lib

rm -f libnserial.so.1
rm -f libnserial.so
ln -s libnserial.so.1.1 libnserial.so.1 2>/dev/null
ln -s libnserial.so.1.1 libnserial.so 2>/dev/null

echo install frpc
curl -L -o frp.tgz https://github.com/fatedier/frp/releases/download/v0.51.2/frp_0.51.2_linux_arm.tar.gz
tar xvzf frp.tgz
install -v -m 755 frp_*/frpc "${ROOTFS_DIR}/usr/local/bin/frpc"

cd $pwd
