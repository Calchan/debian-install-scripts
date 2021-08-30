#! /bin/bash

set -e

manual_packages=$(apt list --manual-installed 2>/dev/null | grep -v i386 | cut -d '/' -f 1)
echo ${manual_packages} > /tmp/apt-manual-packages
for package in ${manual_packages}; do
	apt-mark auto "${package}" > /dev/null
	if [[ -z "$(apt autoremove -s 2>/dev/null | grep '^Remv ')" ]]; then
		echo "${package}"
	else
		apt-mark manual "${package}" > /dev/null
	fi
done

apt autoremove
