#! /bin/bash

set -e

dhclient
apt install -y \
    plasma-workspace-wayland \
    sddm \
    dolphin \
    plasma-nm \
    konsole \
    libspa-0.2-bluetooth \
    libopenblas-base
apt purge -y ibus kdeconnect plasma-discover khelpcenter kinfocenter partitionmanager
apt autoremove -y

rm -f /etc/network/interfaces
cd configs/gnome
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done

cd /tmp
dhclient
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dhclient
apt install -y ./google-chrome-stable_current_amd64.deb
