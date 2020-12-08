#!/bin/bash
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

if [ "$OSTYPE" = "linux-android" ]; then
  # Install required packages for Termux
  echo -e "\n${YELLOW}Installing required packages $NC"
  pkg install git zip unzip tar xz-utils
elif [ "$OSTYPE" = "linux-gnu" ]; then
  DISTRO=`grep -m1 "^ID=" "/etc/os-release" | cut -d= -f2`
  if [ "$DISTRO" = "ubuntu" ]; then
    # Install required packages for Ubuntu
    echo -e "\n${YELLOW}Installing required packages $NC"
    sudo apt install git zip unzip tar xz-utils
  elif [ "$DISTRO" = "debian" ]; then
    # Install required packages for Debian
    echo -e "\n${YELLOW}Installing required packages $NC"
    sudo apt update && sudo apt dist-upgrade
    sudo apt install git zip unzip tar xz-utils
  else
    echo -e "\n${RED}This script does not support $DISTRO $NC"
    exit 1
  fi
fi

exec bash $home/build.sh $arg_1 $arg_2