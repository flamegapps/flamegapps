#
###########################################
#
# Copyright (C) 2021 FlameGApps Project
#
# This file is part of the FlameGApps Project created by ayandebnath
#
# The FlameGApps scripts are free software, you can redistribute and/or modify them.
#
# These scripts are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY.
#
###########################################
#

URL="https://gitlab.com/flamegapps/gapps-resources.git"
DEST='repo'
BRANCH='master'

if [ -d $DEST ]; then
  echo -e "\n${YELLOW}Pulling changes from APK repository $NC"
  cd $DEST
  git pull
  if [ $? -gt 0 ]; then
    echo -e "--!$RED *** Unable to pull changes, please check your internet connection *** $NC"
    echo -e "--!$RED *** The script will now exit *** ${NC}"
    cd ..
    clean_up
    exit 1
  fi
  cd ..
else
  echo -e "\n${YELLOW}Cloning APK repository $NC"
  git clone --branch $BRANCH --depth 1 $URL $DEST
  if [ $? -gt 0 ]; then
    echo -e "--!$RED *** Unable to clone repository, please check your internet connection *** $NC"
    echo -e "--!$RED *** The script will now exit *** $NC"
    clean_up
    exit 1
  fi
fi
