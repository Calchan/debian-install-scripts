#! /bin/bash

set -e

dpkg --add-architecture i386
apt update

apt install -y dxvk ttf-mscorefonts-installer winbind gamemode wine wine-development steam

for userdir in /home/*; do
    mkdir -p "${userdir}/.config/systemd/user/default.target.wants"
    ln -sf /usr/lib/systemd/user/gamemoded.service "${userdir}/.config/systemd/user/default.target.wants/gamemoded.service"
    sed 's/^renice=.*/renice=10/' /usr/share/gamemode/gamemode.ini > "${userdir}/.config/gamemode.ini"
    username=$(basename "${userdir}")
    chown -R "${username}":"${username}" "${userdir}/.config"
    chmod -R o-rwx "${userdir}/.config"
    gpasswd -a "${username}" games
done

cd configs/gaming-prep
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
cd /usr/local/bin
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x *
mkdir -p /etc/systemd/system/graphical.target.wants
ln -sf /etc/systemd/system/gamemode-perms.service /etc/systemd/system/graphical.target.wants/gamemode-perms.service

cd /tmp
/usr/local/bin/update-heroic
echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
apt update
apt install -y linux-xanmod
apt autoremove -y
