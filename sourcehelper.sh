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

echo -e "\n${YELLOW}Updating submodule(s)... $NC"

git submodule update --init --remote --depth=1 'sources/gapps-resources'

if [ "$?" -ne "0" ]; then
  echo -e "${RED}Something went wrong, unable to clone/update submodule(s) $NC"
  echo -e "${RED}*** The script will now exit *** $NC"
  exit 1
fi

git config --list | grep -q 'filter.lfs.process=git-lfs filter-process' || git submodule foreach 'git lfs install'

git submodule foreach 'git checkout main; git pull --depth=1 --rebase; git lfs pull'

echo -e "${YELLOW}Updated. $NC"
