#!/system/bin/sh

# Copyright (c) 2017, NVIDIA CORPORATION. All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

scriptName=$0

# Read the Board/Platform name
hardwareName=$(getprop ro.hardware)

/system/bin/log -t "$scriptName" -p i "*** STARTING LKM LOADER FOR ***:" $hardwareName

#====================================================================================
# Early load is for loading modules "on fs"
early_load()
{
# list of Vendor modules
# insmod /vendor/lib/modules/example1.ko
# TODO: For the time being insmod from /system/lib/modules
/system/bin/log -t "$scriptName" -p i "Early Loading LKM SoC-Vendor modules started"

insmod /system/lib/modules/libahci.ko
insmod /system/lib/modules/libahci_platform.ko
insmod /system/lib/modules/ahci_tegra.ko

insmod /system/lib/modules/pci-tegra.ko

# Security
insmod /system/lib/modules/echainiv.ko
insmod /system/lib/modules/af_alg.ko
insmod /system/lib/modules/algif_skcipher.ko
insmod /system/lib/modules/algif_hash.ko
insmod /system/lib/modules/cryptd.ko
insmod /system/lib/modules/ecc.ko
insmod /system/lib/modules/ecdsa_generic.ko
insmod /system/lib/modules/twofish_common.ko
insmod /system/lib/modules/twofish_generic.ko
insmod /system/lib/modules/ablk_helper.ko
insmod /system/lib/modules/ecdh_generic.ko
insmod /system/lib/modules/aes-ce-cipher.ko
insmod /system/lib/modules/aes-ce-ccm.ko
insmod /system/lib/modules/sha1-ce.ko
insmod /system/lib/modules/sha2-ce.ko
insmod /system/lib/modules/aes-ce-blk.ko
insmod /system/lib/modules/ghash-ce.ko
insmod /system/lib/modules/aes-neon-blk.ko
insmod /system/lib/modules/tegra-se.ko
insmod /system/lib/modules/tegra-se-elp.ko
insmod /system/lib/modules/tegra-se-nvhost.ko
insmod /system/lib/modules/tegra-cryptodev.ko
insmod /system/lib/modules/trusty.ko
insmod /system/lib/modules/trusty-irq.ko
insmod /system/lib/modules/virtio.ko
insmod /system/lib/modules/virtio_ring.ko
insmod /system/lib/modules/trusty-log.ko
insmod /system/lib/modules/trusty-ipc.ko
insmod /system/lib/modules/trusty-ote.ko
insmod /system/lib/modules/trusty-otf-iface.ko
insmod /system/lib/modules/trusty-mem.ko
insmod /system/lib/modules/trusty-virtio.ko

# Peripheral
insmod /system/lib/modules/core.ko
insmod /system/lib/modules/pwm-tegra.ko
insmod /system/lib/modules/pwm-tegra-pmc-blink.ko
insmod /system/lib/modules/pwm_fan.ko
insmod /system/lib/modules/therm_fan_est.ko

/system/bin/log -t "$scriptName" -p i "Early Loading LKM SoC-Vendor modules completed"

#--------------------------------------------------------------------------------

# list of ODM modules
# insmod /odm/lib/modules/example2.ko
# TODO: For the time being insmod from /system/lib/modules
/system/bin/log -t "$scriptName" -p i "Early Loading LKM Board-ODM modules started"

# Note: load audio drivers at the earliest
# HDA audio driver
insmod /system/lib/modules/snd-hda-tegra.ko

# APE audio drivers
insmod /system/lib/modules/snd-soc-spdif-rx.ko
insmod /system/lib/modules/snd-soc-spdif-tx.ko
insmod /system/lib/modules/snd-pcm-dmaengine.ko
insmod /system/lib/modules/snd-soc-tegra-alt-isomgr.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-fpga-clock.ko
insmod /system/lib/modules/snd-soc-tegra-alt-utils.ko
insmod /system/lib/modules/snd-soc-tegra-alt-pcm.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-xbar-utils.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-xbar.ko
insmod /system/lib/modules/tegra210-adma.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-admaif.ko
insmod /system/lib/modules/snd-soc-tegra-virt-alt-ivc.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-adsp.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-sfc.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-i2s.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-mixer.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-afc.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-adx.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-amx.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-dmic.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-mvc.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-spdif.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-peq.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-mbdrc.ko
insmod /system/lib/modules/snd-soc-tegra210-alt-ope.ko
insmod /system/lib/modules/snd-soc-tegra-alt-machine.ko
insmod /system/lib/modules/snd-soc-tegra-machine-driver-mobile.ko

/system/bin/log -t "$scriptName" -p i "Early Loading LKM Board-ODM modules completed"

}

