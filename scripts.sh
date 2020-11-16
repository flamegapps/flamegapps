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

make_flame_prop() {
  echo ">>> Creating flame.prop"
  echo -e '\n# FlameGApps prop file
ro.flame.android='$ANDROID'
ro.flame.sdk='$SDK'
ro.flame.arch='$ARCH'
ro.flame.edition='$EDITION'
' > $ZIP_DIR/flame.prop
}

make_update_binary() {
  echo ">>> Creating update-binary"
  echo '#!/sbin/sh
#
############################################
#
# This file is a part of the FlameGApps Project by ayandebnath @xda-developers
#
# Taken from OpenGApps.org update-binary
# For reference, check https://github.com/opengapps/opengapps/blob/master/scripts/inc.installer.sh
#
############################################
# File Name    : update-binary
# Last Updated : '$DATE'
############################################
#

export ZIPFILE="$3"
export OUTFD="/proc/self/fd/$2"
export TMP="/tmp"

bb="$TMP/busybox-arm"
l="$TMP/bin"

setenforce 0

ui_print() {
  echo "ui_print $1
    ui_print" >> $OUTFD
}

ui_print " "
ui_print "  _____ _                        "
ui_print " |  ___| | __ _ _ __ ___   ___   "
ui_print " | |_  | |/ _  |  _   _ \ / _ \  "
ui_print " |  _| | | (_| | | | | | |  __/  "
ui_print " |_|___|_|\__,_|_| |_| |_|\___|  "
ui_print "  / ___|  / \   _ __  _ __  ___  "
ui_print " | |  _  / _ \ |  _ \|  _ \/ __| "
ui_print " | |_| |/ ___ \| |_) | |_) \__ \ "
ui_print "  \____/_/   \_\ .__/| .__/|___/ "
ui_print "               |_|   |_|         "
ui_print " "
ui_print "*************************************************"
ui_print " Android Version : '$ANDROID'"
ui_print " Edition type    : '$EDITION'"
ui_print " Build Date      : '$DATE'"
ui_print "*************************************************"
ui_print " "
ui_print "- Preparing Installer"

for f in busybox-arm installer.sh flame.prop addon.d.sh; do
  unzip -o "$ZIPFILE" "$f" -d "$TMP"
done

chmod +x "$TMP/busybox-arm"

if [ -e "$bb" ]; then
  install -d "$l"
  for i in $($bb --list); do
    if ! ln -sf "$bb" "$l/$i" && ! $bb ln -sf "$bb" "$l/$i" && ! $bb ln -f "$bb" "$l/$i" ; then
      # create script wrapper if symlinking and hardlinking failed because of restrictive selinux policy
      if ! echo "#!$bb" > "$l/$i" || ! chmod +x "$l/$i" ; then
        ui_print "ERROR 10: Failed to set-up pre-bundled busybox"
        exit 1
      fi
    fi
  done
else
  exit 1
fi

PATH="$l:$PATH" $bb sh "$TMP/installer.sh" "$@"
  exit "$?"
else
  ui_print "ERROR 69: Wrong architecture to set-up pre-bundled busybox"
  exit 1
fi
' > $ZIP_DIR/META-INF/com/google/android/update-binary
}

make_updater_script() {
  echo ">>> Creating updater-script"
  echo "# Dummy file; update-binary is a shell script." > $ZIP_DIR/META-INF/com/google/android/updater-script
}

make_installer() {
  echo ">>> Creating installer.sh"
  cat scripts/installer.sh > $ZIP_DIR/installer.sh
}

make_addon_basic_28() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/GoogleExtShared/GoogleExtShared.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/MarkupGoogle/MarkupGoogle.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
EOF
}

rm_list="
app/ExtShared
app/FaceLock
app/GoogleExtShared
app/GoogleContactSyncAdapter
priv-app/ExtServices
priv-app/AndroidPlatformServices
priv-app/GoogleServicesFramework
priv-app/GmsCoreSetupPrebuilt
priv-app/GmsCore
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/Phonesky
priv-app/Wellbeing
priv-app/WellbeingGooglePrebuilt
priv-app/WellbeingPrebuilt
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
    done
    
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}

