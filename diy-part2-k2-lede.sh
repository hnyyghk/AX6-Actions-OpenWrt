#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2-k2-lede.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# https://github.com/deplives/OpenWrt-CI-RC/blob/main/second.sh
# https://github.com/jarod360/Redmi_AX6/blob/main/diy-part2.sh

REPO_URL=$1
if [ -z "$REPO_URL" ]; then
    REPO_URL='Unknown'
fi
REPO_BRANCH=$2
if [ -z "$REPO_BRANCH" ]; then
    REPO_BRANCH='Unknown'
fi
COMMIT_HASH=$3
if [ -z "$COMMIT_HASH" ]; then
    COMMIT_HASH='Unknown'
fi
DEVICE_NAME=$4
if [ -z "$DEVICE_NAME" ]; then
    DEVICE_NAME='Unknown'
fi
WIFI_SSID=$5
if [ -z "$WIFI_SSID" ]; then
    WIFI_SSID='Unknown'
fi
WIFI_KEY=$6
if [ -z "$WIFI_KEY" ]; then
    WIFI_KEY='Unknown'
fi

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/ntp.aliyun.com/ntp.ntsc.ac.cn/' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/ntp.aliyun.com/' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/cn.ntp.org.cn/' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/pool.ntp.org/' package/base-files/files/bin/config_generate

# Modify default LAN ip
echo 'Modify default LAN IP...'
sed -i 's/192.168.1.1/192.168.31.1/' package/base-files/files/bin/config_generate

# sysctl -a
# fix v2ray too many open files
# fs.file-max = 41549
# increase APR kernel parameters for arp ram full load
# net.ipv4.neigh.default.gc_thresh1 = 128
# net.ipv4.neigh.default.gc_thresh2 = 512
# net.ipv4.neigh.default.gc_thresh3 = 1024
# net.netfilter.nf_conntrack_max = 26112
sed -i '/customized in this file/a fs.file-max=102400\nnet.ipv4.neigh.default.gc_thresh1=512\nnet.ipv4.neigh.default.gc_thresh2=2048\nnet.ipv4.neigh.default.gc_thresh3=4096\nnet.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改无线命名、加密方式及密码
sed -i "s/radio\${devidx}.ssid=OpenWrt/radio0.ssid=${WIFI_SSID}\n\t\t\tset wireless.default_radio1.ssid=${WIFI_SSID}_2.4G/" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/radio\${devidx}.encryption=none/radio\${devidx}.encryption=psk-mixed\n\t\t\tset wireless.default_radio\${devidx}.key=${WIFI_KEY}\n\t\t\tset wireless.default_radio\${devidx}.iw_qos_map_set=none/" package/kernel/mac80211/files/lib/wifi/mac80211.sh

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
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "      REPO_URL: $REPO_URL                                      " >> package/base-files/files/etc/banner
echo "   REPO_BRANCH: $REPO_BRANCH                                   " >> package/base-files/files/etc/banner
echo "   COMMIT_HASH: $COMMIT_HASH                                   " >> package/base-files/files/etc/banner
echo "   DEVICE_NAME: $DEVICE_NAME                                   " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "                                                               " >> package/base-files/files/etc/banner

# 压缩编译后的体积 -s 去掉符号信息 -w 去掉DWARF调试信息（去掉后无法使用GDB进行调试）
sed -i "s/GO_PKG_LDFLAGS_X/GO_PKG_LDFLAGS:=-s -w\n&/" feeds/helloworld/v2ray-core/Makefile
# Compress executable files with UPX
sed -i 's/PKG_BUILD_DEPENDS:=/&upx\/host /' feeds/helloworld/v2ray-core/Makefile
sed -i "s/define Package\/v2ray-core\/install/define Build\/Compile\n\t\$(call GoPackage\/Build\/Compile)\n\t\$(STAGING_DIR_HOST)\/bin\/upx --lzma --best \$(GO_PKG_BUILD_BIN_DIR)\/main\nendef\n\n&/" feeds/helloworld/v2ray-core/Makefile
# 仅保留freedom vmess-inbound websocket模块
sed -i '/$(eval $(call BuildPackage,v2ray-core))/d' feeds/helloworld/v2ray-core/Makefile
sed -i '/$(eval $(call BuildPackage,v2ray-extra))/d' feeds/helloworld/v2ray-core/Makefile
#${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/freedom"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
#${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vmess\/inbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
#${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/websocket"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
# https://stackoverflow.com/questions/3731513/how-do-you-type-a-tab-in-a-bash-here-document
TAB=$'\t'
cat >> feeds/helloworld/v2ray-core/Makefile << EOF
define Build/Prepare
${TAB}\$(call Build/Prepare/Default)
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/commander"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/log\/command"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/proxyman\/command"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/stats\/command"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/instman\/command"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/observatory\/command"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/dns"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/dns\/fakedns"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/log"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/policy"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/reverse"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/router"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/stats"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/tagged\/taggedimpl"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/instman"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/observatory"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/app\/restfulapi"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/blackhole"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/dns"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/dokodemo"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/http"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/shadowsocks"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/socks"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/trojan"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vless\/inbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vless\/outbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vmess\/outbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vlite\/inbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/vlite\/outbound"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/domainsocket"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/grpc"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/http"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/kcp"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/quic"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/tcp"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/tls"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/udp"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/http"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/noop"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/srtp"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/tls"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/utp"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/wechat"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/transport\/internet\/headers\/wireguard"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/infra\/conf\/geodata\/memconservative"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/infra\/conf\/geodata\/standard"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/main\/formats"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/main\/commands\/all"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/main\/commands\/all\/engineering"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/main\/commands\/all\/api\/jsonv4"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/main\/commands\/all\/jsonv4"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/infra\/conf\/v5cfg"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/http\/simplified"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/shadowsocks\/simplified"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/socks\/simplified"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
${TAB}sed -i 's/_ "github.com\/v2fly\/v2ray-core\/v5\/proxy\/trojan\/simplified"/\/\/&/' \$(PKG_BUILD_DIR)/main/distro/all/all.go
endef

\$(eval \$(call BuildPackage,v2ray-core))
\$(eval \$(call BuildPackage,v2ray-extra))
EOF
cat feeds/helloworld/v2ray-core/Makefile

# k2固件大小限制 8060928B -> 7872KB -> 7.6875MB

# 5.10 kernel包精简记录
# 7119KB 无v2ray
# 12664KB 直接加v2ray +5545KB
# 11992KB 压缩v2ray -672KB
# 11397KB 精简config -595KB
# 8839KB 精简v2ray -2558KB
# 7796KB 去除ppp opkg dropbear 精简内核 -1043KB
# 7888KB 添加dropbear +92KB
# 8179KB 添加wpad-mini +291KB / 8209KB 添加wpad-basic +321KB / 8224KB 添加wpad-basic-wolfssl +336KB / 8439KB 添加wpad +551KB / 8442KB 添加wpad-wolfssl +554KB
# 8136KB 关闭kmod-mac80211的DebugFS支持, Minify Lua sources -43KB

# 5.4 kernel包精简记录
# 7472KB 压缩v2ray 精简config 精简v2ray 去除ppp opkg dropbear 精简内核
# 7555KB 添加dropbear +83KB
# 7821KB 添加wpad-mini +266KB / 7849KB 添加wpad-basic +294KB / 7860KB 添加wpad-basic-wolfssl +305KB / 8060KB 添加wpad +505KB / 8060KB 添加wpad-wolfssl +505KB
# 7781KB 关闭kmod-mac80211的DebugFS支持, Minify Lua sources -40KB
