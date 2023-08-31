#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1-ax6-openwrt.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall;packages' >> feeds.conf.default
#echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall;luci' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
#echo 'src-git lienol https://github.com/Lienol/openwrt-package' >> feeds.conf.default
#echo 'src-git Boos https://github.com/Boos4721/OpenWrt-Packages' >> feeds.conf.default
echo 'src-link custom /workdir/openwrt/custom-feed' >> feeds.conf.default

mkdir -p custom-feed/applications

for i in "ipv6-helper"; do \
  svn checkout "https://github.com/coolsnowwolf/lede/trunk/package/lean/$i" "custom-feed/applications/$i"; \
done

#for i in "luci-app-vlmcsd"; do \
#  svn checkout "https://github.com/coolsnowwolf/luci/trunk/applications/$i" "custom-feed/applications/$i"; \
#done
#sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' custom-feed/applications/luci-app-vlmcsd/Makefile

#for i in "vlmcsd"; do \
#  svn checkout "https://github.com/coolsnowwolf/packages/trunk/net/$i" "custom-feed/applications/$i"; \
#done

for i in "luci-app-vlmcsd" "openwrt-vlmcsd"; do \
  svn checkout "https://github.com/cokebar/$i" "custom-feed/applications/$i"; \
done

#https://github.com/ssuperh/luci-app-vlmcsd-new
#https://github.com/flytosky-f/luci-app-vlmcsd
#https://github.com/flytosky-f/openwrt-vlmcsd

#https://github.com/openwrt-develop/luci-app-vlmcsd
#https://github.com/openwrt-develop/openwrt-vlmcsd

#https://github.com/siwind/luci-app-vlmcsd
#https://github.com/siwind/openwrt-vlmcsd

for i in "luci-app-autoreboot"; do \
  svn checkout "https://github.com/kenzok8/small-package/trunk/$i" "custom-feed/applications/$i"; \
done