make_addon_full_28() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/CalculatorGooglePrebuilt/CalculatorGooglePrebuilt.apk
app/CalendarGooglePrebuilt/CalendarGooglePrebuilt.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleExtShared/GoogleExtShared.apk
app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk
app/MarkupGoogle/MarkupGoogle.apk
app/Photos/Photos.apk
app/PrebuiltBugle/PrebuiltBugle.apk
app/PrebuiltDeskClockGoogle/PrebuiltDeskClockGoogle.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/WallpaperPickerGooglePrebuilt/WallpaperPickerGooglePrebuilt.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
priv-app/GoogleContacts/GoogleContacts.apk
priv-app/GoogleDialer/GoogleDialer.apk
priv-app/Turbo/Turbo.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
lib64/libjni_latinimegoogle.so
lib64/libbarhopper.so
product/overlay/GoogleDialerOverlay.apk
EOF
}

rm_list="
app/AudioFX
app/ExtShared
app/Etar
app/FaceLock
app/Clock
app/DeskClock
app/DashClock
app/PrebuiltDeskClock
app/Calculator
app/Calculator2
app/ExactCalculator
app/RevengeOSCalculator
app/Calendar
app/CalendarPrebuilt
app/Eleven
app/message
app/messages
app/Messages
app/Markup
app/MarkupGoogle
app/PrebuiltBugle
app/Hangouts
app/SoundPicker
app/PrebuiltSoundPicker
app/SoundPickerPrebuilt
app/Contact
app/Contacts
app/ChromePublic
app/Photos
app/PhotosPrebuilt
app/Gallery2
app/SimpleGallery
app/GalleryGoPrebuilt
app/CalculatorGooglePrebuilt
app/CalendarGooglePrebuilt
app/Messaging
app/Messenger
app/messaging
app/RevengeMessages
app/Email
app/Email2
app/Gmail
app/Maps
app/Music
app/Music2
app/RetroMusicPlayer
app/LatinIMEGooglePrebuilt
app/Browser
app/Browser2
app/Jelly
app/Via
app/ViaBrowser
app/LatinIME
app/LatinIMEPrebuilt
priv-app/AudioFX
priv-app/ExtServices
priv-app/Browser
priv-app/Browser2
priv-app/Jelly
priv-app/Via
priv-app/ViaBrowser
priv-app/LatinIME
priv-app/GoogleServicesFramework
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/GmsCore
priv-app/SetupWizard
priv-app/SetupWizardPrebuilt
priv-app/PixelSetupWizard
priv-app/Wellbeing
priv-app/CarrierSetup
priv-app/ConfigUpdater
priv-app/GmsCoreSetupPrebuilt
priv-app/Gallery
priv-app/Gallery2
priv-app/Gallery3d
priv-app/GalleryGo
priv-app/GalleryGoPrebuilt
priv-app/PrebuiltGalleryGo
priv-app/SimpleGallery
priv-app/Photos
priv-app/Contact
priv-app/Contacts
priv-app/GoogleContacts
priv-app/Dialer
priv-app/GoogleDialer
priv-app/Music
priv-app/Music2
priv-app/RetroMusicPlayer
priv-app/crDroidMusic
priv-app/SnapGallery
priv-app/SnapdragonGallery
priv-app/Clock
priv-app/Calendar
priv-app/Calculator
priv-app/Hangouts
priv-app/Messaging
priv-app/Gmail
priv-app/Email
priv-app/Email2
priv-app/Eleven
priv-app/Maps
priv-app/GoogleMaps
priv-app/GoogleMapsPrebuilt
priv-app/MarkupGoogle
priv-app/PrebuiltDeskClock
priv-app/SoundPicker
priv-app/SoundPickerPrebuilt
priv-app/PrebuiltSoundPicker
priv-app/Turbo
priv-app/TurboPrebuilt
priv-app/Wallpaper
priv-app/Wallpapers
priv-app/WallpaperPrebuilt
priv-app/WallpapersPrebuilt
priv-app/WallpapersGooglePrebuilt
priv-app/WallpaperGooglePrebuilt
priv-app/DeviceHealthService
priv-app/AndroidPlatformServices
priv-app/LatinIMEGooglePrebuilt
app/Snap
app/Camera2
app/SimpleCamera
priv-app/Snap
priv-app/Camera2
priv-app/SimpleCamera
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
    done
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}

