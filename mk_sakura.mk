#
# Copyright (C) 2016 The CyanogenMod Project
#               2017 The LineageOS Project
# Copyright (C) 2018 The MoKee Open Source Project
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

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_o_mr1.mk)

# Inherit some common MoKee stuff
$(call inherit-product, vendor/mk/config/common_full_phone.mk)

# Inherit from sakura device
$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_NAME := mk_sakura
PRODUCT_DEVICE := sakura
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

TARGET_VENDOR_PRODUCT_NAME := sakura

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="sakura-user 9 PKQ1.180917.001 9.2.28 release-keys"
    
BUILD_FINGERPRINT= "xiaomi/sakura/sakura:9/PKQ1.180917.001/9.2.28:user/release-keys"

PRODUCT_SYSTEM_PROPERTY_BLACKLIST += \
    ro.product.model
