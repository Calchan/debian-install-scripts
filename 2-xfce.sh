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
# If Japanese input is required we'll install fcitx5 later
# Any other than mozc is suboptimal and ibus+mozc is a bad combination
# termit and xterm are useless, we'll install xfce4-terminal below and it's much better
apt purge -y ibus ifupdown termit xterm

apt autoremove -y

# Install separately so as to not provide a dumb X session
apt install -y xfce4-terminal

# Remove the networking setup from the initial install since it may conflict with NetworkManager
rm -f /etc/network/interfaces

pushd configs/xfce/root > /dev/null
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
popd > /dev/null

cd configs/xfce/user
for userdir in /home/*; do
    for file in $(find . -type f); do
        mkdir -p "$(dirname "${userdir}/${file}")"
        cp -f "${file}" "${userdir}/${file}"
        chmod 644 "${userdir}/${file}"
    done
    find "${userdir}" -type d -exec chmod 0755 \{\} \;
    find "${userdir}" -type f -exec chmod 0644 \{\} \;
    chmod -R go-rwx "${userdir}/.ssh"
    username=$(basename "${userdir}")
    chown -R "${username}":"${username}" "${userdir}"
done

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
