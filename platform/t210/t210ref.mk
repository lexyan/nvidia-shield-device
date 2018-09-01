# NVIDIA "T210ref" development system
#
# Copyright (c) 2013-2017 NVIDIA Corporation.  All rights reserved.

$(call inherit-product, device/nvidia/soc/t210/device-t210.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/nvidia/platform/t210/device.mk)
$(call inherit-product, device/nvidia/product/tablet/device.mk)

PRODUCT_NAME := t210ref
PRODUCT_DEVICE := t210
PRODUCT_MODEL := t210ref
PRODUCT_MANUFACTURER := NVIDIA
PRODUCT_BRAND := nvidia

ifeq ($(PLATFORM_IS_AFTER_M),)
HOST_PREFER_32_BIT := true
endif

TARGET_SYSTEM_PROP    += device/nvidia/platform/t210/t210ref.prop

# set default kernel to K4.4 if not set
KERNEL_PATH ?= $(CURDIR)/kernel/kernel-4.4

## Values of PRODUCT_NAME and PRODUCT_DEVICE are mangeled before it can be
## used because of call to inherits, store their values to
## use later in this file below
_product_name := $(strip $(PRODUCT_NAME))
_product_device := $(strip $(PRODUCT_DEVICE))

# for Jetpack APK
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/t210ref.vendor.libraries.android.txt:vendor/etc/public.libraries.txt

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/../../common/init.cal.rc:root/init.cal.rc \
    $(LOCAL_PATH)/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(call add-to-product-copy-files-if-exists, vendor/nvidia/tegra/3rdparty/broadcom/gps/bin/gpsconfig-wf-t210ref.xml:system/etc/gps/gpsconfig.xml) \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml \
    device/nvidia/platform/t210/nvphsd.conf:system/etc/nvphsd.conf

PRODUCT_AAPT_CONFIG += xlarge large

ifeq ($(PLATFORM_IS_AFTER_LOLLIPOP),1)
## Verified_boot
$(call inherit-product,build/target/product/verity.mk)
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/platform/sdhci-tegra.3/by-name/APP
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/platform/sdhci-tegra.3/by-name/vendor

# Adding odm.img
PRODUCT_CUSTOM_IMAGE_MAKEFILES := device/nvidia/platform/t210/odm.mk

PRODUCT_PACKAGES += \
    slideshow \
    verity_warning_images
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml
endif

################################################
# Common for all t210ref
################################################

PRODUCT_PACKAGES += \
        nfc.tegra \
        SoundRecorder

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    $(LOCAL_PATH)/nvcamera.conf:system/etc/nvcamera.conf

# copy config_camera.sh script and camera module definition files that will be used in init.XXXX.rc at boot time
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config_cameras.sh:system/bin/config_cameras.sh \
	$(LOCAL_PATH)/jetson_cv_cameras.def:system/etc/jetson_cv_cameras.def \
	$(LOCAL_PATH)/jetson_e_cameras.def:system/etc/jetson_e_cameras.def \
	$(LOCAL_PATH)/e2220_cameras.def:system/etc/e2220_cameras.def

# copy all possible feature xml files to /system/etc/camera_repo/ folder so that it can be used by config_camera.sh script at boot time.
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.full.xml:system/etc/camera_repo/android.hardware.camera.full.xml \
	frameworks/native/data/etc/android.hardware.camera.external.xml:system/etc/camera_repo/android.hardware.camera.external.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/camera_repo/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.raw.xml:system/etc/camera_repo/android.hardware.camera.raw.xml \
	frameworks/native/data/etc/android.hardware.camera.manual_sensor.xml:system/etc/camera_repo/android.hardware.camera.manual_sensor.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/camera_repo/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/camera_repo/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/camera_repo/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.manual_postprocessing.xml:system/etc/camera_repo/android.hardware.camera.manual_postprocessing.xml

#symlinks
PRODUCT_PACKAGES += \
    camera.autofocus.symlink \
    camera.external.symlink \
    camera.flash-autofocus.symlink \
    camera.front.symlink \
    camera.full.symlink \
    camera.manual_sensor.symlink \
    camera.manual_postprocessing.symlink \
    camera.raw.symlink \
    camera.symlink \
    camera.media.symlink

ifeq ($(NV_ANDROID_MULTIMEDIA_ENHANCEMENTS),TRUE)
PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/media_profiles.xml:system/etc/camera_repo/media_profiles.xml \
  $(LOCAL_PATH)/audio_policy.conf:system/etc/audio_policy.conf
else
PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/media_profiles_noenhance.xml:system/etc/camera_repo/media_profiles.xml \
  $(LOCAL_PATH)/audio_policy_noenhance.conf:system/etc/audio_policy.conf
endif

