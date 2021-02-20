#!/sbin/sh
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
# File Name    : installer.sh
###########################################
##
# List of the basic edition gapps files
gapps_list_basic="
CalendarSync
DigitalWellbeing
GooglePackageInstaller
MarkupGoogle
SetupWizard
SoundPickerGoogle"

# List of the full edition gapps files
gapps_list_full="
CalendarSync
DeviceHealthServices
DigitalWellbeing
GoogleClock
GoogleCalendar
GoogleCalculator
GoogleContacts
GoogleDialer
GoogleMessages
GoogleKeyboard
GooglePackageInstaller
GooglePhotos
MarkupGoogle
SetupWizard
SoundPickerGoogle
WallpaperPickerGoogle"

# Pre-installed unnecessary app list
rm_list_basic="
app/ExtShared
app/GoogleContactSyncAdapter
app/GoogleExtShared
app/GoogleLocationHistory
app/SoundPickerGooglePrebuilt
priv-app/AndroidPlatformServices
priv-app/ExtServices
priv-app/GmsCore
priv-app/GmsCoreSetupPrebuilt
priv-app/GooglePackageInstaller
priv-app/GoogleServicesFramework
priv-app/Phonesky
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/SetupWizard
priv-app/Wellbeing
priv-app/WellbeingGooglePrebuilt
priv-app/WellbeingPrebuilt"

rm_list_full="
app/AudioFX
app/Browser
app/Browser2
app/BrowserPrebuilt
app/Calculator
app/Calculator2
app/CalculatorGooglePrebuilt
app/Calendar
app/CalendarGooglePrebuilt
app/CalendarPrebuilt
app/ChromePublic
app/Clock
app/DashClock
app/DeskClock
app/Eleven
app/Email
app/Email2
app/Etar
app/ExactCalculator
app/ExtShared
app/Gallery2
app/GalleryGo
app/GalleryGoPrebuilt
app/GoogleLocationHistory
app/Hangouts
app/Jelly
app/LatinIMEGoogle
app/LatinIMEGooglePrebuilt
app/MarkupGoogle
app/MarkupGooglePrebuilt
app/MarkupPrebuilt
app/Music
app/Music2
app/MusicPrebuilt
app/Photos
app/PhotosPrebuilt
app/PrebuiltBugle
app/PrebuiltDeskClock
app/RetroMusicPlayer
app/RetroMusicPlayerPrebuilt
app/RevengeOSCalculator
app/SimpleCalendar
app/SimpleGallery
app/SoundPickerGooglePrebuilt
app/Via
app/ViaBrowser
app/ViaBrowserPrebuilt
app/ViaPrebuilt
app/WallpaperPickerGoogleRelease
priv-app/AndroidPlafoPlatformServices
priv-app/AudioFX
priv-app/Browser
priv-app/Browser2
priv-app/BrowserPrebuilt
priv-app/Calculator
priv-app/Calendar
priv-app/CarrierSetup
priv-app/Clock
priv-app/ConfigUpdater
priv-app/crDroidMusic
priv-app/DeviceHealthService
priv-app/Eleven
priv-app/Email
priv-app/Email2
priv-app/ExtServices
priv-app/Gallery
priv-app/Gallery2
priv-app/Gallery3d
priv-app/GalleryGo
priv-app/GalleryGoPrebuilt
priv-app/GalleryPrebuilt
priv-app/GmsCore
priv-app/GmsCorePrebuilt
priv-app/GmsCoreSetupPrebuilt
priv-app/GoogleContacts
priv-app/GoogleDialer
priv-app/GooglePackageInstaller
priv-app/GoogleServicesFramework
priv-app/Hangouts
priv-app/Jelly
priv-app/LatinIMEGooglePrebuilt
priv-app/MarkupGoogle
priv-app/MarkupGooglePrebuilt
priv-app/Music
priv-app/Music2
priv-app/MusicPrebuilt
priv-app/Photos
priv-app/PixelSetupWizard
priv-app/PrebuiltDeskClock
priv-app/PrebuiltGalleryGo
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/RetroMusicPlayer
priv-app/RetroMusicPlayerPrebuilt
priv-app/SetupWizard
priv-app/SetupWizardPrebuilt
priv-app/SimpleGallery
priv-app/SnapdragonGallery
priv-app/SnapGallery
priv-app/Turbo
priv-app/TurboPrebuilt
priv-app/Via
priv-app/ViaBrowser
priv-app/ViaBrowserPrebuilt
priv-app/ViaPrebuilt
priv-app/WallpaperGooglePrebuilt
priv-app/WallpaperPickerGoogleRelease
priv-app/WallpapersGooglePrebuilt
priv-app/Wellbeing"

