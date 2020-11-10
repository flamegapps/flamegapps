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

# Android 9.0
download_basic_28() {
  download_apk GoogleContactsSyncAdapter sdk-28/app
  download_apk GoogleExtShared sdk-28/app
  download_apk CarrierSetup sdk-28/priv-app
  download_apk ConfigUpdater sdk-28/priv-app
  download_apk GmsCoreSetupPrebuilt sdk-all/priv-app
  download_apk GoogleExtServices sdk-28/priv-app
  download_apk GoogleServicesFramework sdk-28/priv-app
  download_apk PrebuiltGmsCorePi sdk-28/priv-app
  download_apk Phonesky sdk-all/priv-app

  download_file default-permissions.xml sdk-28/etc/default-permissions
  download_file opengapps-permissions.xml sdk-28/etc/default-permissions

  download_file com.google.android.dialer.support.xml sdk-28/etc/permissions
  download_file com.google.android.maps.xml sdk-28/etc/permissions
  download_file com.google.android.media.effects.xml sdk-28/etc/permissions
  download_file privapp-permissions-google.xml sdk-28/etc/permissions

  download_file google.xml sdk-28/etc/preferred-apps

  download_file dialer_experience.xml sdk-28/etc/sysconfig
  download_file google.xml sdk-28/etc/sysconfig
  download_file google_build.xml sdk-28/etc/sysconfig
  download_file google_exclusives_enable.xml sdk-28/etc/sysconfig
  download_file google-hiddenapi-package-whitelist.xml sdk-28/etc/sysconfig
  download_file nexus.xml sdk-28/etc/sysconfig
  download_file pixel_2018_exclusive.xml sdk-28/etc/sysconfig
  download_file pixel_experience_2017.xml sdk-28/etc/sysconfig
  download_file pixel_experience_2018.xml sdk-28/etc/sysconfig

  download_file com.google.android.dialer.support.jar sdk-28/framework
  download_file com.google.android.maps.jar sdk-28/framework
  download_file com.google.android.media.effects.jar sdk-28/framework

  download_apk MarkupGoogle sdk-28/app
  download_apk GoogleLocationHistory sdk-all/app
  download_apk SoundPickerPrebuilt sdk-all/app
  download_apk WellbeingPrebuilt sdk-all/priv-app
  download_apk SetupWizard sdk-28/priv-app
  download_apk AndroidMigratePrebuilt sdk-all/priv-app
  download_apk GoogleBackupTransport sdk-all/priv-app
  download_apk GoogleRestore sdk-all/priv-app
  download_apk GoogleCalendarSyncAdapter sdk-all/app
  download_file libsketchology_native.so sdk-28/app/MarkupGoogle/lib/arm64
}

download_full_28() {
  download_basic_28
  download_apk WallpaperPickerGooglePrebuilt sdk-28/app
  download_apk CalculatorGooglePrebuilt sdk-all/app
  download_apk CalendarGooglePrebuilt sdk-all/app
  download_apk LatinIMEGooglePrebuilt sdk-all/app
  download_apk Photos sdk-all/app
  download_apk PrebuiltBugle sdk-all/app
  download_apk PrebuiltDeskClockGoogle sdk-all/app
  download_apk GoogleContacts sdk-all/priv-app
  download_apk GoogleDialer sdk-all/priv-app
  download_apk Turbo sdk-all/priv-app
  download_file libbarhopper.so sdk-all/lib64
  download_file libjni_latinimegoogle.so sdk-all/lib64
}

# Android 10
download_basic_29() {
  download_apk GoogleContactsSyncAdapter sdk-29/app
  download_apk GoogleExtShared sdk-29/app
  download_apk CarrierSetup sdk-29/priv-app
  download_apk ConfigUpdater sdk-29/priv-app
  download_apk GmsCoreSetupPrebuilt sdk-all/priv-app
  download_apk GoogleExtServices sdk-29/priv-app
  download_apk GoogleServicesFramework sdk-29/priv-app
  download_apk PrebuiltGmsCoreQt sdk-29/priv-app
  download_apk Phonesky sdk-all/priv-app

  download_file default-permissions.xml sdk-29/etc/default-permissions
  download_file opengapps-permissions.xml sdk-29/etc/default-permissions

  download_file com.google.android.dialer.support.xml sdk-29/etc/permissions
  download_file com.google.android.maps.xml sdk-29/etc/permissions
  download_file com.google.android.media.effects.xml sdk-29/etc/permissions
  download_file privapp-permissions-google.xml sdk-29/etc/permissions
  download_file split-permissions-google.xml sdk-29/etc/permissions

  download_file google.xml sdk-29/etc/preferred-apps

  download_file dialer_experience.xml sdk-29/etc/sysconfig
  download_file google.xml sdk-29/etc/sysconfig
  download_file google_build.xml sdk-29/etc/sysconfig
  download_file google_exclusives_enable.xml sdk-29/etc/sysconfig
  download_file google-hiddenapi-package-whitelist.xml sdk-29/etc/sysconfig
  download_file nexus.xml sdk-29/etc/sysconfig
  download_file pixel_2018_exclusive.xml sdk-29/etc/sysconfig
  download_file pixel_experience_2017.xml sdk-29/etc/sysconfig
  download_file pixel_experience_2018.xml sdk-29/etc/sysconfig

  download_file com.google.android.dialer.support.jar sdk-29/framework
  download_file com.google.android.maps.jar sdk-29/framework
  download_file com.google.android.media.effects.jar sdk-29/framework

  download_apk MarkupGoogle sdk-29/app
  download_apk GoogleLocationHistory sdk-all/app
  download_apk SoundPickerPrebuilt sdk-all/app
  download_apk WellbeingPrebuilt sdk-all/priv-app
  download_apk SetupWizard sdk-29/priv-app
  download_apk AndroidMigratePrebuilt sdk-all/priv-app
  download_apk GoogleBackupTransport sdk-all/priv-app
  download_apk GoogleRestore sdk-all/priv-app
  download_apk GoogleCalendarSyncAdapter sdk-all/app
  download_file libsketchology_native.so sdk-29/app/MarkupGoogle/lib/arm64
}