# jetson's media profiles
PRODUCT_COPY_FILES += \
  $(LOCAL_PATH)/jetson_e_media_profiles.xml:system/etc/camera_repo/jetson_e_media_profiles.xml \
  $(LOCAL_PATH)/jetson_cv_media_profiles.xml:system/etc/camera_repo/jetson_cv_media_profiles.xml \
  $(LOCAL_PATH)/jetson_cv_e3323_media_profiles.xml:system/etc/camera_repo/jetson_cv_e3323_media_profiles.xml \
  $(LOCAL_PATH)/jetson_cv_e3333_media_profiles.xml:system/etc/camera_repo/jetson_cv_e3333_media_profiles.xml \
  $(LOCAL_PATH)/jetson_cv_imx274_media_profiles.xml:system/etc/camera_repo/jetson_cv_imx274_media_profiles.xml \
  $(LOCAL_PATH)/jetson_cv_nocam_media_profiles.xml:system/etc/camera_repo/jetson_cv_nocam_media_profiles.xml \

PRODUCT_COPY_FILES += \
    device/nvidia/platform/t210/nvaudio_conf.xml:system/etc/nvaudio_conf.xml \
    device/nvidia/platform/t210/abca_nvaudio_conf.xml:system/etc/abca_nvaudio_conf.xml \
    device/nvidia/platform/t210/abca_nvaudio_conf.xml:system/etc/abcb_nvaudio_conf.xml

## SKU specific overrides
PRODUCT_PROPERTY_OVERRIDES += ro.radio.noril=true

## Tablet configuration
DEVICE_PACKAGE_OVERLAYS += device/nvidia/product/tablet/overlay-tablet/$(PLATFORM_VERSION_LETTER_CODE)

include device/nvidia/platform/t210/sensors-t210ref.mk
# The following build variables are defined in 'sensors-[platform].mk' file:
#	SENSOR_BUILD_VERSION
#	SENSOR_BUILD_FLAGS
#	SENSOR_FUSION_VENDOR
#	SENSOR_FUSION_VERSION
#	SENSOR_FUSION_BUILD_DIR
#	SENSOR_HAL_API
#	SENSOR_HAL_VERSION
#	SENSOR_HAL_HAL_OS_INTERFACE_SRC
#	SENSOR_HAL_LOCAL_DRIVER_SRC
#	PRODUCT_PROPERTY_OVERRIDES
#	PRODUCT_PACKAGES

# Sharp touch definitions
include device/nvidia/drivers/touchscreen/sharp/BoardConfigSharp.mk

ifeq ($(PLATFORM_VERSION_LETTER_CODE),n)
#Thermal HALs
PRODUCT_PACKAGES += \
    thermal.tegra
endif

PRODUCT_PACKAGES += \
    rp3 \
    slideshow \
    verity_warning_images \
    libnvjni_tinyplanet \
    libnvjni_jpegutil \
    libcom_nvidia_nvcamera_util_NativeUtils \
    libjni_nvmosaic \
    libnvraw_creator


# for v4l2 test
PRODUCT_PACKAGES += \
    v4l2-ctl \
    v4l2-compliance \
    v4l2-dbg \
    media-ctl

#symlinks
PRODUCT_PACKAGES += \
    camera.jnilib1.symlink \
    camera.jnilib2.symlink \
    camera.jnilib3.symlink \
    camera.jnilib4.symlink \
    camera.jnilib5.symlink

## Factory Reset Protection to be disabled in RP2 Partition
PRODUCT_COPY_FILES += device/nvidia/tegraflash/fac_rst_protection/disable_frp.bin:rp2.bin

## common apps for all skus
$(call inherit-product-if-exists, vendor/nvidia/$(_product_device)/skus/t210ref_variants_common.mk)

## nvidia apps for this sku
$(call inherit-product-if-exists, vendor/nvidia/$(_product_device)/skus/$(_product_name).mk)

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),TRUE)
PRODUCT_PACKAGE_OVERLAYS += vendor/nvidia/jetson/overlays/$(PLATFORM_VERSION_LETTER_CODE)
endif

## Calibration notifier
PRODUCT_PACKAGES += CalibNotifier
PRODUCT_COPY_FILES += \
    device/nvidia/platform/t210/calibration/calib_cfg.xml:system/etc/calib_cfg.xml

# FW check
LOCAL_FW_CHECK_TOOL_PATH=device/nvidia/common/fwcheck
LOCAL_FW_XML_PATH=vendor/nvidia/t210/skus
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(LOCAL_FW_XML_PATH)/fw_version.xml:$(TARGET_COPY_OUT_VENDOR)/etc/fw_version.xml) \
    $(call add-to-product-copy-files-if-exists, $(LOCAL_FW_CHECK_TOOL_PATH)/fw_check.py:fw_check.py)

# This flag is required in order to differentiate between platforms that use
# Keymaster1.0 vs the legacy keymaster 0.2 service.
USES_KEYMASTER_1 := true

# This flag indicates that this platform uses a TLK based Gatekeeper.
#USES_GATEKEEPER := true

#This flag indicates vrr/rsa support
USES_GS_RSA_KEYS := false

## Clean local variables
_product_name :=
_product_device :=

