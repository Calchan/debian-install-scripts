#! /bin/bash

set -e

echo "DSELECT::Clean \"always\";" > /etc/apt/apt.conf.d/99autoclean

dhclient
apt install -y \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    firmware-linux \
    ntfs-3g exfat-utils \
    git \
    gnupg \
    lsb-release \
    man \
    powerline powerline-gitstatus \
    python-is-python3 \
    sudo \
    tmux \
    vim-addon-manager vim-nox \
    wget

gpasswd -a $(sed -n 's/^\([^:]*\):x:1000:.*/\1/p' /etc/passwd) sudo
sed 's/^root:[^:]*:/root:*:/' -i /etc/shadow
sed 's/# set bell-style/set bell-style/' -i /etc/inputrc
vim-addons -w install powerline

cd configs/base/root
for file in $(find * -type f); do
    mkdir -p "$(dirname "/${file}")"
    cp -f "${file}" "/${file}"
    chmod 644 "/${file}"
done

cd ../user
for userdir in /root /home/*; do
    cp -f /etc/skel/.{bash_logout,bashrc,profile} "${userdir}"
    mkdir -p "${userdir}/.ssh"
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
chmod -R g-w /root
chmod -R o-rwx /root

sed -i 's/\(linux_entry.*\)simple/\1advanced/' /etc/grub.d/10_linux
update-grub
update-initramfs -k all -u
