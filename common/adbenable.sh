#!/system/bin/sh
#
# Copyright (c) 2015-2016 NVIDIA Corporation.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#

# choose first udc
UDC_NAME=$(set -v `ls /sys/class/udc` && echo $1)
if [ -n "$UDC_NAME" ] && [ -e /sys/class/udc/$UDC_NAME ]; then
	setprop sys.usb.udc $UDC_NAME
	setprop sys.usb.controller $UDC_NAME
fi

# set sys.usb.configfs as 0 kernel 3.10 and 1 otherwise
setprop sys.usb.configfs 1
k310=$(cat /proc/version | grep "Linux version 3.10")
if [ "$k310" != "" ]; then
	setprop sys.usb.configfs 0
fi
