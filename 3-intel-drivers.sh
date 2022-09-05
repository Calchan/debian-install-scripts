#! /bin/bash

set -e

apt install -y i965-va-driver-shaders intel-media-va-driver-non-free firmware-iwlwifi

echo i915 >> /etc/initramfs-tools/modules
update-initramfs -k all -u
