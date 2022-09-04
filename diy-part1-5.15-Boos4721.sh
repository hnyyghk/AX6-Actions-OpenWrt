#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1-5.15-Boos4721.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

for i in "608-5.15-qca-nss-ssdk-delete-fdb-entry-using-netdev"; do \
  svn export "https://github.com/Lstions/openwrt-boos/trunk/target/linux/ipq807x/patches-5.15/$i" "target/linux/ipq807x/patches-5.15/$i"; \
done

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall;packages' >> feeds.conf.default
#echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall;luci' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/small-package' >> feeds.conf.default
#echo 'src-git lienol https://github.com/Lienol/openwrt-package' >> feeds.conf.default
#echo 'src-git Boos https://github.com/Boos4721/OpenWrt-Packages' >> feeds.conf.default