download_full_29() {
  download_basic_29
  download_apk WallpaperPickerGooglePrebuilt sdk-29/app
  download_apk CalculatorGooglePrebuilt sdk-all/app
  download_apk CalendarGooglePrebuilt sdk-all/app
  download_apk LatinIMEGooglePrebuilt sdk-all/app
  download_apk Photos sdk-all/app
  download_apk PrebuiltBugle sdk-all/app
  download_apk PrebuiltDeskClockGoogle sdk-all/app
  download_apk GoogleContacts sdk-all/priv-app
  download_apk GoogleDialer sdk-all/priv-app
  download_apk Turbo sdk-all/priv-app
  download_file libbarhopper.so sdk-all/lib64
  download_file libjni_latinimegoogle.so sdk-all/lib64
}


# Android 11.0
download_basic_30() {
  download_apk GoogleContactsSyncAdapter sdk-30/app
  download_apk GoogleExtShared sdk-30/app
  download_apk CarrierSetup sdk-30/priv-app
  download_apk ConfigUpdater sdk-30/priv-app
  download_apk GmsCoreSetupPrebuilt sdk-all/priv-app
  download_apk GoogleExtServices sdk-30/priv-app
  download_apk GoogleServicesFramework sdk-30/priv-app
  download_apk PrebuiltGmsCore sdk-30/priv-app
  download_apk Phonesky sdk-all/priv-app

  download_file default-permissions.xml sdk-30/etc/default-permissions
  download_file opengapps-permissions.xml sdk-30/etc/default-permissions

  download_file com.google.android.dialer.support.xml sdk-30/etc/permissions
  download_file com.google.android.maps.xml sdk-30/etc/permissions
  download_file com.google.android.media.effects.xml sdk-30/etc/permissions
  download_file privapp-permissions-google.xml sdk-30/etc/permissions

  download_file google.xml sdk-30/etc/preferred-apps

  download_file dialer_experience.xml sdk-30/etc/sysconfig
  download_file google.xml sdk-30/etc/sysconfig
  download_file google_build.xml sdk-30/etc/sysconfig
  download_file google_exclusives_enable.xml sdk-30/etc/sysconfig
  download_file google-hiddenapi-package-whitelist.xml sdk-30/etc/sysconfig
  download_file nexus.xml sdk-30/etc/sysconfig
  download_file pixel_2018_exclusive.xml sdk-30/etc/sysconfig
  download_file pixel_experience_2017.xml sdk-30/etc/sysconfig
  download_file pixel_experience_2018.xml sdk-30/etc/sysconfig

  download_file com.google.android.dialer.support.jar sdk-30/framework
  download_file com.google.android.maps.jar sdk-30/framework
  download_file com.google.android.media.effects.jar sdk-30/framework

  download_apk MarkupGoogle sdk-30/app
  download_apk GoogleLocationHistory sdk-all/app
  download_apk SoundPickerPrebuilt sdk-all/app
  download_apk WellbeingPrebuilt sdk-all/priv-app
  download_apk SetupWizard sdk-30/priv-app
  download_apk AndroidMigratePrebuilt sdk-all/priv-app
  download_apk GoogleBackupTransport sdk-all/priv-app
  download_apk GoogleRestore sdk-all/priv-app
  download_apk GoogleCalendarSyncAdapter sdk-all/app
  download_file libsketchology_native.so sdk-30/app/MarkupGoogle/lib/arm64
}

download_full_30() {
  download_basic_30
  download_apk WallpaperPickerGooglePrebuilt sdk-30/app
  download_apk CalculatorGooglePrebuilt sdk-all/app
  download_apk CalendarGooglePrebuilt sdk-all/app
  download_apk LatinIMEGooglePrebuilt sdk-all/app
  download_apk Photos sdk-all/app
  download_apk PrebuiltBugle sdk-all/app
  download_apk PrebuiltDeskClockGoogle sdk-all/app
  download_apk GoogleContacts sdk-all/priv-app
  download_apk GoogleDialer sdk-all/priv-app
  download_apk Turbo sdk-all/priv-app
  download_file libbarhopper.so sdk-all/lib64
  download_file libjni_latinimegoogle.so sdk-all/lib64
}