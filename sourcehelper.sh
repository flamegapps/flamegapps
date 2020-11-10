#
###########################################
#
# Copyright (C) 2020 FlameGApps Project
#
# This file is part of the FlameGApps Project created by ayandebnath
#
# The FlameGApps scripts are free software, you can redistribute and/or modify them.
#
# These scripts are distributed in the hope that they'll will be useful, but WITHOUT ANY WARRANTY.
#
###########################################
#

HOST="https://gitlab.com/flamegapps/packages/-/raw/master"

check_status() {
  if [ $? -gt 0 ]; then
    echo -e "${RED}--> *** Unable to download files, please check your internet connection *** ${NC}"
    echo -e "${RED}--> *** The script will now exit *** ${NC}"
    clean_up
    exit 1
  fi
}

download_apk() {
  local FILE=$1
  local DEST=$2
  local APK="$FILE.apk"
  local OUT_DIR="repo/$DEST/$FILE"
  mkdir -p $OUT_DIR
  if [ ! -e $OUT_DIR/$APK ]; then
    curl -o "$OUT_DIR/$APK" "$HOST/$DEST/$FILE/$APK"
  else
    echo "--> $APK already exist"
  fi
  check_status
}

download_file() {
  local FILE=$1
  local DEST=$2
  local OUT_DIR="repo/$DEST"
  mkdir -p $OUT_DIR
  if [ ! -e $OUT_DIR/$FILE ]; then
    curl -o "$OUT_DIR/$FILE" "$HOST/$DEST/$FILE"
  else
    echo "--> $FILE already exist"
  fi
  check_status
}