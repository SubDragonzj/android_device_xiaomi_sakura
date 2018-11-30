#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=sakura
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

MK_ROOT="$MY_DIR"/../../..

HELPER="$MK_ROOT"/vendor/mk/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# default to not sanitizing the vendor folder before extraction
clean_vendor=false

while [ "$1" != "" ]; do
    case $1 in
        -p | --path )           shift
                                SRC=$1
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                clean_vendor=false
                                ;;
        -c | --clean-vendor )   clean_vendor=true
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$MK_ROOT" false $clean_vendor

#extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"
#extract "$MY_DIR"/proprietary-files-qc.txt "$SRC" "$SECTION"

BLOB_ROOT="$MK_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

# Hax for camera configs
patchelf --set-soname libicuuc-v27.so $BLOB_ROOT/vendor/lib/libicuuc-v27.so
patchelf --set-soname libminikin-v27.so $BLOB_ROOT/vendor/lib/libminikin-v27.so

patchelf --replace-needed android.frameworks.sensorservice@1.0.so android.frameworks.sensorservice@1.0-v27.so $BLOB_ROOT/vendor/lib/libvidhance_gyro.so
patchelf --replace-needed libminikin.so libminikin-v27.so $BLOB_ROOT/vendor/lib/libMiWatermark.so
patchelf --replace-needed libicuuc.so libicuuc-v27.so $BLOB_ROOT/vendor/lib/libMiWatermark.so

patchelf --replace-needed vendor.qti.hardware.camera.device@1.0_vendor.so vendor.qti.hardware.camera.device@1.0.so $BLOB_ROOT/vendor/bin/hw/android.hardware.camera.provider@2.4-service
patchelf --replace-needed vendor.qti.hardware.camera.device@1.0_vendor.so vendor.qti.hardware.camera.device@1.0.so $BLOB_ROOT/vendor/lib/camera.device@1.0-impl.so
patchelf --replace-needed vendor.qti.hardware.camera.device@1.0_vendor.so vendor.qti.hardware.camera.device@1.0.so $BLOB_ROOT/vendor/lib/hw/android.hardware.camera.provider@2.4-impl.so
patchelf --replace-needed vendor.qti.hardware.camera.device@1.0_vendor.so vendor.qti.hardware.camera.device@1.0.so $BLOB_ROOT/vendor/lib64/camera.device@1.0-impl.so
patchelf --replace-needed vendor.qti.hardware.camera.device@1.0_vendor.so vendor.qti.hardware.camera.device@1.0.so $BLOB_ROOT/vendor/lib64/hw/android.hardware.camera.provider@2.4-impl.so

#"$MY_DIR"/setup-makefiles.sh
