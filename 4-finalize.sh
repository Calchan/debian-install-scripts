#! /bin/bash

set -e

# Remove the networking setup from the initial install since it may conflict with NetworkManager
rm -f /etc/network/interfaces

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# If Japanese input is required we'll install fcitx5 later
# Any other than mozc is suboptimal and ibus+mozc is a bad combination
# ifupdown is no longer needed with NetworkManager installed
# termit and xterm are useless, we'll install xfce4-terminal below and it's much better
apt purge -y ibus ifupdown yelp termit xterm
apt autoremove -y
