# Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property and
# proprietary rights in and to this software and related documentation.  Any
# use, reproduction, disclosure or distribution of this software and related
# documentation without an express license agreement from NVIDIA Corporation
# is strictly prohibited.

#!/bin/bash
# This script generates a blob for the product passed as argument
# This is invoked through Android.mk in this module
# The config_file from the respective product folder is used to generate the blob
#set -x

# Sanity checks
if [[ ! -d "${ANDROID_BUILD_TOP}" ]]; then
    echo 1>&2 "$0: ANDROID_BUILD_TOP not defined or not a directory."
    exit 1
fi
if [[ $# -eq 3 ]]; then
    _config=$1
    _nv_blob=${ANDROID_BUILD_TOP}/$2
    _output=$3
elif [[ $# -eq 5 ]]; then
    _config=$1
    _nv_blob=${ANDROID_BUILD_TOP}/$2
    _blob_compress=$3
    _lz4c_tool=$4
    _output=$5
else
    echo 1>&2 "usage: $0 <product config file> <path to nv_blob2> [<compress script> <path to lz4c>] <output file>"
    exit 1
fi

if [[ ! -r "${_config}" ]]; then
    echo 1>&2 "$0: can't find product configuration file '${_config}'. Skipping."
    exit 0
fi
if [[ ! -x "${_nv_blob}" ]]; then
    echo 1>&2 "$0: can't find nv_blob_v2 binary '${_nv_blob}'."
    exit 1
fi

set -e
rm -f ${_output}

# references in config file are relative to configuration directory
# @TODO: BROKEN: generates files in current directory - in source tree!
_config_dir=$(dirname ${_config})
pushd ${_config_dir}
${_nv_blob} -t firmware $(cat $(basename ${_config}))
popd

if [[ -n ${_blob_compress} ]]; then
    # compress blob
    # note: below 2 paras should keep consistence with header definition in ${_nv_blob}
    _blob_header_len=36
    _blob_size_pos=20
    ${_blob_compress} ${_lz4c_tool} ${_config_dir}/firmware.blob ${_blob_header_len} ${_blob_size_pos}
fi

# move generated file from source tree to build directory
mv ${_config_dir}/firmware.blob ${_output}
exit 0
