# NVIDIA Tegra development system
#
# Copyright (c) 2017 NVIDIA Corporation.  All rights reserved.

SENSOR_BUILD_VERSION		:= foster_e
SENSOR_BUILD_CFLAGS		:=
SENSOR_FUSION_VENDOR		:= Nvidia
SENSOR_FUSION_VERSION		:= no_fusion
SENSOR_FUSION_API		:= nvs
SENSOR_FUSION_CFLAGS		:=
SENSOR_HAL_VERSION		:= nvs
SENSOR_HAL_API			:= 1.4
SENSOR_HAL_CFLAGS		:=
SENSOR_HAL_OS_INTERFACE_SRC	:= NvsAos.cpp
SENSOR_HAL_LOCAL_DRIVER_SRC	:= NvsNullDriver.cpp
SENSOR_REQUIRED_MODULES         :=
SENSOR_SHARED_LIBRARIES		:=

PRODUCT_PROPERTY_OVERRIDES	+= ro.hardware.sensors=$(SENSOR_BUILD_VERSION).api_v$(SENSOR_HAL_API).$(SENSOR_FUSION_VERSION).$(SENSOR_FUSION_API)
PRODUCT_PACKAGES		+= sensors.$(SENSOR_BUILD_VERSION).api_v$(SENSOR_HAL_API).$(SENSOR_FUSION_VERSION).$(SENSOR_FUSION_API)
PRODUCT_PACKAGES                += sensor-grinder