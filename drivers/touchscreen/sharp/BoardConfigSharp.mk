# Copyright (c) 2015-2016, NVIDIA CORPORATION.  All rights reserved.
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

# This lists the SE Linux policies necessary to build a device and touch
# init.rc using Sharp touch

BOARD_SEPOLICY_DIRS += device/nvidia/drivers/touchscreen/sharp/sepolicy_$(PLATFORM_VERSION_LETTER_CODE)

PRODUCT_PROPERTY_OVERRIDES += persist.tch.tap2wake=0

# create touch init.rc according touchvendor id from bootloader/nct
PRODUCT_COPY_FILES += \
    device/nvidia/common/init.sharp_touch.rc:root/init.touch.2.rc
