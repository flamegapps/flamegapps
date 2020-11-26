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

SDK_28=repo/sdk-28
SDK_29=repo/sdk-29
SDK_30=repo/sdk-30
SDK_ALL=repo/sdk-all
CORE_DIR=temp_core
GAPPS_DIR=temp_gapps
CORE_OUT=$ZIP_DIR/tar_core
GAPPS_OUT=$ZIP_DIR/tar_gapps

make_app() {
  rm -rf $GAPPS_DIR/system
  mkdir -p $GAPPS_DIR/system/app
}

make_priv_app() {
  rm -rf $GAPPS_DIR/system
  mkdir -p $GAPPS_DIR/system/priv-app
}

copy_file() {
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

mk_core_28() {
  echo ">>> Compressing core files"
  mkdir -p $CORE_DIR/system/app $CORE_DIR/system/priv-app $CORE_DIR/system/lib $CORE_DIR/system/lib64
  copy_file $SDK_28/etc $CORE_DIR/system/
  copy_file $SDK_28/framework $CORE_DIR/system/
  copy_file $SDK_28/app/GoogleContactsSyncAdapter $CORE_DIR/system/app/
  copy_file $SDK_28/app/GoogleExtShared $CORE_DIR/system/app/
  copy_file $SDK_28/priv-app/CarrierSetup $CORE_DIR/system/priv-app/
  copy_file $SDK_28/priv-app/ConfigUpdater $CORE_DIR/system/priv-app/
  copy_file $SDK_28/priv-app/GoogleExtServices $CORE_DIR/system/priv-app/
  copy_file $SDK_28/priv-app/GoogleServicesFramework $CORE_DIR/system/priv-app/
  copy_file $SDK_28/priv-app/PrebuiltGmsCore $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/Phonesky $CORE_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GmsCoreSetupPrebuilt $CORE_DIR/system/priv-app/
  compress_core
}

mk_core_29() {
  echo ">>> Compressing core files"
  mkdir -p $CORE_DIR/system/app $CORE_DIR/system/priv-app
  copy_file $SDK_29/etc $CORE_DIR/system/
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
  mkdir -p $CORE_DIR/system/app $CORE_DIR/system/priv-app
  copy_file $SDK_30/etc $CORE_DIR/system/
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
  compress_core
}

mk_markup_28() {
  echo ">>> Compressing MarkupGoogle"
  make_app
  copy_file $SDK_28/app/MarkupGoogle $GAPPS_DIR/system/app/
  mkdir -p $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64
  copy_file $SDK_28/app/MarkupGoogle/lib/arm64/libsketchology_native.so $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64/
  compress_gapps "MarkupGoogle.tar.xz"
}

mk_markup_29() {
  echo ">>> Compressing MarkupGoogle"
  make_app
  copy_file $SDK_29/app/MarkupGoogle $GAPPS_DIR/system/app/
  mkdir -p $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64
  copy_file $SDK_29/app/MarkupGoogle/lib/arm64/libsketchology_native.so $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64/
  compress_gapps "MarkupGoogle.tar.xz" 
}

mk_markup_30() {
  echo ">>> Compressing MarkupGoogle"
  make_app
  copy_file $SDK_30/app/MarkupGoogle $GAPPS_DIR/system/app/
  mkdir -p $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64
  copy_file $SDK_30/app/MarkupGoogle/lib/arm64/libsketchology_native.so $GAPPS_DIR/system/app/MarkupGoogle/lib/arm64/
  compress_gapps "MarkupGoogle.tar.xz"
}

mk_setup_28() {
  echo ">>> Compressing SetupWizard"
  make_priv_app
  copy_file $SDK_28/priv-app/SetupWizard $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleBackupTransport $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleRestore $GAPPS_DIR/system/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_setup_29() {
  echo ">>> Compressing SetupWizard"
  make_priv_app
  copy_file $SDK_29/priv-app/SetupWizard $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleBackupTransport $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleRestore $GAPPS_DIR/system/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_setup_30() {
  echo ">>> Compressing SetupWizard"
  make_priv_app
  copy_file $SDK_30/priv-app/SetupWizard $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/AndroidMigratePrebuilt $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleBackupTransport $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/priv-app/GoogleRestore $GAPPS_DIR/system/priv-app/
  compress_gapps "SetupWizard.tar.xz"
}

mk_cal_sync() {
  echo ">>> Compressing CalendarSync"
  make_app
  copy_file $SDK_ALL/app/GoogleCalendarSyncAdapter $GAPPS_DIR/system/app/
  compress_gapps "CalendarSync.tar.xz"
}

mk_wellbeing() {
  echo ">>> Compressing DigitalWellbeing"
  make_priv_app
  copy_file $SDK_ALL/priv-app/WellbeingPrebuilt $GAPPS_DIR/system/priv-app/
  compress_gapps "DigitalWellbeing.tar.xz"
}

mk_location_history() {
  echo ">>> Compressing GoogleLocationHistory"
  make_app
  copy_file $SDK_ALL/app/GoogleLocationHistory $GAPPS_DIR/system/app/
  compress_gapps "GoogleLocationHistory.tar.xz"
}

mk_sound_picker() {
  echo ">>> Compressing SoundPickerPrebuilt"
  make_app
  copy_file $SDK_ALL/app/SoundPickerPrebuilt $GAPPS_DIR/system/app/
  compress_gapps "SoundPickerGoogle.tar.xz"
}

mk_health_service() {
  echo ">>> Compressing DeviceHealthServices"
  make_priv_app
  copy_file $SDK_ALL/priv-app/Turbo $GAPPS_DIR/system/priv-app/
  compress_gapps "DeviceHealthServices.tar.xz"
}

mk_calculator() {
  echo ">>> Compressing GoogleCalculator"
  make_app
  copy_file $SDK_ALL/app/CalculatorGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "GoogleCalculator.tar.xz"
}

mk_calendar() {
  echo ">>> Compressing GoogleCalendar"
  make_app
  copy_file $SDK_ALL/app/CalendarGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "GoogleCalendar.tar.xz"
}

mk_clock() {
  echo ">>> Compressing GoogleClock"
  make_app
  copy_file $SDK_ALL/app/PrebuiltDeskClockGoogle $GAPPS_DIR/system/app/
  compress_gapps "GoogleClock.tar.xz"
}

mk_contact() {
  echo ">>> Compressing GoogleContacts"
  make_priv_app
  copy_file $SDK_ALL/priv-app/GoogleContacts $GAPPS_DIR/system/priv-app/
  compress_gapps "GoogleContacts.tar.xz"
}

mk_dialer() {
  echo ">>> Compressing GoogleDialer"
  make_priv_app
  mkdir -p $GAPPS_DIR/system/product/overlay
  copy_file $SDK_ALL/priv-app/GoogleDialer $GAPPS_DIR/system/priv-app/
  copy_file $SDK_ALL/product/overlay/GoogleDialerOverlay.apk $GAPPS_DIR/system/product/overlay/
  compress_gapps "GoogleDialer.tar.xz"
}

mk_messages() {
  echo ">>> Compressing GoogleMessages"
  make_app
  copy_file $SDK_ALL/app/PrebuiltBugle $GAPPS_DIR/system/app/
  compress_gapps "GoogleMessages.tar.xz"
}

mk_gboard() {
  echo ">>> Compressing GoogleKeyboard"
  make_app
  mkdir -p $GAPPS_DIR/system/lib64
  copy_file $SDK_ALL/app/LatinIMEGooglePrebuilt $GAPPS_DIR/system/app/
  copy_file $SDK_ALL/lib64/libjni_latinimegoogle.so $GAPPS_DIR/system/lib64/
  compress_gapps "GoogleKeyboard.tar.xz"
}

mk_photos() {
  echo ">>> Compressing GooglePhotos"
  make_app
  copy_file $SDK_ALL/app/Photos $GAPPS_DIR/system/app/
  compress_gapps "GooglePhotos.tar.xz"
}

mk_wall_picker_28() {
  echo ">>> Compressing WallpaperPickerGoogle"
  make_app
  copy_file $SDK_28/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}

mk_wall_picker_29() {
  echo ">>> Compressing WallpaperPickerGoogle"
  make_app
  copy_file $SDK_29/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}

mk_wall_picker_30() {
  echo ">>> Compressing WallpaperPickerGoogle"
  make_app
  copy_file $SDK_30/app/WallpaperPickerGooglePrebuilt $GAPPS_DIR/system/app/
  compress_gapps "WallpaperPickerGoogle.tar.xz"
}