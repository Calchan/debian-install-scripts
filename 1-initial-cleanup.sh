#! /bin/bash

set -e

echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ testing-security main contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian testing-updates main contrib non-free" >> /etc/apt/sources.list
apt update

apt-mark auto $(apt list --manual-installed 2>/dev/null | tail -n +2 | cut -d '/' -f 1)
apt-mark manual ifupdown
apt autoremove -y

apt install -y --reinstall $(apt list --upgradable 2>/dev/null | tail -n +2 | cut -d '/' -f 1)
apt autoremove -y
