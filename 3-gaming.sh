#! /bin/bash

set -e

dpkg --add-architecture i386
apt update
apt upgrade -y

apt install -y mangohud:amd64 mangohud:i386 steam

cd configs/gaming
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
chmod +x /usr/local/bin/*

/usr/local/bin/update-heroic

#cd /tmp
#wget -qO - https://dl.xanmod.org/gpg.key | apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
#echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list
#apt update
#apt install -y linux-xanmod
