#!/bin/bash
# [CTCGFW]Project-OpenWrt
# Use it under GPLv3, please.
# --------------------------------------------------------
# Convert translation files zh-cn to zh_Hans
# The script is still in testing, welcome to report bugs.

#1. Modify default IP
sed -i 's/192.168.1.1/192.168.100.11/g' openwrt/package/base-files/files/bin/config_generate
#2. Modify default gatewy
#sed -i '108a \                                set network.$1.gateway='192.168.100.1'' openwrt/package/base-files/files/bin/config_generate
#3. Modify default DNS
#sed -i '109a \                                set network.$1.dns='222.172.200.68\ 223.5.5.5\ 8.8.8.8'' openwrt/package/base-files/files/bin/config_generate
#4. Add firmware timestamp
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +%Y%m%d-%H%M%S)-/g' openwrt/include/image.mk
#5. Convert Translation
po_file="$({ find |grep -E "[a-z0-9]+\.zh\-cn.+po"; } 2>"/dev/null")"
for a in ${po_file}
do
	[ -n "$(grep "Language: zh_CN" "$a")" ] && sed -i "s/Language: zh_CN/Language: zh_Hans/g" "$a"
	po_new_file="$(echo -e "$a"|sed "s/zh-cn/zh_Hans/g")"
	mv "$a" "${po_new_file}" 2>"/dev/null"
done

po_file2="$({ find |grep "/zh-cn/" |grep "\.po"; } 2>"/dev/null")"
for b in ${po_file2}
do
	[ -n "$(grep "Language: zh_CN" "$b")" ] && sed -i "s/Language: zh_CN/Language: zh_Hans/g" "$b"
	po_new_file2="$(echo -e "$b"|sed "s/zh-cn/zh_Hans/g")"
	mv "$b" "${po_new_file2}" 2>"/dev/null"
done

lmo_file="$({ find |grep -E "[a-z0-9]+\.zh_Hans.+lmo"; } 2>"/dev/null")"
for c in ${lmo_file}
do
	lmo_new_file="$(echo -e "$c"|sed "s/zh_Hans/zh-cn/g")"
	mv "$c" "${lmo_new_file}" 2>"/dev/null"
done

lmo_file2="$({ find |grep "/zh_Hans/" |grep "\.lmo"; } 2>"/dev/null")"
for d in ${lmo_file2}
do
	lmo_new_file2="$(echo -e "$d"|sed "s/zh_Hans/zh-cn/g")"
	mv "$d" "${lmo_new_file2}" 2>"/dev/null"
done

po_dir="$({ find |grep "/zh-cn" |sed "/\.po/d" |sed "/\.lmo/d"; } 2>"/dev/null")"
for e in ${po_dir}
do
	po_new_dir="$(echo -e "$e"|sed "s/zh-cn/zh_Hans/g")"
	mv "$e" "${po_new_dir}" 2>"/dev/null"
done

makefile_file="$({ find|grep Makefile |sed "/Makefile./d"; } 2>"/dev/null")"
for f in ${makefile_file}
do
	[ -n "$(grep "zh-cn" "$f")" ] && sed -i "s/zh-cn/zh_Hans/g" "$f"
	[ -n "$(grep "zh_Hans.lmo" "$f")" ] && sed -i "s/zh_Hans.lmo/zh-cn.lmo/g" "$f"
done

makefile_file="$({ find package | grep Makefile | sed "/Makefile./d"; } 2>"/dev/null")"
for g in ${makefile_file}; do
	[ -n "$(grep "golang-package.mk" "$g")" ] && sed -i "s,\../..,\$(TOPDIR)/feeds/packages,g" "$g"
	[ -n "$(grep "luci.mk" "$g")" ] && sed -i "s,\../..,\$(TOPDIR)/feeds/luci,g" "$g"
done

exit 0
