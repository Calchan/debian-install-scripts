#! /bin/bash

set -e

# If Japanese input was required, we installed fcitx5 before. Any other than mozc is suboptimal and
# ibus+mozc is a bad combination
# ifupdown is no longer needed with NetworkManager installed
# termit and xterm are useless, we'll install xfce4-terminal below and it's much better
apt purge -y ibus ifupdown yelp termit tilix xterm zutty
apt autoremove -y
apt purge -y $(dpkg -l | sed -n 's/^rc *\([^ ]*\).*/\1/p')

# Remove the networking setup from the initial install since it may conflict with NetworkManager
rm -f /etc/network/interfaces

cd /etc/skel
set +e
for userdir in /home/*; do
    for file in $(find . -type f,l); do
        mkdir -p "$(dirname "${userdir}/${file}")"
        cp -df "${file}" "${userdir}/${file}"
        chmod 640 "${userdir}/${file}"
    done
    find "${userdir}" -type d -exec chmod 0750 \{\} \;
    find "${userdir}" -type f -exec chmod 0640 \{\} \;
    chmod -R go-rwx "${userdir}/.ssh"
    username=$(basename "${userdir}")
    chown -R "${username}":"${username}" "${userdir}"
done
chmod a+rx /usr/local/bin/*
