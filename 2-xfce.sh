#! /bin/bash

set -e

apt install -y \
    xfce4 \
    elementary-xfce-icon-theme \
    xfce4-whiskermenu-plugin \
    xfce4-notifyd \
    xfce4-power-manager \
    network-manager-gnome \
    blueman libspa-0.2-bluetooth \
    xfce4-screenshooter \
    tumbler-plugins-extra \
    gvfs-backends gvfs-fuse \
    thunar-archive-plugin unzip unrar \
    ristretto \
    mpv libopenblas-base \
    seahorse \
    mousepad \
    galculator

# Install separately so as to not provide a dumb X session
apt install -y xfce4-terminal

cd configs/xfce
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
