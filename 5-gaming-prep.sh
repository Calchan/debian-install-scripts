#! /bin/bash

set -e

dpkg --add-architecture i386
apt update

apt install -y dxvk ttf-mscorefonts-installer winbind gamemode mangohud wine wine-development steam\
    gstreamer1.0-gl gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-gl:i386 gstreamer1.0-libav:i386 gstreamer1.0-plugins-bad:i386 gstreamer1.0-plugins-ugly:i386
apt purge -y xterm

for userdir in /home/*; do
    mkdir -p "${userdir}/.config/systemd/user/default.target.wants"
    ln -sf /usr/lib/systemd/user/gamemoded.service "${userdir}/.config/systemd/user/default.target.wants/gamemoded.service"
    sed 's/^renice=.*/renice=10/' /usr/share/gamemode/gamemode.ini > "${userdir}/.config/gamemode.ini"
    username=$(basename "${userdir}")
    chown -R "${username}":"${username}" "${userdir}/.config"
    chmod -R o-rwx "${userdir}/.config"
    gpasswd -a "${username}" games
done

pushd configs/gaming-prep/root > /dev/null
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
cd /usr/local/bin
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x *
mkdir -p /etc/systemd/system/graphical.target.wants
ln -sf /etc/systemd/system/intel-rapl-perms.service /etc/systemd/system/graphical.target.wants/intel-rapl-perms.service
popd > /dev/null

cd configs/gaming-prep/user
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
/usr/local/bin/update-heroic
echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
apt update
apt install -y linux-xanmod
apt autoremove -y
