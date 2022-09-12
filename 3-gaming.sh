#! /bin/bash

set -e

dpkg --add-architecture i386
apt update
apt upgrade -y

apt install -y mangohud:amd64 mangohud:i386 steam

cd configs/gaming
for file in $(find * -type f,l); do
    mkdir -p "$(dirname "/${file}")"
    cp -df "${file}" "/${file}"
    chmod 644 "/${file}" || true
done

for userdir in /home/*; do
    username=$(basename "${userdir}")
    gpasswd -a "${username}" games
done

chmod +x /usr/local/bin/*
/usr/local/bin/update-heroic

sed 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 mitigations=off i915.mitigations=off"/' -i \
    /etc/default/grub.d/local.cfg
update-grub

#cd /tmp
#wget -qO - https://dl.xanmod.org/gpg.key | apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
#echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list
#apt update
#apt install -y linux-xanmod
