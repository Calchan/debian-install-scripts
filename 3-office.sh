#! /bin/bash

set -e

dhclient
apt install -y \
    libreoffice libreoffice-lightproof-en libreoffice-style-elementary \
    gimp gimp-data-extras
apt purge -y ibus xterm yelp
