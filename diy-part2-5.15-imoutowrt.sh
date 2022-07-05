#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2-5.15-imoutowrt.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# https://github.com/deplives/OpenWrt-CI-RC/blob/main/second.sh
# https://github.com/jarod360/Redmi_AX6/blob/main/diy-part2.sh

COMMIT_COMMENT=$1
if [ -z "$COMMIT_COMMENT" ]; then
    COMMIT_COMMENT='Unknown'
fi
WIFI_SSID=$2
if [ -z "$WIFI_SSID" ]; then
    WIFI_SSID='Unknown'
fi
WIFI_KEY=$3
if [ -z "$WIFI_KEY" ]; then
    WIFI_KEY='Unknown'
fi

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/cn.ntp.org.cn/pool.ntp.org/g' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/ntp.ntsc.ac.cn/cn.ntp.org.cn/g' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/time1.cloud.tencent.com/ntp.ntsc.ac.cn/g' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/ntp1.aliyun.com/ntp.aliyun.com/g' package/emortal/default-settings/files/99-default-settings-chinese

# Modify default LAN ip
echo 'Modify default LAN IP...'
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# 修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# Ax6修改无线命名、加密方式及密码
sed -i "s/radio\${devidx}.ssid=OpenWrt/radio0.ssid=${WIFI_SSID}\n\t\t\tset wireless.default_radio1.ssid=${WIFI_SSID}_2.4G/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/radio\${devidx}.encryption=none/radio\${devidx}.encryption=psk-mixed\n\t\t\tset wireless.default_radio\${devidx}.key=${WIFI_KEY}/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Modify default banner
echo 'Modify default banner...'
build_date=$(date +"%Y-%m-%d %H:%M:%S")
echo "                                                               " >  package/base-files/files/etc/banner
echo " ██████╗ ██████╗ ███████╗███╗   ██╗██╗    ██╗██████╗ ████████╗ " >> package/base-files/files/etc/banner
echo "██╔═══██╗██╔══██╗██╔════╝████╗  ██║██║    ██║██╔══██╗╚══██╔══╝ " >> package/base-files/files/etc/banner
echo "██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║ █╗ ██║██████╔╝   ██║    " >> package/base-files/files/etc/banner
echo "██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║███╗██║██╔══██╗   ██║    " >> package/base-files/files/etc/banner
echo "╚██████╔╝██║     ███████╗██║ ╚████║╚███╔███╔╝██║  ██║   ██║    " >> package/base-files/files/etc/banner
echo " ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝    " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo " %D %C ${build_date} by hnyyghk                                " >> package/base-files/files/etc/banner
echo " $COMMIT_COMMENT                                               " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "                                                               " >> package/base-files/files/etc/banner
