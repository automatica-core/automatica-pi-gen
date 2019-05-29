#!/bin/bash
ldconfig

usermod -aG docker automatica


ln -s /lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service
ln -s /lib/systemd/system/mariadb.service /etc/systemd/system/multi-user.target.wants/mariadb.service
ln -s /lib/systemd/system/automatica.service /etc/systemd/system/multi-user.target.wants/automatica.service
