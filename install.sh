#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Set the URL for the keyring file
keyring_url="https://github.com/LycaonIndustries/amadeos/raw/main/pubring.gpg"

# Set the directory to download the keyring file to
download_dir="/tmp"

# Download the keyring file
echo "Downloading keyring file..."
wget -qO "${download_dir}/keyring.gpg" "$keyring_url" || { echo "Error downloading keyring file"; exit 1; }

# Import the keyring file
echo "Importing keyring file..."
pacman-key --add "${download_dir}/keyring.gpg" || { echo "Error importing keyring file"; exit 1; }
pacman-key --lsign-key 3539093044A255EBE90A82F80B6D609FE09A6D03 || { echo "Error importing keyring file"; exit 1; }

# Update pacman keyring
echo "Updating pacman keyring..."
pacman-key --refresh-keys || { echo "Error updating pacman keyring"; exit 1; }

echo "Keyring has been successfully imported and updated"

echo "Updating pacman.conf with new server"

# Backup pacman.conf file
echo "Backing up pacman.conf file..."
cp /etc/pacman.conf /etc/pacman.conf.bkp

# Add the repository to pacman.conf
if ! grep -q "amadeos" /etc/pacman.conf; then
    echo "[amadeos]
    SigLevel = Optional DatabaseOptional
    Server = https://github.com/LycaonIndustries/\$repo/raw/main/\$arch/" >> /etc/pacman.conf
fi

echo "Updated pacman.conf"

# Refresh packages
pacman -Syyu

echo "Updated packages"
