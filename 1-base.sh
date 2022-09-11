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

echo "DSELECT::Clean \"always\";" > /etc/apt/apt.conf.d/99autoclean

apt install -y \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    firmware-linux \
    ntfs-3g exfatprogs f2fs-tools \
    git \
    gnupg \
    lsb-release \
    man \
    powerline powerline-gitstatus \
    python-is-python3 \
    sudo \
    systemd-timesyncd \
    tmux \
    vim-addon-manager vim-nox \
    wget curl
apt install --no-install-recommends anacron

gpasswd -a $(sed -n 's/^\([^:]*\):x:1000:.*/\1/p' /etc/passwd) sudo
sed 's/^root:[^:]*:/root:*:/' -i /etc/shadow
sed 's/# set bell-style/set bell-style/' -i /etc/inputrc
vim-addons -w install powerline

cd configs/base
for file in $(find * -type f,l); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}" || true
done

update-grub
update-initramfs -k all -u
