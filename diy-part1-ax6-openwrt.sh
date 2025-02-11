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
echo "src-link custom $GITHUB_WORKSPACE/openwrt/custom-feed" >> feeds.conf.default

#sed -i 's/git.openwrt.org\/project\/luci.git/github.com\/hnyyghk\/luci;fix_luci_nginx/' feeds.conf.default

mkdir custom-feed
cd custom-feed

git init coolsnowwolf_lede
cd coolsnowwolf_lede
git remote add origin https://github.com/coolsnowwolf/lede
git config core.sparsecheckout true
echo 'package/lean/ipv6-helper' >> .git/info/sparse-checkout
git pull origin master
cd ../

git init coolsnowwolf_luci
cd coolsnowwolf_luci
git remote add origin https://github.com/coolsnowwolf/luci
git config core.sparsecheckout true
echo 'applications/luci-app-vlmcsd' >> .git/info/sparse-checkout
echo 'applications/luci-app-autoreboot' >> .git/info/sparse-checkout
git pull origin master
sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' applications/luci-app-vlmcsd/Makefile
sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' applications/luci-app-autoreboot/Makefile
sed -i '/^LUCI_DEPENDS:=+luci$/d' applications/luci-app-autoreboot/Makefile
cd ../

git init coolsnowwolf_packages
cd coolsnowwolf_packages
git remote add origin https://github.com/coolsnowwolf/packages
git config core.sparsecheckout true
echo 'net/vlmcsd' >> .git/info/sparse-checkout
git pull origin master
cd ../

cd ../

mv $GITHUB_WORKSPACE/0001-ipq807x-add-stock-layout-variant-for-redmi-ax6.patch 0001-ipq807x-add-stock-layout-variant-for-redmi-ax6.patch
git apply 0001-ipq807x-add-stock-layout-variant-for-redmi-ax6.patch
