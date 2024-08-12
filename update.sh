#!/bin/bash

cd x86_64

# Find and delete files with "debug" in the name
find . -type f -name '*debug*' -exec rm -f {} \;

# Update repos in DB.
repo-add amadeos-sync.db.tar.gz ./*.tar.zst 

# Remove symlinks
rm amadeos-sync.db amadeos-sync.files

# Move actual files to correct names
mv amadeos-sync.files.tar.gz amadeos-sync.files
mv amadeos-sync.db.tar.gz amadeos-sync.db

# Move back to src dir
cd .. 

# Update repos on github
git add .
git commit -m "Automated - Updated Repos"
git push

# Update system
sudo pacman -Syyu
