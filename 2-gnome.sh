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
    nautilus-extension-gnome-terminal

cd configs/gnome
for file in $(find * -type f,l); do
    mkdir -p "$(dirname "/${file}")"
    cp -df "${file}" "/${file}"
    chmod 644 "/${file}" || true
done
