#! /bin/bash

set -e

apt install -y \
    libreoffice libreoffice-lightproof-en libreoffice-style-elementary \
    gimp gimp-data-extras
apt purge -y xterm
