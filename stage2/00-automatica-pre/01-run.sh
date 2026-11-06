#!/bin/bash -e


INSTALL_NATIVE=${INSTALL_NATIVE:-0}
INSTALL_DOCKER=${INSTALL_DOCKER:-0}

if [ "$INSTALL_NATIVE" != "1" ] && [ "$INSTALL_DOCKER" != "1" ]
then
    echo "no built type set"
    exit 1
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

cd $pwd

# per-device DB passwords, TLS key and the rotation tool for older devices (see the script header)
install -v -m 755 files/automatica-secrets "${ROOTFS_DIR}/usr/local/sbin/automatica-secrets"

# Only the native install runs frpc from the host. The docker images bring their own.
if [ "$INSTALL_NATIVE" = "1" ]; then
    echo install frpc
    # Bump deliberately: version and the sha256 from that release's frp_sha256_checksums.txt
    FRP_VERSION=0.71.1
    FRP_SHA256=8eb6fe66a3b36db24ca0de44fb01e6742d0ff60e30f462c9662f41813bbf4376
    frp_dir=$(mktemp -d)
    curl -fsSL -o "${frp_dir}/frp.tgz" "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm.tar.gz"
    echo "${FRP_SHA256}  ${frp_dir}/frp.tgz" | sha256sum -c -
    tar -xzf "${frp_dir}/frp.tgz" -C "${frp_dir}"
    install -v -m 755 "${frp_dir}/frp_${FRP_VERSION}_linux_arm/frpc" "${ROOTFS_DIR}/usr/local/bin/frpc"
    rm -rf "${frp_dir}"
else
    rm -f "${ROOTFS_DIR}/usr/local/bin/frpc"
fi
