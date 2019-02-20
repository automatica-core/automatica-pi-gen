FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install \
        git vim parted \
        quilt realpath qemu-user-static debootstrap zerofree pxz zip dosfstools \
<<<<<<< HEAD
        bsdtar libcap2-bin rsync grep udev xz-utils curl xxd file \
=======
        bsdtar libcap2-bin rsync grep udev xz-utils curl xxd file kmod\
>>>>>>> upstream/master
    && rm -rf /var/lib/apt/lists/*

COPY . /pi-gen/

VOLUME [ "/pi-gen/work", "/pi-gen/deploy"]
