#! /bin/bash

set -e

echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ testing-security main contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian testing-updates main contrib non-free" >> /etc/apt/sources.list
apt update

apt purge -y installation-report nano vim-tiny vim-common
apt full-upgrade -y
apt autoremove -y

if [[ -n "$(apt autoremove -s 2>/dev/null | grep '^Remv ')" ]]; then
	echo "Please run 'apt autoremove' or apt-mark necessary packages first"
	exit 1
fi

manual_packages=$(apt list --manual-installed 2>/dev/null | cut -d '/' -f 1)
echo ${manual_packages} > /tmp/apt-manual-packages
for package in ${manual_packages}; do
	apt-mark auto "${package}" > /dev/null
	if [[ -z "$(apt autoremove -s 2>/dev/null | grep '^Remv ')" ]]; then
		echo "${package}"
	else
		apt-mark manual "${package}" > /dev/null
	fi
done

echo
echo "If the next step asks if it's OK to remove some packages then answer no, use 'apt-mark' to"
echo "mark whichever you want to keep as manually installed, then run 'apt-autoremove' again."
echo "If multiple packages are listed then it's likely that one is the top of a dependency hierarchy,"
echo "so try to identify which one it is with 'apt show' and 'apt rdepends', then marking this one"
echo "manual should be enough."
echo

apt autoremove
