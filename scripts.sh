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

make_flame_prop() {
  echo ">>> Creating flame.prop"
  echo -e '\n# FlameGApps prop file
ro.flame.android='$ANDROID'
ro.flame.sdk='$SDK'
ro.flame.arch='$ARCH'
ro.flame.edition='$EDITION'
ro.flame.build_date='$DATE'
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

for f in busybox-arm installer.sh flame.prop backup_script.sh; do
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
