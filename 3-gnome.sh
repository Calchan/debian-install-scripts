#! /bin/bash

set -e

dhclient
apt install -y \
    gnome-shell \
    gnome-tweaks \
    gnome-shell-extensions \
    nautilus \
    pipewire-pulse pipewire-audio-client-libraries libspa-0.2-bluetooth gstreamer1.0-pipewire \
    totem gstreamer1.0-vaapi \
    eog \
    gnome-screenshot \
    gnome-calculator \
    file-roller unrar unzip \
    tilix \
    libopenblas-base
apt purge -y ibus yelp termit xterm
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
