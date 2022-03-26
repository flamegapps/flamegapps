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

APK_REPO=sources/gapps-resources
CORE_DIR=temp_core
GAPPS_DIR=temp_gapps
EXTRA_DIR=temp_extra
REQUIRED_SIZE=0
CORE_OUT=$ZIP_DIR/tar_core
GAPPS_OUT=$ZIP_DIR/tar_gapps
EXTRA_OUT=$ZIP_DIR/tar_extra

get_size() {
  local ITEM="$1"
  local FILE_SIZE
  if [ -e "$ITEM" ]; then
    FILE_SIZE=`du -sk "$ITEM" | cut -f1`
  else
    FILE_SIZE=0
  fi
  REQUIRED_SIZE=$(($REQUIRED_SIZE + $FILE_SIZE))
}

copy_file() {
  local SOURCE DEST
  SOURCE="$1"
  DEST="$2"
  get_size "$SOURCE"
  mkdir -p "$DEST"
  cp -r "$SOURCE" "$DEST"
  if [ $? -gt 0 ]; then
    echo -e "--> ${RED}*** Unable to copy files ***${NC}"
    echo -e "--> ${RED}*** The script will now exit ***${NC}"
    clean_up
    exit 1
  fi
}

compress_core() {
  cd $CORE_DIR
  tar -cf - * | xz -9e > ../$CORE_OUT/Core.tar.xz
  cd ..
  rm -rf $CORE_DIR
}

