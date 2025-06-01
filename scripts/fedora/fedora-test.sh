#!/usr/bin/env bash

set -e  # Exit on error
set -u  # Treat unset variables as errors
set -o pipefail

# Check if the current desktop environment is GNOME
if [[ "${XDG_CURRENT_DESKTOP:-}" != *"GNOME"* ]]; then
    echo "This script is intended for GNOME environments only. Detected: ${XDG_CURRENT_DESKTOP:-<not set>}"
    exit 1
fi

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../../config"
BLOAT_FILE="$CONFIG_DIR/bloat-fedora"
COMMON_PACKAGES_FILE="$CONFIG_DIR/packages-common"
FEDORA_PACKAGES_FILE="$CONFIG_DIR/packages-fedora"
FEDORA_FLATPAK_FILE="$CONFIG_DIR/packages-fedora-flatpak"

# Update system
echo "#######################"
echo "### UPDATING SYSTEM ###"
echo "#######################"

sudo dnf update -y

# Remove bloat packages
echo "###############################"
echo "### REMOVING BLOAT PACKAGES ###"
echo "###############################"

BLOAT_PACKAGES=$(grep -vE '^\s*#|^\s*$' "$BLOAT_FILE")
if [[ -n "$BLOAT_PACKAGES" ]]; then
    echo "$BLOAT_PACKAGES" | xargs sudo dnf remove -y
fi

# Install Common packages
echo "###############################"
echo "### INSTALL COMMON PACKAGES ###"
echo "###############################"

COMMON_PACKAGES=$(grep -vE '^\s*#|^\s*$' "$COMMON_PACKAGES_FILE")
if [[ -n "$COMMON_PACKAGES" ]]; then
    echo "$COMMON_PACKAGES" | xargs sudo dnf install -y
else
    echo "No common packages found to install."
fi

# Install Fedora packages
echo "###############################"
echo "### INSTALL FEDORA PACKAGES ###"
echo "###############################"

FEDORA_PACKAGES=$(grep -vE '^\s*#|^\s*$' "$FEDORA_PACKAGES_FILE")
if [[ -n "$FEDORA_PACKAGES" ]]; then
    echo "$FEDORA_PACKAGES" | xargs sudo dnf install -y
else
    echo "No Fedora-specific packages found to install."
fi

# Install Fedora Flatpak packages
echo "#######################################"
echo "### INSTALL FEDORA FLATPAK PACKAGES ###"
echo "#######################################"

FLATPAK_APPS=$(grep -vE '^\s*#|^\s*$' "$FEDORA_FLATPAK_FILE")
if [[ -n "$FLATPAK_APPS" ]]; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    while IFS= read -r app_id; do
        echo "Installing Flatpak: $app_id"
        flatpak install -y --noninteractive flathub "$app_id"
    done <<< "$FLATPAK_APPS"
else
    echo "No Flatpak applications found to install."
fi

echo "✅ Fedora TEST setup complete."
