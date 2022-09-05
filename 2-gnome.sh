#! /bin/bash

set -e

apt install -y \
    gnome-shell \
    gnome-tweaks \
    gnome-shell-extensions \
    nautilus \
    libspa-0.2-bluetooth \
    totem gstreamer1.0-vaapi \
    eog \
    gnome-screenshot \
    gnome-calculator \
    file-roller unrar unzip \
    nautilus-extension-gnome-terminal \
    libopenblas-base
apt purge -y ibus ifupdown yelp termit xterm
apt autoremove -y

rm -f /etc/network/interfaces
cd configs/gnome
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
