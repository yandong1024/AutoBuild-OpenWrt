#!/bin/bash
#1. Modify default IP
sed -i 's/192.168.1.1/192.168.100.22/g' openwrt/package/base-files/files/bin/config_generate
#2. Add firmware timestamp
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +%Y%m%d-%H%M%S)-/g' openwrt/include/image.mk