#===================================================================================

# Normal load is for loading on boot
normal_load()
{
# list of Vendor modules
# insmod /vendor/lib/modules/example1.ko
# TODO: For the time being insmod from /system/lib/modules

/system/bin/log -t "$scriptName" -p i "Loading LKM SoC-Vendor modules started"

/system/bin/log -t "$scriptName" -p i "Loading LKM nvgpu started"
insmod /system/lib/modules/nvgpu.ko
/system/bin/log -t "$scriptName" -p i "Loading LKM nvgpu completed"

insmod /system/lib/modules/usb-storage.ko

# load COMMS driver
insmod /system/lib/modules/bluedroid_pm.ko
if [ "`cat /proc/device-tree/bcmdhd_pcie_wlan/status`" = "okay" ]; then
        insmod /system/lib/modules/bcmdhd_pcie.ko
else
        insmod /system/lib/modules/bcmdhd.ko
fi

/system/bin/log -t "$scriptName" -p i "Loading LKM SoC-Vendor modules completed"

#--------------------------------------------------------------------------------

# list of ODM modules
# insmod /odm/lib/modules/example2.ko
# TODO: For the time being insmod from /system/lib/modules
/system/bin/log -t "$scriptName" -p i "Loading LKM Board-ODM modules started"

# Note: load backlight drivers at the earliest.
# backlight driver
insmod /system/lib/modules/lp855x_bl.ko

if [ "$hardwareName" = "abca" ]; then
     insmod /system/lib/modules/fts.ko
fi

/system/bin/log -t "$scriptName" -p i "loading ODM Camera started"
insmod /system/lib/modules/pca9570.ko
insmod /system/lib/modules/tc358840.ko
insmod /system/lib/modules/ov5693.ko
insmod /system/lib/modules/ov9281.ko
insmod /system/lib/modules/ov10823.ko
insmod /system/lib/modules/ov23850.ko
insmod /system/lib/modules/lc898212.ko
insmod /system/lib/modules/imx185.ko
insmod /system/lib/modules/imx219.ko
insmod /system/lib/modules/imx274.ko
/system/bin/log -t "$scriptName" -p i "loading ODM Camera completed"

# Load Sensor modules
/system/bin/log -t "$scriptName" -p i "loading ODM sensor started"
insmod /system/lib/modules/nvs.ko
insmod /system/lib/modules/nvi-mpu.ko
insmod /system/lib/modules/nvi-ak89xx.ko
insmod /system/lib/modules/nvi-bmpX80.ko
insmod /system/lib/modules/nvs_a3g4250d.ko
insmod /system/lib/modules/nvs_ais328dq.ko
insmod /system/lib/modules/nvs_bh1730fvc.ko
insmod /system/lib/modules/nvs_cm3218.ko
insmod /system/lib/modules/nvs_dfsh.ko
/system/bin/log -t "$scriptName" -p i "loading ODM sensor completed"

insmod /system/lib/modules/gps_wake.ko
/system/bin/log -t "$scriptName" -p i "loading comms modules completed"

# Touchscreen module
insmod /system/lib/modules/rm31080a_ctrl.ko
insmod /system/lib/modules/rm31080a_ts.ko

/system/bin/log -t "$scriptName" -p i "Loading LKM Board-ODM modules completed"
}

if [ "$1" = "early" ]; then
    early_load
else
    normal_load
fi

