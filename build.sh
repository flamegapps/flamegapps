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

ARCH='arm64'
ZIP_DIR='zip_dir'
BUILD_DIR='builds'
DATE=`date +"%Y-%m-%d"`
ZIP_DATE=`date +"%Y%m%d"`
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m'
export home="`pwd`"
export arg_1=$1
export arg_2=$2

load_scripts() {
  . requirements.sh
  . sourcehelper.sh
  . scripts.sh
  . compress.sh
}

create_dir() {
  echo ">>> Creating directories"
  rm -rf $ZIP_DIR
  mkdir -p $ZIP_DIR/META-INF/com/google/android
  mkdir $ZIP_DIR/tar_core
  mkdir $ZIP_DIR/tar_gapps
}

copy_busybox() {
  echo "--> Copying busybox"
  cp -f tools/busybox-resources/busybox-arm $ZIP_DIR/busybox-arm
}

copy_license() {
  echo "--> Copying LICENSE"
  cp -f LICENSE $ZIP_DIR/LICENSE
}

make_gapps() {
  if [ "$EDITION" = "basic" ]; then
    mk_core_$SDK
    mk_markup_$SDK
    mk_setup_$SDK
    mk_cal_sync
    mk_wellbeing
    mk_sound_picker
    make_addon_basic_$SDK
  else
    mk_core_$SDK
    mk_markup_$SDK
    mk_setup_$SDK
    mk_cal_sync
    mk_wellbeing
    mk_sound_picker
    mk_health_service
    mk_calculator
    mk_calendar
    mk_clock
    mk_contact
    mk_dialer
    mk_messages
    mk_gboard
    mk_photos
    mk_wall_picker_$SDK
    make_addon_full_$SDK
  fi
}

create_zip() {
  FILE_NAME="FlameGApps-$ANDROID-$EDITION-$ARCH-$ZIP_DATE"
  echo "--> Creating $FILE_NAME-UNSIGNED.zip"
  cd $ZIP_DIR
  zip -9 -r $FILE_NAME-UNSIGNED.zip .
  if [ $? -gt 0 ]; then
    echo -e "--!${RED} Unable to create $FILE_NAME-UNSIGNED.zip ${NC}"
    clean_up
    exit 1
  fi
  cd ..
}

sign_zip() {
  rm -rf $BUILD_DIR/$FILE_NAME.zip
  rm -rf $BUILD_DIR/$FILE_NAME-UNSIGNED.zip
  echo "--> Signing $FILE_NAME-UNSIGNED.zip"
  mkdir -p $BUILD_DIR
  if java -jar tools/zipsigner-resources/zipsigner-*.jar "$ZIP_DIR/$FILE_NAME-UNSIGNED.zip" "$BUILD_DIR/$FILE_NAME.zip"; then
    echo "--> $FILE_NAME.zip signed & moved to $home/$BUILD_DIR/"
  else
    echo -e "${YELLOW}--! Failed to sign the zipfile $NC"
    echo "--> Moving unsigned gapps file to $home/$BUILD_DIR/"
    mv $ZIP_DIR/$FILE_NAME-UNSIGNED.zip $BUILD_DIR/
  fi
}

clean_up() {
  echo "--> Cleaning up"
  rm -rf $ZIP_DIR
  rm -rf $CORE_DIR
  rm -rf $GAPPS_DIR
  rm -rf $home/installed*
}

if [ $arg_1 -eq 9 ]; then
  ANDROID=9.0
  SDK=28
elif [ $arg_1 -eq 10 ]; then
  ANDROID=10.0
  SDK=29
elif [ $arg_1 -eq 11 ]; then
  ANDROID=11.0
  SDK=30
else
  echo -e "${RED} *** Please mention a valid android version *** ${NC}"
  exit 1
fi

if [ "$arg_2" = "basic" ]; then
  EDITION="basic"
elif [ "$arg_2" = "full" ]; then
  EDITION="full"
else
  echo -e "${RED} *** Please mention a valid gapps edition *** ${NC}"
  exit 1
fi

# Load all scripts
load_scripts

# Print working directory
echo -e "\n--> Working on $home"

# Print build info
echo "--> Building android $ANDROID $EDITION"

clean_up
create_dir
make_update_binary
make_updater_script
make_installer
make_flame_prop
make_gapps
copy_busybox
copy_license
create_zip
sign_zip
clean_up

echo -e "--> ${GREEN}Build Successful..!${NC}\n"
