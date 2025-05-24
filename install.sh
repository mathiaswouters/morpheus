#!/bin/bash

set -e

# Detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unsupported system."
    exit 1
fi

echo "Detected distro: $DISTRO"

# Call corresponding installer
case "$DISTRO" in
    debian|ubuntu)
        bash distros/debian.sh
        ;;
    arch)
        bash distros/arch.sh
        ;;
    fedora)
        bash distros/fedora.sh
        ;;
    *)
        echo "Unsupported distro: $DISTRO"
        exit 1
        ;;
esac
