#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1-ax6-lede.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# https://stackoverflow.com/questions/3731513/how-do-you-type-a-tab-in-a-bash-here-document
TAB=$'\t'
cat >> target/linux/ipq807x/image/generic.mk << EOF

define Device/redmi_ax6
${TAB}\$(call Device/xiaomi_ax3600)
${TAB}DEVICE_VENDOR := Redmi
${TAB}DEVICE_MODEL := AX6
${TAB}DEVICE_PACKAGES := ipq-wifi-redmi_ax6 uboot-envtools
endef
TARGET_DEVICES += redmi_ax6

define Device/xiaomi_ax3600
${TAB}\$(call Device/FitImage)
${TAB}\$(call Device/UbiFit)
${TAB}DEVICE_VENDOR := Xiaomi
${TAB}DEVICE_MODEL := AX3600
${TAB}BLOCKSIZE := 128k
${TAB}PAGESIZE := 2048
${TAB}DEVICE_DTS_CONFIG := config@ac04
${TAB}SOC := ipq8071
${TAB}DEVICE_PACKAGES := ath10k-firmware-qca9887-ct ipq-wifi-xiaomi_ax3600 \\
${TAB}kmod-ath10k-ct uboot-envtools
endef
TARGET_DEVICES += xiaomi_ax3600
EOF

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall;packages' >> feeds.conf.default
#echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall;luci' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
#echo 'src-git lienol https://github.com/Lienol/openwrt-package' >> feeds.conf.default
#echo 'src-git Boos https://github.com/Boos4721/OpenWrt-Packages' >> feeds.conf.default
