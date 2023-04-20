#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

pacman-key --import ./


echo "Keys have been successfully imported"

pacman -Syyu