stock_camera="
app/Camera2
app/SimpleCamera
app/Snap
priv-app/Camera2
priv-app/SimpleCamera
priv-app/Snap"

stock_messages="
app/message
app/messages
app/Messages
app/messaging
app/Messaging
app/Messenger
app/QKSMS
app/RevengeMessages
priv-app/messaging
priv-app/Messaging"

stock_soundpicker="
app/PrebuiltSoundPicker
app/SoundPicker
app/SoundPickerPrebuilt
priv-app/PrebuiltSoundPicker
priv-app/SoundPicker
priv-app/SoundPickerPrebuilt"

provision="
app/provision
app/Provision
priv-app/provision
priv-app/Provision"

lineage_setup="
priv-app/LineageSetupWizard"

aosp_dialer="
app/Dialer
priv-app/Dialer"

aosp_contacts="
app/Contact
app/Contacts
priv-app/Contact
priv-app/Contacts"

aosp_keyboard="
app/LatinIME
app/LatinIMEPrebuilt
priv-app/LatinIME
priv-app/LatinIMEPrebuilt"

aosp_packageinstaller="
priv-app/PackageInstaller"

ui_print() {
  echo "ui_print $1
    ui_print" >> $OUTFD
}

set_progress() { echo "set_progress $1" >> $OUTFD; }

is_mounted() { mount | grep -q " $1 "; }

setup_mountpoint() {
  test -L $1 && mv -f $1 ${1}_link
  if [ ! -d $1 ]; then
    rm -f $1
    mkdir $1
  fi
}

recovery_actions() {
  OLD_LD_LIB=$LD_LIBRARY_PATH
  OLD_LD_PRE=$LD_PRELOAD
  OLD_LD_CFG=$LD_CONFIG_FILE
  unset LD_LIBRARY_PATH
  unset LD_PRELOAD
  unset LD_CONFIG_FILE
}

recovery_cleanup() {
  [ -z $OLD_LD_LIB ] || export LD_LIBRARY_PATH=$OLD_LD_LIB
  [ -z $OLD_LD_PRE ] || export LD_PRELOAD=$OLD_LD_PRE
  [ -z $OLD_LD_CFG ] || export LD_CONFIG_FILE=$OLD_LD_CFG
}

clean_up() {
  rm -rf /tmp/flamegapps
  rm -rf /tmp/config.prop
  rm -rf /tmp/flame.prop
  rm -rf /tmp/tar_gapps
  rm -rf /tmp/unzip_dir
  rm -rf $backup_script
  rm -rf $temp_backup_script
}

path_info() {
  ls / > "$log_dir/rootpathinfo.txt"
  ls -RZl $SYSTEM > "$log_dir/systempathinfo.txt"
  ls -RZl $SYSTEM/product > "$log_dir/productpathinfo.txt" 2>/dev/null
  ls -RZl $SYSTEM/system_ext > "$log_dir/system_extpathinfo.txt" 2>/dev/null
}

space_before() {
  df -h > $log_dir/space_before.txt
}

space_after() {
  df -h > $log_dir/space_after.txt
}