compress_gapps() {
  cd $GAPPS_DIR
  tar -cf - * | xz -9e > ../$GAPPS_OUT/$1
  cd ..
  rm -rf $GAPPS_DIR/*
}

compress_extra() {
  cd $EXTRA_DIR
  tar -cf - * | xz -9e > ../$EXTRA_OUT/$1
  cd ..
  rm -rf $EXTRA_DIR/*
}

mk_core() {
  echo ">>> Compressing core files"
  copy_file $APK_REPO/sdk-all/etc/default-permissions $CORE_DIR/src/etc/
  copy_file $APK_REPO/sdk-all/etc/permissions $CORE_DIR/src/etc/
  copy_file $APK_REPO/sdk-all/etc/preferred-apps $CORE_DIR/src/etc/
  copy_file $APK_REPO/sdk-all/etc/sysconfig $CORE_DIR/src/etc/
  copy_file $APK_REPO/sdk-${SDK}/framework $CORE_DIR/src/
  copy_file $APK_REPO/sdk-${SDK}/app/GoogleContactsSyncAdapter $CORE_DIR/src/app/
  copy_file $APK_REPO/sdk-${SDK}/app/GoogleExtShared $CORE_DIR/src/app/
  copy_file $APK_REPO/sdk-${SDK}/priv-app/CarrierSetup $CORE_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-${SDK}/priv-app/ConfigUpdater $CORE_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-${SDK}/priv-app/GoogleExtServices $CORE_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-${SDK}/priv-app/GoogleServicesFramework $CORE_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-${SDK}/priv-app/PrebuiltGmsCore $CORE_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-all/priv-app/Phonesky $CORE_DIR/src/priv-app/
  if [ "$SDK" -ge "30" ]; then
    copy_file $APK_REPO/sdk-30/overlay/forceQueryablePackagesOverlay.apk $CORE_DIR/src/overlay/
  fi
  if [ -e "$APK_REPO/sdk-${SDK}/etc" ]; then
    copy_file $APK_REPO/sdk-${SDK}/etc $CORE_DIR/src/
  fi
  compress_core
}

mk_markup() {
  echo ">>> Compressing MarkupGoogle"
  copy_file $APK_REPO/sdk-${SDK}/app/MarkupGoogle $GAPPS_DIR/src/app/
  copy_file $APK_REPO/sdk-${SDK}/lib64/libsketchology_native.so $GAPPS_DIR/src/lib64/
  compress_gapps "MarkupGoogle.tar.xz" 
}

mk_setup_wizard() {
  echo ">>> Compressing SetupWizard"
  copy_file $APK_REPO/sdk-${SDK}/priv-app/SetupWizard $GAPPS_DIR/src/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_android_migrate() {
  echo ">>> Compressing AndroidMigrate"
  copy_file $APK_REPO/sdk-all/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/src/priv-app/
  compress_gapps "AndroidMigrate.tar.xz"
}

mk_google_restore() {
  echo ">>> Compressing GoogleRestore"
  copy_file $APK_REPO/sdk-all/priv-app/GoogleRestore $GAPPS_DIR/src/priv-app/
  compress_gapps "GoogleRestore.tar.xz"
}

mk_backup_transport() {
  echo ">>> Compressing GoogleBackupTransport"
  copy_file $APK_REPO/sdk-all/priv-app/GoogleBackupTransport $GAPPS_DIR/src/priv-app/
  compress_gapps "GoogleBackupTransport.tar.xz"
}

mk_package_installer() {
  echo ">>> Compressing GooglePackageInstaller"
  copy_file $APK_REPO/sdk-${SDK}/priv-app/GooglePackageInstaller $GAPPS_DIR/src/priv-app/
  compress_gapps "GooglePackageInstaller.tar.xz" 
}

mk_cal_sync() {
  echo ">>> Compressing CalendarSync"
  copy_file $APK_REPO/sdk-all/app/GoogleCalendarSyncAdapter $GAPPS_DIR/src/app/
  compress_gapps "CalendarSync.tar.xz"
}

mk_wellbeing() {
  echo ">>> Compressing DigitalWellbeing"
  copy_file $APK_REPO/sdk-all/priv-app/WellbeingPrebuilt $GAPPS_DIR/src/priv-app/
  compress_gapps "DigitalWellbeing.tar.xz"
}

mk_sound_picker() {
  echo ">>> Compressing GoogleSoundPicker"
  if [ "$SDK" -ge "31" ]; then
    copy_file $APK_REPO/sdk-31/app/SoundPickerGooglePrebuilt $GAPPS_DIR/src/app/
  else
    copy_file $APK_REPO/sdk-all/app/SoundPickerGooglePrebuilt $GAPPS_DIR/src/app/
  fi
  compress_gapps "SoundPickerGoogle.tar.xz"
}

mk_health_service() {
  echo ">>> Compressing DeviceHealthServices"
  copy_file $APK_REPO/sdk-all/priv-app/Turbo $GAPPS_DIR/src/priv-app/
  compress_gapps "DeviceHealthServices.tar.xz"
}

mk_calculator() {
  echo ">>> Compressing GoogleCalculator"
  copy_file $APK_REPO/sdk-all/app/CalculatorGooglePrebuilt $GAPPS_DIR/src/app/
  compress_gapps "GoogleCalculator.tar.xz"
}

mk_calendar() {
  echo ">>> Compressing GoogleCalendar"
  copy_file $APK_REPO/sdk-all/app/CalendarGooglePrebuilt $GAPPS_DIR/src/app/
  compress_gapps "GoogleCalendar.tar.xz"
}

mk_clock() {
  echo ">>> Compressing GoogleClock"
  copy_file $APK_REPO/sdk-all/app/PrebuiltDeskClockGoogle $GAPPS_DIR/src/app/
  compress_gapps "GoogleClock.tar.xz"
}

mk_contact() {
  echo ">>> Compressing GoogleContacts"
  copy_file $APK_REPO/sdk-all/priv-app/GoogleContacts $GAPPS_DIR/src/priv-app/
  compress_gapps "GoogleContacts.tar.xz"
}

mk_dialer() {
  echo ">>> Compressing GoogleDialer"
  copy_file $APK_REPO/sdk-all/priv-app/GoogleDialer $GAPPS_DIR/src/priv-app/
  copy_file $APK_REPO/sdk-all/overlay/GoogleDialerOverlay.apk $GAPPS_DIR/src/overlay/
  compress_gapps "GoogleDialer.tar.xz"
}

mk_messages() {
  echo ">>> Compressing GoogleMessages"
  copy_file $APK_REPO/sdk-all/app/PrebuiltBugle $GAPPS_DIR/src/app/
  compress_gapps "GoogleMessages.tar.xz"
}

mk_gboard() {
  echo ">>> Compressing GoogleKeyboard"
  copy_file $APK_REPO/sdk-all/app/LatinIMEGooglePrebuilt $GAPPS_DIR/src/app/
  copy_file $APK_REPO/sdk-all/lib64/libjni_latinimegoogle.so $GAPPS_DIR/src/lib64/
  compress_gapps "GoogleKeyboard.tar.xz"
}

mk_photos() {
  echo ">>> Compressing GooglePhotos"
  copy_file $APK_REPO/sdk-all/app/Photos $GAPPS_DIR/src/app/
  compress_gapps "GooglePhotos.tar.xz"
}

mk_android_auto_stub() {
  echo ">>> Compressing AndroidAutoStub"
  copy_file $APK_REPO/sdk-all/priv-app/AndroidAutoStubPrebuilt $GAPPS_DIR/src/priv-app/
  compress_gapps "AndroidAutoStub.tar.xz"
}

mk_wall_picker() {
  echo ">>> Compressing WallpaperPickerGoogle"
  copy_file $APK_REPO/sdk-${SDK}/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/src/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}

mk_pixel_config() {
  echo ">>> Compressing GooglePixelConfig"
  copy_file $APK_REPO/sdk-all/etc/sysconfig_pixel/nexus.xml $EXTRA_DIR/src/etc/sysconfig/
  copy_file $APK_REPO/sdk-all/etc/sysconfig_pixel/pixel_2018_exclusive.xml $EXTRA_DIR/src/etc/sysconfig/
  copy_file $APK_REPO/sdk-all/etc/sysconfig_pixel/pixel_experience_2017.xml $EXTRA_DIR/src/etc/sysconfig/
  copy_file $APK_REPO/sdk-all/etc/sysconfig_pixel/pixel_experience_2018.xml $EXTRA_DIR/src/etc/sysconfig/
  compress_extra "PixelConfig.tar.xz"
}
