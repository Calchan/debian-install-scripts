#! /bin/bash

set -e

apt install -y \
    gnome-shell \
    gnome-shell-extensions \
    nautilus \
    totem gstreamer1.0-vaapi \
    eog \
    gnome-screenshot \
    gnome-calculator \
    file-roller unrar unzip
apt purge -y ibus yelp
apt autoremove -y
apt install -y xfce4-terminal

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