take_logs() {
  ui_print " "
  ui_print "- Copying logs to /sdcard & $zip_dir"
  cp -f $TMP/recovery.log $log_dir/recovery.log
  cd $log_dir
  tar -cz -f "$TMP/flamegapps_debug_logs.tar.gz" *
  cp -f $TMP/flamegapps_debug_logs.tar.gz $zip_dir/flamegapps_debug_logs.tar.gz
  cp -f $TMP/flamegapps_debug_logs.tar.gz /sdcard/flamegapps_debug_logs.tar.gz
  cd /
  rm -rf $TMP/flamegapps_debug_logs.tar.gz
}

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  # check known .prop files using get_file_prop
  for f in $PROPFILES; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break # if an entry has been found, break out of the loop
      fi
    fi
  done
  # if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi
}

remove_fd() {
  local LIST="$1"
  for f in $LIST; do
    rm -rf $SYSTEM/$f
    if [ "$rom_sdk" -gt "28" ]; then
      rm -rf $SYSTEM/product/$f
    fi
    if [ "$rom_sdk" -gt "29" ]; then
      rm -rf $SYSTEM/system_ext/$f
    fi
  done
}

abort() {
  sleep 1
  ui_print "- Aborting..."
  sleep 3
  path_info
  unmount_all
  take_logs
  clean_up
  recovery_cleanup
  exit 1;
}

exit_all() {
  sleep 0.5
  path_info
  space_after
  unmount_all
  sleep 0.5
  set_progress 0.90
  take_logs
  clean_up
  recovery_cleanup
  sleep 0.5
  ui_print " "
  ui_print "- Installation Successful..!"
  ui_print " "
  set_progress 1.00
  exit 0;
}

