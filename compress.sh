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

SDK_29=repo/sdk-29
SDK_30=repo/sdk-30
SDK_ALL=repo/sdk-all
CORE_DIR=temp_core
GAPPS_DIR=temp_gapps
EXTRA_DIR=temp_extra
CORE_OUT=$ZIP_DIR/tar_core
GAPPS_OUT=$ZIP_DIR/tar_gapps
EXTRA_OUT=$ZIP_DIR/tar_extra

copy_file() {
  mkdir -p "$2"
  cp -r "$1" "$2"
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

mk_core_29() {
  echo ">>> Compressing core files"
  copy_file $SDK_ALL/etc/default-permissions $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/permissions $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/preferred-apps $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/sysconfig $CORE_DIR/system/etc/
  copy_file $SDK_29/framework $CORE_DIR/system/
  copy_file $SDK_29/app/GoogleContactsSyncAdapter $CORE_DIR/system/app/
  copy_file $SDK_29/app/GoogleExtShared $CORE_DIR/system/app/
  copy_file $SDK_29/priv-app/CarrierSetup $CORE_DIR/system/priv-app/
  copy_file $SDK_29/priv-app/ConfigUpdater $CORE_DIR/system/priv-app/
  copy_file $SDK_29/priv-app/GoogleExtServices $CORE_DIR/system/priv-app/
  copy_file $SDK_29/priv-app/GoogleServicesFramework $CORE_DIR/system/priv-app/
  copy_file $SDK_29/priv-app/PrebuiltGmsCore $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/Phonesky $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GmsCoreSetupPrebuilt $CORE_DIR/system/priv-app/
  compress_core
}

mk_core_30() {
  echo ">>> Compressing core files"
  copy_file $SDK_ALL/etc/default-permissions $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/permissions $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/preferred-apps $CORE_DIR/system/etc/
  copy_file $SDK_ALL/etc/sysconfig $CORE_DIR/system/etc/
  copy_file $SDK_30/framework $CORE_DIR/system/
  copy_file $SDK_30/app/GoogleContactsSyncAdapter $CORE_DIR/system/app/
  copy_file $SDK_30/app/GoogleExtShared $CORE_DIR/system/app/
  copy_file $SDK_30/priv-app/CarrierSetup $CORE_DIR/system/priv-app/
  copy_file $SDK_30/priv-app/ConfigUpdater $CORE_DIR/system/priv-app/
  copy_file $SDK_30/priv-app/GoogleExtServices $CORE_DIR/system/priv-app/
  copy_file $SDK_30/priv-app/GoogleServicesFramework $CORE_DIR/system/priv-app/
  copy_file $SDK_30/priv-app/PrebuiltGmsCore $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/Phonesky $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GmsCoreSetupPrebuilt $CORE_DIR/system/priv-app/
  copy_file $SDK_30/overlay/forceQueryablePackagesOverlay.apk $CORE_DIR/system/product/overlay/
  compress_core
}

mk_markup_29() {
  echo ">>> Compressing MarkupGoogle"
  copy_file $SDK_29/app/MarkupGoogle $GAPPS_DIR/system/app/
  copy_file $SDK_29/lib64/libsketchology_native.so $GAPPS_DIR/system/lib64/
  compress_gapps "MarkupGoogle.tar.xz" 
}

mk_markup_30() {
  echo ">>> Compressing MarkupGoogle"
  copy_file $SDK_30/app/MarkupGoogle $GAPPS_DIR/system/app/
  copy_file $SDK_30/lib64/libsketchology_native.so $GAPPS_DIR/system/lib64/
  compress_gapps "MarkupGoogle.tar.xz"
}

mk_setup_29() {
  echo ">>> Compressing SetupWizard"
  copy_file $SDK_29/priv-app/SetupWizard $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleBackupTransport $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleRestore $GAPPS_DIR/system/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_setup_30() {
  echo ">>> Compressing SetupWizard"
  copy_file $SDK_30/priv-app/SetupWizard $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleBackupTransport $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleRestore $GAPPS_DIR/system/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_package_installer_29() {
  echo ">>> Compressing GooglePackageInstaller"
  copy_file $SDK_29/priv-app/GooglePackageInstaller $GAPPS_DIR/system/priv-app/
  compress_gapps "GooglePackageInstaller.tar.xz" 
}

mk_package_installer_30() {
  echo ">>> Compressing GooglePackageInstaller"
  copy_file $SDK_30/priv-app/GooglePackageInstaller $GAPPS_DIR/system/priv-app/
  compress_gapps "GooglePackageInstaller.tar.xz" 
}

mk_cal_sync() {
  echo ">>> Compressing CalendarSync"
  copy_file $SDK_ALL/app/GoogleCalendarSyncAdapter $GAPPS_DIR/system/app/
  compress_gapps "CalendarSync.tar.xz"
}

mk_wellbeing() {
  echo ">>> Compressing DigitalWellbeing"
  copy_file $SDK_ALL/priv-app/WellbeingPrebuilt $GAPPS_DIR/system/priv-app/
  compress_gapps "DigitalWellbeing.tar.xz"
}

mk_sound_picker() {
  echo ">>> Compressing GoogleSoundPicker"
  copy_file $SDK_ALL/app/SoundPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "SoundPickerGoogle.tar.xz"
}

mk_health_service() {
  echo ">>> Compressing DeviceHealthServices"
  copy_file $SDK_ALL/priv-app/Turbo $GAPPS_DIR/system/priv-app/
  compress_gapps "DeviceHealthServices.tar.xz"
}

mk_calculator() {
  echo ">>> Compressing GoogleCalculator"
  copy_file $SDK_ALL/app/CalculatorGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "GoogleCalculator.tar.xz"
}

mk_calendar() {
  echo ">>> Compressing GoogleCalendar"
  copy_file $SDK_ALL/app/CalendarGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "GoogleCalendar.tar.xz"
}

mk_clock() {
  echo ">>> Compressing GoogleClock"
  copy_file $SDK_ALL/app/PrebuiltDeskClockGoogle $GAPPS_DIR/system/app/
  compress_gapps "GoogleClock.tar.xz"
}

mk_contact() {
  echo ">>> Compressing GoogleContacts"
  copy_file $SDK_ALL/priv-app/GoogleContacts $GAPPS_DIR/system/priv-app/
  compress_gapps "GoogleContacts.tar.xz"
}

mk_dialer() {
  echo ">>> Compressing GoogleDialer"
  copy_file $SDK_ALL/priv-app/GoogleDialer $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/overlay/GoogleDialerOverlay.apk $GAPPS_DIR/system/product/overlay/
  compress_gapps "GoogleDialer.tar.xz"
}

mk_messages() {
  echo ">>> Compressing GoogleMessages"
  copy_file $SDK_ALL/app/PrebuiltBugle $GAPPS_DIR/system/app/
  compress_gapps "GoogleMessages.tar.xz"
}

mk_gboard() {
  echo ">>> Compressing GoogleKeyboard"
  copy_file $SDK_ALL/app/LatinIMEGooglePrebuilt $GAPPS_DIR/system/app/
  copy_file $SDK_ALL/lib64/libjni_latinimegoogle.so $GAPPS_DIR/system/lib64/
  compress_gapps "GoogleKeyboard.tar.xz"
}

mk_photos() {
  echo ">>> Compressing GooglePhotos"
  copy_file $SDK_ALL/app/Photos $GAPPS_DIR/system/app/
  compress_gapps "GooglePhotos.tar.xz"
}

mk_android_auto_stub() {
  echo ">>> Compressing AndroidAutoStub"
  copy_file $SDK_ALL/priv-app/AndroidAutoStubPrebuilt $GAPPS_DIR/system/priv-app/
  compress_gapps "AndroidAutoStub.tar.xz"
}

mk_wall_picker_29() {
  echo ">>> Compressing WallpaperPickerGoogle"
  copy_file $SDK_29/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}

mk_wall_picker_30() {
  echo ">>> Compressing WallpaperPickerGoogle"
  copy_file $SDK_30/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}

mk_pixel_config() {
  echo ">>> Compressing GooglePixelConfig"
  copy_file $SDK_ALL/etc/sysconfig_pixel/nexus.xml $EXTRA_DIR/system/etc/sysconfig/
  copy_file $SDK_ALL/etc/sysconfig_pixel/pixel_2018_exclusive.xml $EXTRA_DIR/system/etc/sysconfig/
  copy_file $SDK_ALL/etc/sysconfig_pixel/pixel_experience_2017.xml $EXTRA_DIR/system/etc/sysconfig/
  copy_file $SDK_ALL/etc/sysconfig_pixel/pixel_experience_2018.xml $EXTRA_DIR/system/etc/sysconfig/
  compress_extra "PixelConfig.tar.xz"
}