make_addon_basic_29() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/GoogleExtShared/GoogleExtShared.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/MarkupGoogle/MarkupGoogle.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/permissions/split-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
EOF
}

rm_list="
app/ExtShared
app/FaceLock
app/GoogleExtShared
app/GoogleContactSyncAdapter
priv-app/ExtServices
priv-app/AndroidPlatformServices
priv-app/GoogleServicesFramework
priv-app/GmsCoreSetupPrebuilt
priv-app/GmsCore
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/Phonesky
priv-app/Wellbeing
priv-app/WellbeingGooglePrebuilt
priv-app/WellbeingPrebuilt
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
      rm -rf $SYS/product/$f
    done
    
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}

make_addon_full_29() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/CalculatorGooglePrebuilt/CalculatorGooglePrebuilt.apk
app/CalendarGooglePrebuilt/CalendarGooglePrebuilt.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleExtShared/GoogleExtShared.apk
app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/MarkupGoogle/MarkupGoogle.apk
app/Photos/Photos.apk
app/PrebuiltBugle/PrebuiltBugle.apk
app/PrebuiltDeskClockGoogle/PrebuiltDeskClockGoogle.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/WallpaperPickerGooglePrebuilt/WallpaperPickerGooglePrebuilt.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
priv-app/GoogleContacts/GoogleContacts.apk
priv-app/GoogleDialer/GoogleDialer.apk
priv-app/Turbo/Turbo.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/permissions/split-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
lib64/libjni_latinimegoogle.so
lib64/libbarhopper.so
product/overlay/GoogleDialerOverlay.apk
EOF
}

rm_list="
app/AudioFX
app/ExtShared
app/Etar
app/FaceLock
app/Clock
app/DeskClock
app/DashClock
app/PrebuiltDeskClock
app/Calculator
app/Calculator2
app/ExactCalculator
app/RevengeOSCalculator
app/Calendar
app/CalendarPrebuilt
app/Eleven
app/message
app/messages
app/Messages
app/Markup
app/MarkupGoogle
app/PrebuiltBugle
app/Hangouts
app/SoundPicker
app/PrebuiltSoundPicker
app/SoundPickerPrebuilt
app/Contact
app/Contacts
app/ChromePublic
app/Photos
app/PhotosPrebuilt
app/Gallery2
app/SimpleGallery
app/GalleryGoPrebuilt
app/CalculatorGooglePrebuilt
app/CalendarGooglePrebuilt
app/Messaging
app/Messenger
app/messaging
app/RevengeMessages
app/Email
app/Email2
app/Gmail
app/Maps
app/Music
app/Music2
app/RetroMusicPlayer
app/LatinIMEGooglePrebuilt
app/Browser
app/Browser2
app/Jelly
app/Via
app/ViaBrowser
app/LatinIME
app/LatinIMEPrebuilt
priv-app/AudioFX
priv-app/ExtServices
priv-app/Browser
priv-app/Browser2
priv-app/Jelly
priv-app/Via
priv-app/ViaBrowser
priv-app/LatinIME
priv-app/GoogleServicesFramework
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/GmsCore
priv-app/SetupWizard
priv-app/SetupWizardPrebuilt
priv-app/PixelSetupWizard
priv-app/Wellbeing
priv-app/CarrierSetup
priv-app/ConfigUpdater
priv-app/GmsCoreSetupPrebuilt
priv-app/Gallery
priv-app/Gallery2
priv-app/Gallery3d
priv-app/GalleryGo
priv-app/GalleryGoPrebuilt
priv-app/PrebuiltGalleryGo
priv-app/SimpleGallery
priv-app/Photos
priv-app/Contact
priv-app/Contacts
priv-app/GoogleContacts
priv-app/Dialer
priv-app/GoogleDialer
priv-app/Music
priv-app/Music2
priv-app/RetroMusicPlayer
priv-app/crDroidMusic
priv-app/SnapGallery
priv-app/SnapdragonGallery
priv-app/Clock
priv-app/Calendar
priv-app/Calculator
priv-app/Hangouts
priv-app/Messaging
priv-app/Gmail
priv-app/Email
priv-app/Email2
priv-app/Eleven
priv-app/Maps
priv-app/GoogleMaps
priv-app/GoogleMapsPrebuilt
priv-app/MarkupGoogle
priv-app/PrebuiltDeskClock
priv-app/SoundPicker
priv-app/SoundPickerPrebuilt
priv-app/PrebuiltSoundPicker
priv-app/Turbo
priv-app/TurboPrebuilt
priv-app/Wallpaper
priv-app/Wallpapers
priv-app/WallpaperPrebuilt
priv-app/WallpapersPrebuilt
priv-app/WallpapersGooglePrebuilt
priv-app/WallpaperGooglePrebuilt
priv-app/DeviceHealthService
priv-app/AndroidPlatformServices
priv-app/LatinIMEGooglePrebuilt
app/Snap
app/Camera2
app/SimpleCamera
priv-app/Snap
priv-app/Camera2
priv-app/SimpleCamera
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
      rm -rf $SYS/product/$f
    done
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}

