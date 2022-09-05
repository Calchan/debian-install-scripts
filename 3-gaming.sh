#! /bin/bash

set -e

dpkg --add-architecture i386
apt update
apt upgrade -y

apt install -y mangohud:amd64 mangohud:i386 steam

pushd configs/gaming/root > /dev/null
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
chmod +x /usr/local/bin/*
popd > /dev/null

cd configs/gaming/user
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
    gpasswd -a "${username}" games
done

/usr/local/bin/update-heroic

#cd /tmp
#wget -qO - https://dl.xanmod.org/gpg.key | apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
#echo 'deb http://deb.xanmod.org releases main' > /etc/apt/sources.list.d/xanmod-kernel.list
#apt update
#apt install -y linux-xanmod

apt purge -y ibus xterm yelp
apt autoremove -y
