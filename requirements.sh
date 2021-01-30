#
###########################################
#
# Copyright (C) 2020 FlameGApps Project
#
# This file is part of the FlameGApps Project created by ayandebnath
#
# The FlameGApps scripts are free software, you can redistribute and/or modify them.
#
# These scripts are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY.
#
###########################################
#

INSTALLED='installed_tools.txt'

apt list --installed > $INSTALLED 2>/dev/null

REQUIRED="git git-lfs zip unzip tar xz-utils"

echo -e "\n${YELLOW}Checking installed tools $NC"

for f in $REQUIRED; do
  if ! grep -w "$f/*" $INSTALLED; then
    echo -e "\n${YELLOW}$f is not installed. The script is going to install all required tools. Make sure you are connected to the internet $NC \nPress Ctrl + C to cancel"
    exec bash $home/setup.sh
  fi
done
