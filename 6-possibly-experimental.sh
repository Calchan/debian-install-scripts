#! /bin/bash

set -e

apt list -a $(apt list --installed 2>/dev/null | cut -d '/' -f 1 | grep -v '^Listing...$') \
    2>/dev/null | grep '/experimental ' | grep -v 'installed' | cut -d'/' -f 1