mount_apex() {
  # For reference, check: https://github.com/osm0sis/AnyKernel3/blob/master/META-INF/com/google/android/update-binary
  if [ -d $SYSTEM/apex ]; then
    local apex dest loop minorx num
    setup_mountpoint /apex
    test -e /dev/block/loop1 && minorx=$(ls -l /dev/block/loop1 | awk '{ print $6 }') || minorx=1
    num=0
    for apex in $SYSTEM/apex/*; do
      dest=/apex/$(basename $apex .apex)
      test "$dest" = /apex/com.android.runtime.release && dest=/apex/com.android.runtime
      mkdir -p $dest
      case $apex in
        *.apex)
          unzip -qo $apex apex_payload.img -d /apex
          mv -f /apex/apex_payload.img $dest.img
          mount -t ext4 -o ro,noatime $dest.img $dest 2>/dev/null
          if [ $? != 0 ]; then
            while [ $num -lt 64 ]; do
              loop=/dev/block/loop$num
              (mknod $loop b 7 $((num * minorx))
              losetup $loop $dest.img) 2>/dev/null
              num=$((num + 1))
              losetup $loop | grep -q $dest.img && break
            done
            mount -t ext4 -o ro,loop,noatime $loop $dest
            if [ $? != 0 ]; then
              losetup -d $loop 2>/dev/null
            fi
          fi
        ;;
        *) mount -o bind $apex $dest;;
      esac
    done
    export ANDROID_RUNTIME_ROOT=/apex/com.android.runtime
    export ANDROID_TZDATA_ROOT=/apex/com.android.tzdata
    export BOOTCLASSPATH=/apex/com.android.runtime/javalib/core-oj.jar:/apex/com.android.runtime/javalib/core-libart.jar:/apex/com.android.runtime/javalib/okhttp.jar:/apex/com.android.runtime/javalib/bouncycastle.jar:/apex/com.android.runtime/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/android.test.base.jar:/apex/com.android.conscrypt/javalib/conscrypt.jar:/apex/com.android.media/javalib/updatable-media.jar
  fi
}

unmount_apex() {
  if [ -d $SYSTEM/apex ]; then
    local dest loop
    for dest in $(find /apex -type d -mindepth 1 -maxdepth 1); do
      if [ -f $dest.img ]; then
        loop=$(mount | grep $dest | cut -d" " -f1)
      fi
      (umount -l $dest
      losetup -d $loop) 2>/dev/null
    done
    rm -rf /apex 2>/dev/null
    unset ANDROID_RUNTIME_ROOT ANDROID_TZDATA_ROOT BOOTCLASSPATH
  fi
}

mount_all() {
  set_progress 0.10
  ui_print "- Mounting partitions"
  sleep 1
  dynamic_partitions=`getprop ro.boot.dynamic_partitions`
  SLOT=`getprop ro.boot.slot_suffix`
  [ ! -z "$SLOT" ] && ui_print "- Current boot slot: $SLOT"

  if [ -n "$(cat /etc/fstab | grep /system_root)" ]; then
    MOUNT_POINT=/system_root
  else
    MOUNT_POINT=/system
  fi

  for p in "/cache" "/data" "$MOUNT_POINT" "/product" "/system_ext" "/vendor"; do
    if [ -d "$p" ] && grep -q "$p" "/etc/fstab" && ! is_mounted "$p"; then
      mount "$p"
    fi
  done

  if [ "$dynamic_partitions" = "true" ]; then
    ui_print "- Dynamic partition detected"
    for m in "/system" "/system_root" "/product" "/system_ext" "/vendor"; do
      (umount "$m"
      umount -l "$m") 2>/dev/null
    done
    mount -o ro -t auto /dev/block/mapper/system$SLOT /system_root
    mount -o ro -t auto /dev/block/mapper/vendor$SLOT /vendor 2>/dev/null
    mount -o ro -t auto /dev/block/mapper/product$SLOT /product 2>/dev/null
    mount -o ro -t auto /dev/block/mapper/system_ext$SLOT /system_ext 2>/dev/null
  else
    mount -o ro -t auto /dev/block/bootdevice/by-name/system$SLOT $MOUNT_POINT 2>/dev/null
  fi

  if [ "$dynamic_partitions" = "true" ]; then
    for block in system vendor product system_ext; do
      for slot in "" _a _b; do
        blockdev --setrw /dev/block/mapper/$block$slot 2>/dev/null
      done
    done
    mount -o rw,remount -t auto /dev/block/mapper/system$SLOT /system_root
    mount -o rw,remount -t auto /dev/block/mapper/vendor$SLOT /vendor 2>/dev/null
    mount -o rw,remount -t auto /dev/block/mapper/product$SLOT /product 2>/dev/null
    mount -o rw,remount -t auto /dev/block/mapper/system_ext$SLOT /system_ext 2>/dev/null
  else
    mount -o rw,remount -t auto $MOUNT_POINT
    mount -o rw,remount -t auto /vendor 2>/dev/null
    mount -o rw,remount -t auto /product 2>/dev/null
    mount -o rw,remount -t auto /system_ext 2>/dev/null
  fi

  sleep 0.3
  
  if is_mounted /system_root; then
    ui_print "- Device is system-as-root"
    if [ -f /system_root/build.prop ]; then
      mount -o bind /system_root /system
      SYSTEM=/system_root
      ui_print "- System is $SYSTEM"
    else
      mount -o bind /system_root/system /system
      SYSTEM=/system_root/system
      ui_print "- System is $SYSTEM"
    fi
  elif is_mounted /system; then
    if [ -f /system/build.prop ]; then
      SYSTEM=/system
      ui_print "- System is $SYSTEM"
    elif [ -f /system/system/build.prop ]; then
      ui_print "- Device is system-as-root"
      mkdir -p /system_root
      mount --move /system /system_root
      mount -o bind /system_root/system /system
      SYSTEM=/system_root/system
      ui_print "- System is /system/system"
    fi
  else
    ui_print "- Failed to mount/detect system"
    abort
  fi
  mount_apex
}

unmount_all() {
  unmount_apex
  ui_print " "
  ui_print "- Unmounting partitions"
  for m in "/system" "/system_root" "/product" "/system_ext" "/vendor"; do
    if [ -e $m ]; then
      (umount $m
      umount -l $m) 2>/dev/null
    fi
  done
}

mount -o bind /dev/urandom /dev/random
unmount_all
mount_all

recovery_actions

PROPFILES="$SYSTEM/build.prop $TMP/flame.prop"
CORE_DIR="$TMP/tar_core"
GAPPS_DIR="$TMP/tar_gapps"
UNZIP_FOLDER="$TMP/unzip_dir"
EX_SYSTEM="$UNZIP_FOLDER/system"
zip_dir="$(dirname "$ZIPFILE")"
log_dir="$TMP/flamegapps/logs"
flame_log="$log_dir/installation_log.txt"
build_info="$log_dir/build_info.prop"
backup_script="$TMP/backup_script.sh"
temp_backup_script="$TMP/temp_backup_script.sh"
overlay_installed="false"
mkdir -p $UNZIP_FOLDER
mkdir -p $log_dir
space_before

# Get ROM, device & package information
flame_android=`get_prop ro.flame.android`
flame_sdk=`get_prop ro.flame.sdk`
flame_arch=`get_prop ro.flame.arch`
flame_edition=`get_prop ro.flame.edition`
rom_version=`get_prop ro.build.version.release`
rom_sdk=`get_prop ro.build.version.sdk`
device_architecture=`get_prop ro.product.cpu.abilist`
device_code=`get_prop ro.product.device`

if [ -z "$device_architecture" ]; then
  device_architecture=`get_prop ro.product.cpu.abi`
fi

case "$device_architecture" in
  *x86_64*) arch="x86_64"
    ;;
  *x86*) arch="x86"
    ;;
  *arm64*) arch="arm64"
    ;;
  *armeabi*) arch="arm"
    ;;
  *) arch="unknown"
    ;;
esac

echo ------------------------------------------------------------------- >> $flame_log
(echo "  --------------- FlameGApps Installation Logs ---------------"
echo "- Mount Point: $MOUNT_POINT"
echo "- Current slot: $SLOT"
echo "- Dynamic partition: $dynamic_partitions"
echo "- Flame version: $flame_android"
echo "- Flame SDK: $flame_sdk"
echo "- Flame ARCH: $flame_arch"
echo "- ROM version: $rom_version"
echo "- ROM SDK: $rom_sdk"
echo "- Device ARCH: $device_architecture ($arch)"
echo "- Device code: $device_code") >> $flame_log
cat $SYSTEM/build.prop > $build_info
cat $TMP/flame.prop >> $build_info

set_progress 0.20
sleep 1
ui_print " "
ui_print "- Android: $rom_version, SDK: $rom_sdk, ARCH: $arch"
sleep 1

if [ ! "$rom_sdk" = "$flame_sdk" ]; then
  ui_print " "
  ui_print "****************** WARNING *******************"
  ui_print " "
  ui_print "! Wrong android version detected"
  sleep 0.5
  ui_print "This package is for android: $flame_android only"
  sleep 0.5
  ui_print "Your ROM is Android: $rom_version"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  ui_print " "
  abort
fi

if [ ! "$arch" = "$flame_arch" ]; then
  ui_print " "
  ui_print "****************** WARNING *******************"
  ui_print " "
  ui_print "! Wrong device architecture detected"
  sleep 0.5
  ui_print "This package is for device: $flame_arch only"
  sleep 0.5
  ui_print "Your device is: $arch"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  ui_print " "
  abort
fi

# Remove pre-installed unnecessary system apps
ui_print " "
ui_print "- Removing unnecessary system apps"
ui_print " "
set_progress 0.30
sleep 0.5
if [ "$flame_edition" = "basic" ]; then
  remove_fd "$rm_list_basic"
  echo -e "\n- Removing basic list files" >> $flame_log
elif [ "$flame_edition" = "full" ]; then
  remove_fd "$rm_list_full"
  echo -e "\n- Removing full list files" >> $flame_log
else
  ui_print "****************** WARNING *******************"
  ui_print " "
  sleep 0.5
  echo "- Failed to detect edition type" >> $flame_log
  ui_print "! Failed to detect FlameGApps edition type"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  abort
fi

check_gapps_config() {
  if [ -e $zip_dir/flamegapps-config.txt ] || [ -e /sdcard/flamegapps-config.txt ]; then
    ui_print "- GApps config detected"
    ui_print " "
    for p in $zip_dir /sdcard; do
      if [ -e $p/flamegapps-config.txt ] && [ ! -e $TMP/config.prop ]; then
        cp -f $p/flamegapps-config.txt $TMP/config.prop
        cp -f $TMP/config.prop $log_dir/config.prop
        chmod 0644 $TMP/config.prop
        gapps_config="true"
      fi
    done
  fi
}

install_core() {
  set_progress 0.50
  ui_print "- Installing Core GApps"
  ui_print " "
  unzip -o "$ZIPFILE" 'tar_core/*' -d $TMP
  tar -xf "$CORE_DIR/Core.tar.xz" -C $UNZIP_FOLDER
  file_list="$(find "$EX_SYSTEM/" -mindepth 1 -type f | cut -d/ -f5-)"
  dir_list="$(find "$EX_SYSTEM/" -mindepth 1 -type d | cut -d/ -f5-)"
  for file in $file_list; do
    install -D "$EX_SYSTEM/${file}" "$SYSTEM/${file}"
    chcon -h u:object_r:system_file:s0 "$SYSTEM/${file}"
    chmod 0644 "$SYSTEM/${file}"
    backup_file_list="$backup_file_list\n${file}"
  done
  for dir in $dir_list; do
    chcon -h u:object_r:system_file:s0 "$SYSTEM/${dir}"
    chmod 0755 "$SYSTEM/${dir}"
  done
  rm -rf $CORE_DIR
  rm -rf $UNZIP_FOLDER/*
}

install_gapps() {
  set_progress 0.70
  for g in $gapps_list; do
    local gapps=""
    if [ "$gapps_config" = "true" ]; then
      if [ "$(get_file_prop $TMP/config.prop "$g")" -eq "1" ]; then
        gapps="$g"
      else
        ui_print "- Skipping $g"
      fi
    else
      gapps="$g"
    fi
    if [ -n "$gapps" ]; then
      ui_print "- Installing $gapps"
      unzip -o "$ZIPFILE" "tar_gapps/$gapps.tar.xz" -d $TMP
      tar -xf "$GAPPS_DIR/$gapps.tar.xz" -C $UNZIP_FOLDER
      rm -rf $GAPPS_DIR/$gapps.tar.xz
      file_list="$(find "$EX_SYSTEM/" -mindepth 1 -type f | cut -d/ -f5-)"
      dir_list="$(find "$EX_SYSTEM/" -mindepth 1 -type d | cut -d/ -f5-)"
      for file in $file_list; do
        install -D "$EX_SYSTEM/${file}" "$SYSTEM/${file}"
        if echo "${file}" | grep -q "Overlay.apk"; then
          overlay_installed="true"
          chcon -h u:object_r:vendor_overlay_file:s0 "$SYSTEM/${file}"
        else
          chcon -h u:object_r:system_file:s0 "$SYSTEM/${file}"
        fi
        chmod 0644 "$SYSTEM/${file}"
        backup_file_list="$backup_file_list\n${file}"
      done
      for dir in $dir_list; do
        chcon -h u:object_r:system_file:s0 "$SYSTEM/${dir}"
        chmod 0755 "$SYSTEM/${dir}"
      done
      rm -rf $UNZIP_FOLDER/*
    fi
  done
}

# Ensure gapps list
[ "$flame_edition" = "basic" ] && gapps_list="$gapps_list_basic" || gapps_list="$gapps_list_full"

# Check for config
check_gapps_config

# Install core gapps files
echo -e "\n- Installing core gapps files" >> $flame_log
install_core >> $flame_log

# Install gapps files
echo -e "\n- Installing gapps files" >> $flame_log
install_gapps >> $flame_log

echo -e "\n                 Installation Finished            " >> $flame_log
echo ----------------------------------------------------------------- >> $flame_log

sleep 0.5
set_progress 0.80
ui_print " "
ui_print "- Performing other tasks"
# Change context of /product/overlay dir
[ "$overlay_installed" = "true" ] && chcon -h u:object_r:vendor_overlay_file:s0 "$SYSTEM/product/overlay"

# Check for stock cam removal
if [ ! "$flame_edition" = "basic" ] && [ "$gapps_config" = "true" ] && [ "$(get_file_prop $TMP/config.prop "ro.keep.snap")" -eq "1" ]; then
  remove_camera="false"
elif [ "$flame_edition" = "basic" ]; then
  remove_camera="false"
else
  remove_camera="true"
  remove_fd "$stock_camera"
fi

# Delete AOSP PackageInstaller if Google PackageInstaller is present
if [ -e $SYSTEM/priv-app/GooglePackageInstaller/GooglePackageInstaller.apk ]; then
  google_packageinstaller="true"
  remove_fd "$aosp_packageinstaller"
fi

# Delete provision and lineage setupwizard if Google SetupWizard is present
if [ -e $SYSTEM/priv-app/SetupWizard/SetupWizard.apk ]; then
  google_setupwizard="true"
  remove_fd "$provision"
  remove_fd "$lineage_setup"
fi

# Delete AOSP Dialer if Google Dialer is present
if [ -e $SYSTEM/priv-app/GoogleDialer/GoogleDialer.apk ]; then
  google_dialer="true"
  remove_fd "$aosp_dialer"
  chcon -h u:object_r:vendor_overlay_file:s0 "$SYSTEM/product/overlay/GoogleDialerOverlay.apk"
fi

# Delete AOSP Contacts if Google Contacts is present
if [ -e $SYSTEM/priv-app/GoogleContacts/GoogleContacts.apk ]; then
  google_contacts="true"
  remove_fd "$aosp_contacts"
fi

# Delete AOSP/other Meassages if Google Messages is present
if [ -e $SYSTEM/app/PrebuiltBugle/PrebuiltBugle.apk ]; then
  google_messages="true"
  remove_fd "$stock_messages"
fi

# Delete AOSP Keyboard if Gboard is present
if [ -e $SYSTEM/app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk ]; then
  google_keyboard="true"
  remove_fd "$aosp_keyboard"
fi

# Delete stock SoundPicker if Google SoundPicker is present
if [ -e $SYSTEM/app/SoundPickerGooglePrebuilt/SoundPickerGooglePrebuilt.apk ]; then
  google_soundpicker="true"
  remove_fd "$stock_soundpicker"
fi

# Install addon.d script
if [ -d $SYSTEM/addon.d ]; then
  rm -rf $SYSTEM/addon.d/69-flame.sh
  if [ "$gapps_config" = "true" ] && [ "$(get_file_prop $TMP/config.prop "ro.skip.backup_script")" -eq "1" ]; then
    echo -e "\nSkipping addon.d script installation" >> $flame_log
  else
    echo -e "\nInstalling addon.d script" >> $flame_log
    echo '#!/sbin/sh
#
# ADDOND_VERSION=2
#
# /system/addon.d/69-flame.sh
#
. /tmp/backuptool.functions

rm_list="' > $temp_backup_script
    if [ "$remove_camera" = "true" ]; then
      echo "$stock_camera" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_packageinstaller" = "true" ]; then
      echo "$aosp_packageinstaller" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_setupwizard" = "true" ]; then
      echo "$provision" | sed '/^$/d' >> $temp_backup_script
      echo "$lineage_setup" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_dialer" = "true" ]; then
      echo "$aosp_dialer" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_contacts" = "true" ]; then
      echo "$aosp_contacts" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_messages" = "true" ]; then
      echo "$stock_messages" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_keyboard" = "true" ]; then
      echo "$aosp_keyboard" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$google_soundpicker" = "true" ]; then
      echo "$stock_soundpicker" | sed '/^$/d' >> $temp_backup_script
    fi
    if [ "$flame_edition" = "basic" ]; then
      echo -n "$rm_list_basic" | sed '/^$/d' >> $temp_backup_script
    elif [ "$flame_edition" = "full" ]; then
      echo -n "$rm_list_full" | sed '/^$/d' >> $temp_backup_script
    fi
    echo -e '"\n\nlist_files() {
cat <<EOF' >> $temp_backup_script
    echo -e "$backup_file_list" | sed '/^$/d' | sort >> $temp_backup_script
    echo -e 'EOF
}\n' >> $temp_backup_script
    cat $temp_backup_script > $TMP/69-flame.sh
    cat $backup_script >> $TMP/69-flame.sh
    cp -f $TMP/69-flame.sh $SYSTEM/addon.d/69-flame.sh
    chcon -h u:object_r:system_file:s0 "$SYSTEM/addon.d/69-flame.sh"
    chmod 0755 "$SYSTEM/addon.d/69-flame.sh"
  fi
fi

# Create lib symlinks
if [ -e $SYSTEM/app/MarkupGoogle/MarkupGoogle.apk ]; then
  install -d "$SYSTEM/app/MarkupGoogle/lib/arm64"
  ln -sfn "/system/lib64/libsketchology_native.so" "/system/app/MarkupGoogle/lib/arm64/libsketchology_native.so"
fi
if [ -e $SYSTEM/app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk ]; then
  install -d "$SYSTEM/app/LatinIMEGooglePrebuilt/lib64/arm64"
  ln -sfn "/system/lib64/libjni_latinimegoogle.so" "/system/app/LatinIMEGooglePrebuilt/lib64/arm64/libjni_latinimegoogle.so"
fi

# Install flame.prop
rm -rf $SYSTEM/etc/flame.prop
cp -f $TMP/flame.prop $SYSTEM/etc/flame.prop
chcon -h u:object_r:system_file:s0 "$SYSTEM/etc/flame.prop"
chmod 0644 "$SYSTEM/etc/flame.prop"

# Set Google Dialer/Phone as default phone app if it is present
if [ -e $SYSTEM/priv-app/GoogleDialer/GoogleDialer.apk ]; then
  # set Google Dialer as default; based on the work of osm0sis @ xda-developers
  setver="122"  # lowest version in MM, tagged at 6.0.0
  setsec="/data/system/users/0/settings_secure.xml"
  if [ -f "$setsec" ]; then
    if grep -q 'dialer_default_application' "$setsec"; then
      if ! grep -q 'dialer_default_application" value="com.google.android.dialer' "$setsec"; then
        curentry="$(grep -o 'dialer_default_application" value=.*$' "$setsec")"
        newentry='dialer_default_application" value="com.google.android.dialer" package="android" />\r'
        sed -i "s;${curentry};${newentry};" "$setsec"
      fi
    else
      max="0"
      for i in $(grep -o 'id=.*$' "$setsec" | cut -d '"' -f 2); do
        test "$i" -gt "$max" && max="$i"
      done
      entry='<setting id="'"$((max + 1))"'" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r'
      sed -i "/<settings version=\"/a\ \ ${entry}" "$setsec"
    fi
  else
    if [ ! -d "/data/system/users/0" ]; then
      install -d "/data/system/users/0"
      chown -R 1000:1000 "/data/system"
      chmod -R 775 "/data/system"
      chmod 700 "/data/system/users/0"
    fi
    { echo -e "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>\r";
    echo -e '<settings version="'$setver'">\r';
    echo -e '  <setting id="1" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r';
    echo -e '</settings>'; } > "$setsec"
  fi
  chown 1000:1000 "$setsec"
  chmod 600 "$setsec"
fi

exit_all;
