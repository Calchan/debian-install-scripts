#! /bin/bash

set -e

dhclient
apt install -y -t experimental \
    $(apt list --installed '*drm*' '*mesa*' '*va-driver*' '*vdpau*' '*vulkan*' '*firmware*' \
    '*mesa*' 2>/dev/null | cut -d '/' -f 1 | grep -v '^Listing...$')