make_addon_basic_30() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/GoogleExtShared/GoogleExtShared.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/MarkupGoogle/MarkupGoogle.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
EOF
}

rm_list="
app/ExtShared
app/FaceLock
app/GoogleExtShared
app/GoogleContactSyncAdapter
priv-app/ExtServices
priv-app/AndroidPlatformServices
priv-app/GoogleServicesFramework
priv-app/GmsCoreSetupPrebuilt
priv-app/GmsCore
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/Phonesky
priv-app/Wellbeing
priv-app/WellbeingGooglePrebuilt
priv-app/WellbeingPrebuilt
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
      rm -rf $SYS/product/$f
      rm -rf $SYS/system_ext/$f
    done
    
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}

make_addon_full_30() {
  echo ">>> Creating addon.d survival script"
  echo '#!/sbin/sh
# 
# ADDOND_VERSION=2
# 
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

list_files() {
cat <<EOF
app/CalculatorGooglePrebuilt/CalculatorGooglePrebuilt.apk
app/CalendarGooglePrebuilt/CalendarGooglePrebuilt.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleExtShared/GoogleExtShared.apk
app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk
app/GoogleLocationHistory/GoogleLocationHistory.apk
app/MarkupGoogle/MarkupGoogle.apk
app/Photos/Photos.apk
app/PrebuiltBugle/PrebuiltBugle.apk
app/PrebuiltDeskClockGoogle/PrebuiltDeskClockGoogle.apk
app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk
app/WallpaperPickerGooglePrebuilt/WallpaperPickerGooglePrebuilt.apk
priv-app/GoogleExtServices/GoogleExtServices.apk
priv-app/CarrierSetup/CarrierSetup.apk
priv-app/ConfigUpdater/ConfigUpdater.apk
priv-app/GmsCoreSetupPrebuilt/GmsCoreSetupPrebuilt.apk
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk
priv-app/GoogleRestore/GoogleRestore.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/SetupWizard/SetupWizard.apk
priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk
priv-app/GoogleContacts/GoogleContacts.apk
priv-app/GoogleDialer/GoogleDialer.apk
priv-app/Turbo/Turbo.apk
etc/default-permissions/default-permissions.xml
etc/default-permissions/opengapps-permissions.xml
etc/permissions/com.google.android.dialer.support.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/privapp-permissions-google.xml
etc/preferred-apps/google.xml
etc/sysconfig/dialer_experience.xml
etc/sysconfig/google-hiddenapi-package-whitelist.xml
etc/sysconfig/google.xml
etc/sysconfig/nexus.xml
etc/sysconfig/pixel_2018_exclusive.xml
etc/sysconfig/pixel_experience_2017.xml
etc/sysconfig/pixel_experience_2018.xml
etc/sysconfig/google_build.xml
etc/sysconfig/google_exclusives_enable.xml
etc/flame.prop
framework/com.google.android.dialer.support.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
app/MarkupGoogle/lib/arm64/libsketchology_native.so
lib64/libjni_latinimegoogle.so
lib64/libbarhopper.so
product/overlay/GoogleDialerOverlay.apk
EOF
}

rm_list="
app/AudioFX
app/ExtShared
app/Etar
app/FaceLock
app/Clock
app/DeskClock
app/DashClock
app/PrebuiltDeskClock
app/Calculator
app/Calculator2
app/ExactCalculator
app/RevengeOSCalculator
app/Calendar
app/CalendarPrebuilt
app/Eleven
app/message
app/messages
app/Messages
app/Markup
app/MarkupGoogle
app/PrebuiltBugle
app/Hangouts
app/SoundPicker
app/PrebuiltSoundPicker
app/SoundPickerPrebuilt
app/Contact
app/Contacts
app/ChromePublic
app/Photos
app/PhotosPrebuilt
app/Gallery2
app/SimpleGallery
app/GalleryGoPrebuilt
app/CalculatorGooglePrebuilt
app/CalendarGooglePrebuilt
app/Messaging
app/Messenger
app/messaging
app/RevengeMessages
app/Email
app/Email2
app/Gmail
app/Maps
app/Music
app/Music2
app/RetroMusicPlayer
app/LatinIMEGooglePrebuilt
app/Browser
app/Browser2
app/Jelly
app/Via
app/ViaBrowser
app/LatinIME
app/LatinIMEPrebuilt
priv-app/AudioFX
priv-app/ExtServices
priv-app/Browser
priv-app/Browser2
priv-app/Jelly
priv-app/Via
priv-app/ViaBrowser
priv-app/LatinIME
priv-app/GoogleServicesFramework
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/GmsCore
priv-app/SetupWizard
priv-app/SetupWizardPrebuilt
priv-app/PixelSetupWizard
priv-app/Wellbeing
priv-app/CarrierSetup
priv-app/ConfigUpdater
priv-app/GmsCoreSetupPrebuilt
priv-app/Gallery
priv-app/Gallery2
priv-app/Gallery3d
priv-app/GalleryGo
priv-app/GalleryGoPrebuilt
priv-app/PrebuiltGalleryGo
priv-app/SimpleGallery
priv-app/Photos
priv-app/Contact
priv-app/Contacts
priv-app/GoogleContacts
priv-app/Dialer
priv-app/GoogleDialer
priv-app/Music
priv-app/Music2
priv-app/RetroMusicPlayer
priv-app/crDroidMusic
priv-app/SnapGallery
priv-app/SnapdragonGallery
priv-app/Clock
priv-app/Calendar
priv-app/Calculator
priv-app/Hangouts
priv-app/Messaging
priv-app/Gmail
priv-app/Email
priv-app/Email2
priv-app/Eleven
priv-app/Maps
priv-app/GoogleMaps
priv-app/GoogleMapsPrebuilt
priv-app/MarkupGoogle
priv-app/PrebuiltDeskClock
priv-app/SoundPicker
priv-app/SoundPickerPrebuilt
priv-app/PrebuiltSoundPicker
priv-app/Turbo
priv-app/TurboPrebuilt
priv-app/Wallpaper
priv-app/Wallpapers
priv-app/WallpaperPrebuilt
priv-app/WallpapersPrebuilt
priv-app/WallpapersGooglePrebuilt
priv-app/WallpaperGooglePrebuilt
priv-app/DeviceHealthService
priv-app/AndroidPlatformServices
priv-app/LatinIMEGooglePrebuilt
app/Snap
app/Camera2
app/SimpleCamera
priv-app/Snap
priv-app/Camera2
priv-app/SimpleCamera
priv-app/SetupWizard
priv-app/Provision
priv-app/LineageSetupWizard"

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
      rm -rf $SYS/product/$f
      rm -rf $SYS/system_ext/$f
    done
  ;;
  post-restore)
    ##
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
  ;;
esac
' > $ZIP_DIR/addon.d.sh
}