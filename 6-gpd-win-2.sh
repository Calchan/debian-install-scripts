#! /bin/bash

set -e

dhclient
apt install -y xboxdrv

pushd configs/gpd-win-2/root > /dev/null
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done
chmod +x /usr/local/bin/*
mkdir -p /etc/systemd/system/graphical.target.wants
ln -sf /etc/systemd/system/add-xpad-id.service /etc/systemd/system/graphical.target.wants/add-xpad-id.service
popd > /dev/null

cd configs/gpd-win-2/user
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
