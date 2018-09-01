include device/nvidia/soc/t210/BoardConfigCommon.mk

TARGET_SYSTEM_PROP    += device/nvidia/soc/t210/system.prop
TARGET_SYSTEM_PROP    += device/nvidia/platform/t210/system.prop

ifeq ($(TARGET_PRODUCT),$(filter $(TARGET_PRODUCT),foster_e_hdd foster_e_ironfist_hdd foster_e_ronan_hdd))
TARGET_RECOVERY_FSTAB := device/nvidia/platform/t210/fstab_m.foster_e_hdd
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 493631595008
else ifeq ($(TARGET_PRODUCT),$(filter $(TARGET_PRODUCT),foster_e foster_e_ironfist foster_e_ronan))
TARGET_RECOVERY_FSTAB := device/nvidia/platform/t210/fstab_m.foster_e
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 12195315712
else ifeq ($(TARGET_PRODUCT),$(filter $(TARGET_PRODUCT),darcy))
TARGET_RECOVERY_FSTAB := device/nvidia/platform/t210/fstab_m.darcy
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 12195315712
BOARD_XUSB_FW_IN_ROOT := true
else ifeq ($(TARGET_PRODUCT),$(filter $(TARGET_PRODUCT),mdarcy))
TARGET_RECOVERY_FSTAB := device/nvidia/platform/t210/fstab_m.darcy
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 12188647424
BOARD_XUSB_FW_IN_ROOT := true
else
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 10099646976
TARGET_RECOVERY_FSTAB := device/nvidia/platform/t210/fstab.t210ref
endif

BOARD_REMOVES_RESTRICTED_CODEC := false

#remove restricted codec for Jetson
#ifneq ($(findstring t210ref, $(TARGET_PRODUCT)),)
#BOARD_REMOVES_RESTRICTED_CODEC := true
#endif

# TARGET_KERNEL_DT_NAME := tegra210-grenada
TARGET_KERNEL_DT_NAME := tegra210-

BOARD_SUPPORT_NVOICE := true

BOARD_SUPPORT_NVAUDIOFX :=true

ifneq ($(filter darcy% foster_e%, $(TARGET_PRODUCT)),)
BOARD_BOOTIMAGE_PARTITION_SIZE := 26738688
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 26767360
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
else ifneq ($(filter t210ref%, $(TARGET_PRODUCT)),)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
endif

ifneq ($(filter t210ref%,$(TARGET_PRODUCT)),)
BOARD_VENDORIMAGE_PARTITION_SIZE := 1610612736
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
else
BOARD_VENDORIMAGE_PARTITION_SIZE := 805306368
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
endif
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# OTA
TARGET_RECOVERY_UPDATER_LIBS += libnvrecoveryupdater
TARGET_RECOVERY_UPDATER_EXTRA_LIBS += libfs_mgr
TARGET_RECOVERY_UI_LIB := librecovery_ui_default
TARGET_RELEASETOOLS_EXTENSIONS := device/nvidia/common
TARGET_NVPAYLOAD_UPDATE_LIB := libnvblpayload_updater

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR ?= device/nvidia/platform/t210/bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

# powerhal
BOARD_USES_POWERHAL := true

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_STA     := "/data/misc/wifi/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP      := "/data/misc/wifi/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_P2P     := "/data/misc/wifi/firmware/fw_bcmdhd_p2p.bin"
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_OP_MODE_PARAM   := "/sys/module/bcmdhd/parameters/op_mode"
WIFI_DRIVER_MODULE_ARG      := "iface_name=wlan0"
WIFI_DRIVER_MODULE_NAME     := "bcmdhd"
# Default HDMI mirror mode
# Crop (default) picks closest mode, crops to screen resolution
# Scale picks closest mode, scales to screen resolution (aspect preserved)
# Center picks a mode greater than or equal to the panel size and centers;
#     if no suitable mode is available, reverts to scale
BOARD_HDMI_MIRROR_MODE := Scale

# NVDPS can be enabled when display is set to continuous mode.
BOARD_HAS_NVDPS := true

# Double buffered display surfaces reduce memory usage, but will decrease performance.
# The default is to triple buffer the display surfaces.
# BOARD_DISABLE_TRIPLE_BUFFERED_DISPLAY_SURFACES := true

# Dalvik option
DALVIK_ENABLE_DYNAMIC_GC := true

# Using the NCT partition
TARGET_USE_NCT := true

#Display static images for charging
BOARD_CHARGER_STATIC_IMAGE := true

#Use tegra health HAL library
BOARD_HAL_STATIC_LIBRARIES := libhealthd.tegra

# Enable Paragon filesystem solution.
BOARD_SUPPORT_PARAGON_FUSE_UFSD := true

# Enable Android O build WAR
BOARD_ENABLE_ANDROID_O_BUILD_WAR := 1

ifeq ($(PLATFORM_IS_AFTER_LOLLIPOP),1)
# Enable verified boot for Jetson-CV, Darcy, and Loki
ifneq ($(filter t210ref% darcy% mdarcy% loki_e%, $(TARGET_PRODUCT)),)
ifneq ($(TARGET_BUILD_VARIANT),eng)
BOARD_SUPPORT_VERIFIED_BOOT := true
endif
endif
endif

# Enable rollback protection for all devices except for Jetson
ifeq ($(filter t210ref, $(TARGET_PRODUCT)),)
BOARD_SUPPORT_ROLLBACK_PROTECTION := true
endif

# Adding odm folder to ramdisk
BOARD_ROOT_EXTRA_FOLDERS := odm

# Raydium touch definitions
include device/nvidia/drivers/touchscreen/raydium/BoardConfigRaydium.mk

# SELinux policies
BOARD_SEPOLICY_DIRS += device/nvidia/platform/t210/sepolicy/

# Enable kernel compression for darcy/foster_e, and t210ref
# supported compress method: gzip,lz4
ifneq ($(filter t210ref%, $(TARGET_PRODUCT)), )
BOARD_SUPPORT_KERNEL_COMPRESS := lz4
else ifneq ($(filter darcy% mdarcy% foster_e%, $(TARGET_PRODUCT)), )
BOARD_SUPPORT_KERNEL_COMPRESS := gzip
endif

# seccomp policy
BOARD_SECCOMP_POLICY = device/nvidia/platform/t210/seccomp/

# Per-application sizes for shader cache
MAX_EGL_CACHE_SIZE := 128450560
MAX_EGL_CACHE_ENTRY_SIZE := 262144

# GPU/EMC boosting for hwcomposer yuv packing
HWC_YUV_PACKING_CPU_FREQ_MIN := -1
HWC_YUV_PACKING_CPU_FREQ_MAX := -1
HWC_YUV_PACKING_CPU_FREQ_PRIORITY := 15
HWC_YUV_PACKING_GPU_FREQ_MIN := 614400
HWC_YUV_PACKING_GPU_FREQ_MAX := 998400
HWC_YUV_PACKING_GPU_FREQ_PRIORITY := 15
HWC_YUV_PACKING_EMC_FREQ_MIN := 106560

# GPU/EMC floor for glcomposer composition
HWC_GLCOMPOSER_CPU_FREQ_MIN := -1
HWC_GLCOMPOSER_CPU_FREQ_MAX := -1
HWC_GLCOMPOSER_CPU_FREQ_PRIORITY := 15
HWC_GLCOMPOSER_GPU_FREQ_MIN := 153600
HWC_GLCOMPOSER_GPU_FREQ_MAX := 998400
HWC_GLCOMPOSER_GPU_FREQ_PRIORITY := 15
HWC_GLCOMPOSER_EMC_FREQ_MIN := 4080

