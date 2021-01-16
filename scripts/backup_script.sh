mount_extras() {
  local ab_device=$(getprop ro.build.ab_update)
  local dynamic_partition=$(getprop ro.boot.dynamic_partitions)
  if [ -z "$ab_device" ]; then
    for block in product system_ext vendor; do
      if [ -e /$block ]; then
        if [ "$dynamic_partition" = "true" ]; then
          mount -o ro -t auto /dev/block/mapper/$block /$block 2>/dev/null
          blockdev --setrw /dev/block/mapper/$block 2>/dev/null
          mount -o rw,remount -t auto /dev/block/mapper/$block /$block 2>/dev/null
        else
          mount -o ro -t auto /$block 2>/dev/null
          mount -o rw,remount -t auto /$block 2>/dev/null
        fi
      fi
    done
  fi
}

unmount_extras() {
  umount /product /system_ext /vendor 2>/dev/null
}

if [ -z $backuptool_ab ]; then
  SYS=$S
  TMP=/tmp
else
  SYS=/postinstall/system
  TMP=/postinstall/tmp
fi

case "$1" in
  backup)
    list_files | while read -r FILE DUMMY; do
      backup_file "$S"/"$FILE"
    done
    unmount_extras
  ;;
  restore)
    list_files | while read -r FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file "$S"/"$FILE" "$R"
    done
  ;;
  pre-backup)
    mount_extras
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    mount_extras
    # Remove AOSP apps
    for f in $rm_list; do
      rm -rf $SYS/$f
      rm -rf $SYS/product/$f
      rm -rf $SYS/system_ext/$f
    done
    
  ;;
  post-restore)
    # Create lib symlinks
    if [ -e $SYS/app/MarkupGoogle/MarkupGoogle.apk ]; then
      install -d "$SYS/app/MarkupGoogle/lib/arm64"
      ln -sfn "$SYS/lib64/libsketchology_native.so" "$SYS/app/MarkupGoogle/lib/arm64/libsketchology_native.so"
    fi
    if [ -e $SYS/app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk ]; then
      install -d "$SYS/app/LatinIMEGooglePrebuilt/lib64/arm64"
      ln -sfn "$SYS/lib64/libjni_latinimegoogle.so" "$SYS/app/LatinIMEGooglePrebuilt/lib64/arm64/libjni_latinimegoogle.so"
    fi
    
    # Set permissions
    for i in $(list_files); do
      chown root:root "$SYS/$i"
      chmod 644 "$SYS/$i"
      chmod 755 "$(dirname "$SYS/$i")"
    done
    unmount_extras
    chmod 600 $SYS/build.prop
  ;;
esac
