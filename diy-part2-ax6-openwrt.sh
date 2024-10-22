#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2-ax6-openwrt.sh
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

# fix certain modules require OpenSSL QUIC support, replace built-in OpenSSL to QuicTLS
sed -i "/^PKG_SOURCE_URL:=/,/^PKG_HASH:=/s/.*//" package/libs/openssl/Makefile
sed -i "/^PKG_SOURCE:=/cPKG_SOURCE_PROTO:=git\nPKG_SOURCE_URL:=https://github.com/quictls/openssl\nPKG_SOURCE_VERSION:=openssl-\$(PKG_VERSION)+quic\nPKG_MIRROR_HASH:=skip" package/libs/openssl/Makefile

# nginx quic
rm -rf feeds/packages/net/nginx
rm -rf feeds/packages/net/nginx-util
./scripts/feeds update -a
./scripts/feeds install -a

# add alter inbound api
#sed -i "/^PKG_SOURCE:=/s/.*//" feeds/packages/net/v2ray-core/Makefile
#sed -i "/^PKG_HASH:=/s/.*//" feeds/packages/net/v2ray-core/Makefile
#sed -i '/^PKG_SOURCE_URL:=/cPKG_SOURCE_PROTO:=git\nPKG_SOURCE_URL:=https://github.com/hnyyghk/v2ray-core\nPKG_SOURCE_VERSION:=51e865633eec7116fec8a5538dd2785db7221fa4\nPKG_MIRROR_HASH:=skip' feeds/packages/net/v2ray-core/Makefile

# lua-nginx-module 0.10.16
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=c2565fe799408c31bf445530a0e68c9bdb2de1fa/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.17
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=2d23bc4f0a29ed79aaaa754c11bffb1080aa44ba/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.18
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=15197e7bbae89ce1c726061d04211262322f2712/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.19
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=7105adaa523adedec80f0aaa13388b88d08988f8/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.20
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=7105adaa523adedec80f0aaa13388b88d08988f8/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.21
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=97d1b704d0d86b5370d57604a9e2e3f86e4a33ec/' feeds/packages/net/nginx/Makefile
# lua-nginx-module 0.10.22
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=8d9032298ef542aef058fa02940a6ecd9cf25423/' feeds/packages/net/nginx/Makefile
# lua-nginx-module master
#sed -i 's/VERSION:=28cf5ce3b6ec8e7ab44eadac9cc1c3b6f5c387ba/VERSION:=3207da152a1cead67ade7b3d4234681f2c44ba77/' feeds/packages/net/nginx/Makefile

# fix lua-nginx-module >= 0.10.14, start warning
# detected a LuaJIT version which is not OpenResty's; many optimizations will be disabled and performance will be compromised (see https://github.com/openresty/luajit2 for OpenResty's LuaJIT or, even better, consider using the OpenResty releases from https://openresty.org/en/download.html)
#sed -i "/^PKG_HASH:=/s/.*//" feeds/packages/lang/luajit/Makefile
#sed -i '/^PKG_SOURCE_URL:=/cPKG_SOURCE_PROTO:=git\nPKG_SOURCE_URL:=https://github.com/openresty/luajit2\nPKG_SOURCE_VERSION:=8384278b14988390cf030b787537aa916a9709bb\nPKG_MIRROR_HASH:=skip' feeds/packages/lang/luajit/Makefile
# fix 010-lua-path.patch can't find file to patch at input line 3
#sed -i '/^PKG_SOURCE:=/cPKG_SOURCE_SUBDIR:=LuaJIT-$(PKG_VERSION)' feeds/packages/lang/luajit/Makefile
# fix $(CP) $(PKG_INSTALL_DIR)/usr/bin/luajit-$(PKG_VERSION) $(PKG_INSTALL_DIR)/usr/bin/$(PKG_NAME) are the same file
#sed -i "s/define Build\/Compile/&\n\tsed -i '137d' \$(PKG_BUILD_DIR)\/Makefile/" feeds/packages/lang/luajit/Makefile
#cat feeds/packages/lang/luajit/Makefile
# fix 030_fix_posix_install_with_missing_or_incompatible_ldconfig.patch Hunk #1 FAILED at 75 and Hunk #2 FAILED at 121, it is already patched
#rm feeds/packages/lang/luajit/patches/030_fix_posix_install_with_missing_or_incompatible_ldconfig.patch
#rm feeds/packages/lang/luajit/patches/040-softfloat-ppc.patch
#rm feeds/packages/lang/luajit/patches/050-ppc-softfloat.patch
#rm feeds/packages/lang/luajit/patches/060-ppc-musl.patch
#rm feeds/packages/lang/luajit/patches/300-PPC-e500-with-SPE-enabled-use-soft-float.patch

# fix lua-nginx-module >= 0.10.15, start warning
# lua_load_resty_core failed to load the resty.core module from https://github.com/openresty/lua-resty-core; ensure you are using an OpenResty release from https://openresty.org/en/download.html (rc: 2, reason: module 'resty.core' not found:
# 	no field package.preload['resty.core']
# 	no file './resty/core.lua'
# 	no file '/usr/share/luajit-2.1.0-beta3/resty/core.lua'
# 	no file '/usr/share/lua/resty/core.lua'
# 	no file '/usr/share/lua/resty/core/init.lua'
# 	no file '/usr/share/lua/resty/core.lua'
# 	no file '/usr/share/lua/resty/core/init.lua'
# 	no file './resty/core.so'
# 	no file '/usr/lib/lua/resty/core.so'
# 	no file '/usr/lib/lua/resty/core.so'
# 	no file '/usr/lib/lua/loadall.so'
# 	no file './resty.so'
# 	no file '/usr/lib/lua/resty.so'
# 	no file '/usr/lib/lua/resty.so'
# 	no file '/usr/lib/lua/loadall.so')
# fix lua-nginx-module >= 0.10.16, start error
# failed to load the 'resty.core' module (https://github.com/openresty/lua-resty-core); ensure you are using an OpenResty release from https://openresty.org/en/download.html (reason: module 'resty.core' not found:
# 	no field package.preload['resty.core']
# 	no file './resty/core.lua'
# 	no file '/usr/share/luajit-2.1.0-beta3/resty/core.lua'
# 	no file '/usr/share/lua/resty/core.lua'
# 	no file '/usr/share/lua/resty/core/init.lua'
# 	no file '/usr/share/lua/resty/core.lua'
# 	no file '/usr/share/lua/resty/core/init.lua'
# 	no file './resty/core.so'
# 	no file '/usr/lib/lua/resty/core.so'
# 	no file '/usr/lib/lua/resty/core.so'
# 	no file '/usr/lib/lua/loadall.so'
# 	no file './resty.so'
# 	no file '/usr/lib/lua/resty.so'
# 	no file '/usr/lib/lua/resty.so'
# 	no file '/usr/lib/lua/loadall.so') in /etc/nginx/uci.conf:52
# install lua-resty-core, required lua-resty-lrucache ngx_devel_kit
#sed -i 's/$(PKG_UNPACK)/git clone https:\/\/github\.com\/openresty\/lua-resty-core \$(PKG_BUILD_DIR)\/lua-resty-core\n\t&/' feeds/packages/net/nginx/Makefile
#sed -i "s/define Package\/nginx-ssl\/install/&\n\t\$(INSTALL_DIR) \$(1)\/etc\/nginx\/lib\/resty\/core\n\t\$(INSTALL_DIR) \$(1)\/etc\/nginx\/lib\/ngx\/ssl\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-core\/lib\/resty\/\*\.lua \$(1)\/etc\/nginx\/lib\/resty\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-core\/lib\/resty\/core\/\*\.lua \$(1)\/etc\/nginx\/lib\/resty\/core\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-core\/lib\/ngx\/\*\.lua \$(1)\/etc\/nginx\/lib\/ngx\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-core\/lib\/ngx\/ssl\/\*\.lua \$(1)\/etc\/nginx\/lib\/ngx\/ssl/" feeds/packages/net/nginx/Makefile
# install lua-resty-lrucache
#sed -i 's/$(PKG_UNPACK)/git clone https:\/\/github\.com\/openresty\/lua-resty-lrucache \$(PKG_BUILD_DIR)\/lua-resty-lrucache\n\t&/' feeds/packages/net/nginx/Makefile
#sed -i "s/define Package\/nginx-ssl\/install/&\n\t\$(INSTALL_DIR) \$(1)\/etc\/nginx\/lib\/resty\/lrucache\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-lrucache\/lib\/resty\/\*\.lua \$(1)\/etc\/nginx\/lib\/resty\n\t\$(CP) \$(PKG_BUILD_DIR)\/lua-resty-lrucache\/lib\/resty\/lrucache\/\*\.lua \$(1)\/etc\/nginx\/lib\/resty\/lrucache/" feeds/packages/net/nginx/Makefile
# install ngx_devel_kit
#sed -i 's/$(PKG_UNPACK)/git clone https:\/\/github\.com\/vision5\/ngx_devel_kit \$(PKG_BUILD_DIR)\/ngx_devel_kit\n\t&/' feeds/packages/net/nginx/Makefile
#sed -i 's/with-cc-opt="/add-module=\$(PKG_BUILD_DIR)\/ngx_devel_kit --&/' feeds/packages/net/nginx/Makefile
# add necessary `lua_package_path` directive to `nginx.conf`, in the http context
#sed -i 's/http {/&\n\tlua_package_path "\/etc\/nginx\/lib\/?\.lua;;";\n/' feeds/packages/net/nginx-util/files/uci.conf.template

# fix lua-nginx-module >= 0.10.15 after install lua-resty-core lua-resty-lrucache ngx_devel_kit and add lua_package_path, start warning
# lua_load_resty_core failed to load the resty.core module from https://github.com/openresty/lua-resty-core; ensure you are using an OpenResty release from https://openresty.org/en/download.html (rc: 2, reason: /etc/nginx/lib/resty/core/time.lua:43: Symbol not found: ngx_http_lua_ffi_now)
# fix lua-nginx-module >= 0.10.16 after install lua-resty-core lua-resty-lrucache ngx_devel_kit and add lua_package_path, start error
# failed to load the 'resty.core' module (https://github.com/openresty/lua-resty-core); ensure you are using an OpenResty release from https://openresty.org/en/download.html (reason: /etc/nginx/lib/resty/core/var.lua:44: Symbol not found: ngx_http_lua_ffi_var_get) in /etc/nginx/uci.conf:54
# todo

# fix lua-nginx-module >= 0.10.16, compile error
# 100-no_by_lua_block.patch Hunk #3 FAILED at 209
#sed -i '38c\       (void *) ngx_http_lua_exit_worker_by_file },' feeds/packages/net/nginx/patches/lua-nginx/100-no_by_lua_block.patch
#sed -i '42c\     /* set_by_lua_block $res { inline Lua code } */' feeds/packages/net/nginx/patches/lua-nginx/100-no_by_lua_block.patch

# fix lua-nginx-module >= 0.10.21, compile error
# 100-no_by_lua_block.patch Hunk #18 FAILED at 517
#sed -i '180c\       NGX_HTTP_SRV_CONF_OFFSET,' feeds/packages/net/nginx/patches/lua-nginx/100-no_by_lua_block.patch
#sed -i '181c\       0,' feeds/packages/net/nginx/patches/lua-nginx/100-no_by_lua_block.patch
#sed -i '182c\       (void *) ngx_http_lua_ssl_client_hello_handler_file },' feeds/packages/net/nginx/patches/lua-nginx/100-no_by_lua_block.patch

# fix dynamic modules .so file have the exact size of 4099
#sed -i "s/include \$(TOPDIR)\/rules\.mk/&\nSTRIP:=:\nRSTRIP:=:/" feeds/packages/net/nginx/Makefile

# add necessary `load_module` directive to `nginx.conf`, in the main context, before events context
#sed -i 's/events {/load_module \/usr\/modules\/ngx_http_lua_module\.so;\n\n&/' feeds/packages/net/nginx-util/files/uci.conf.template

# fix compile lua-nginx-module as dynamic module, start error
# dlsym() "/usr/modules/ngx_http_lua_module.so", "ngx_modules" failed (Symbol not found: ngx_modules) in /etc/nginx/uci.conf:9
# todo

# lua-resty-core 0.1.24 required lua-nginx-module 0.10.22
# lua-resty-core 0.1.23 required lua-nginx-module 0.10.21
# lua-resty-core 0.1.22 required lua-nginx-module 0.10.19 or 0.10.20
# lua-resty-core 0.1.21 required lua-nginx-module 0.10.18 or 0.10.19
# lua-resty-core 0.1.20 required lua-nginx-module 0.10.18
# lua-resty-core 0.1.19 required lua-nginx-module 0.10.16 or 0.10.17
# lua-resty-core 0.1.18 required lua-nginx-module 0.10.16
# lua-resty-core 0.1.17 required lua-nginx-module 0.10.15
# lua-resty-core 0.1.16 required lua-nginx-module 0.10.14

# Modify default timezone
echo 'Modify default timezone...'
sed -i "s/'UTC'/'CST-8'\n\t\tset system.@system[-1].zonename='Asia\/Shanghai'/" package/base-files/files/bin/config_generate

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/0.openwrt.pool.ntp.org/ntp.ntsc.ac.cn/' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp.aliyun.com/' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/cn.ntp.org.cn/' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/pool.ntp.org/' package/base-files/files/bin/config_generate

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

# 设置密码为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/' package/base-files/files/etc/shadow

# 修改无线国家代码、开关、命名、加密方式及密码
sed -i "s/\${s}.disabled='1'/\${s}.country=US\nset \${s}.disabled='0'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.ssid='OpenWrt'/wireless.default_radio0.ssid='${WIFI_SSID}'\nset wireless.default_radio1.ssid='${WIFI_SSID}_2.4G'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.encryption='none'/\${si}.encryption='psk-mixed'\nset \${si}.key='${WIFI_KEY}'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

# hijack dns queries to router(firewall)
sed -i '/REDIRECT --to-ports 53/d' package/network/config/firewall/files/firewall.user
# 把局域网内所有客户端对外ipv4的53端口查询请求，都劫持指向路由器(iptables -n -t nat -L PREROUTING -v --line-number)(iptables -t nat -D PREROUTING 2)
echo 'iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo 'iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
# 把局域网内所有客户端对外ipv6的53端口查询请求，都劫持指向路由器(ip6tables -n -t nat -L PREROUTING -v --line-number)(ip6tables -t nat -D PREROUTING 1)
echo '[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo '[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user

# 修改初始化配置
touch package/base-files/files/etc/custom.tag
sed -i '/exit 0/d' package/base-files/files/etc/rc.local
cat >> package/base-files/files/etc/rc.local << EOFEOF
PPPOE_USERNAME=""
PPPOE_PASSWORD=""
DDNS_USERNAME=""
DDNS_PASSWORD=""
SSR_SUBSCRIBE_URL=""
SSR_SAVE_WORDS=""
SSR_GLOBAL_SERVER=""

refresh_ad_conf() {
    sleep 30

    # 检查拦截列表
    # grep -v "\."                     /etc/smartdns/ad.conf
    # grep "address /api.xiaomi.com/#" /etc/smartdns/ad.conf
    # grep "cnbj2.fds.api.xiaomi.com"  /etc/smartdns/ad.conf
    # grep "*"                         /etc/smartdns/ad.conf
    # grep "address /\."               /etc/smartdns/ad.conf
    # grep "\./#"                      /etc/smartdns/ad.conf
    # grep "pv.kuaizhan.com"           /etc/smartdns/ad.conf
    # grep "changyan.sohu.com"         /etc/smartdns/ad.conf
    # grep "address /.*#.*/#"          /etc/smartdns/ad.conf
    # grep "address /.*[ ].*/#"        /etc/smartdns/ad.conf
    cat > /etc/smartdns/aaa.conf << EOF
address /ad.xiaomi.com/#
address /ad1.xiaomi.com/#
address /ad.mi.com/#
address /tat.pandora.xiaomi.com/#
address /fix.hpplay.cn/#
address /rps.hpplay.cn/#
address /imdns.hpplay.cn/#
address /devicemgr.hpplay.cn/#
address /rp.hpplay.cn/#
address /tvapp.hpplay.cn/#
address /pin.hpplay.cn/#
address /adcdn.hpplay.cn/#
address /sl.hpplay.cn/#
address /vipauth.hpplay.cn/#
address /vipsdkauth.hpplay.cn/#
address /sdkauth.hpplay.cn/#
address /adeng.hpplay.cn/#
address /conf.hpplay.cn/#
address /image.hpplay.cn/#
address /hotupgrade.hpplay.cn/#
address /t7z.cupid.ptqy.gitv.tv/#
address /cloud.hpplay.cn/#
address /ad.hpplay.cn/#
address /adc.hpplay.cn/#
address /gslb.hpplay.cn/#
address /cdn1.hpplay.cn/#
address /ftp.hpplay.com.cn/#
address /rp.hpplay.com.cn/#
address /cdn.hpplay.com.cn/#
address /userapi.hpplay.com.cn/#
address /leboapi.hpplay.com.cn/#
address /api.hpplay.com.cn/#
address /h5.hpplay.com.cn/#
address /hpplay.cdn.cibn.cc/#
address /logonext.tv.kuyun.com/#
address /config.kuyun.com/#
address /f5.market.xiaomi.com/#
address /f4.market.xiaomi.com/#
address /f3.market.xiaomi.com/#
address /f2.market.xiaomi.com/#
address /f1.market.xiaomi.com/#
address /video.market.xiaomi.com/#
address /f5.market.mi-img.com/#
address /f4.market.mi-img.com/#
address /f3.market.mi-img.com/#
address /f2.market.mi-img.com/#
address /f1.market.mi-img.com/#
address /519332DA.dr.youme.im/#
address /aiseet.aa.aisee.tv/#
address /api.hismarttv.com/#
address /e.dangbei.com/#
address /g.dtv.cn.miaozhan.com/#
address /i.mxplayer.j2inter.com/#
address /icsc.sps.expressplay.cn/#
address /misc.in.duokanbox.com/#
address /natdetection.onethingpcs.com/#
address /p2sdk1.mona.p2cdn.com/#
address /pandora.mi.com/#
address /loc.map.baidu.com/#
address /ofloc.map.baidu.com/#
address /si.super-ssp.tv/#
address /sr.super-ssp.tv/#
address /yt3.ggpht.com/#
address /tv.aiseet.atianqi.com/#
address /vv.play.aiseet.atianqi.com/#
address /userapi.hpplay.cn/#
address /pay.hpplay.cn/#
address /tvapi.hpplay.com.cn/#
address /switch.hpplay.com.cn/#
address /lic.hpplay.com.cn/#
address /data.hpplay.com.cn/#
address /upgrade.ptmi.gitv.tv/#
address /appstore.ptmi.gitv.tv/#
address /gamecenter.ptmi.gitv.tv/#
address /p2pupdate.inter.ptqy.gitv.tv/#
address /data.video.ptqy.gitv.tv/#
address /auth.api.gitv.tv/#
address /tv.weixin.pandora.xiaomi.com/#
address /tvmanager.pandora.xiaomi.com/#
address /tvmgr.pandora.xiaomi.com/#
address /redirect.pandora.xiaomi.com/#
address /package.cdn.pandora.xiaomi.com/#
address /ota.cdn.pandora.xiaomi.com/#
address /milink.pandora.xiaomi.com/#
address /appstore.cdn.pandora.xiaomi.com/#
address /appstore.pandora.xiaomi.com/#
address /assistant.pandora.xiaomi.com/#
address /broker.mqtt.pandora.xiaomi.com/#
address /staging.ai.api.xiaomi.com/#
address /as.xiaomi.com/#
address /d1.xiaomi.com/#
address /market.xiaomi.com/#
address /file.xmpush.xiaomi.com/#
address /tracker.live.xycdn.com/#
EOF
    # -t 重试次数 -T 超时时间 -c 断点续传 -P 下载到指定路径 -q 不显示执行过程 -O 以指定的文件名保存 -O- 以'-'作为file参数，将数据打印到标准输出，通常为控制台
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf || if [ -f "/etc/smartdns/anti-ad-smartdns.conf" ]; then rm /etc/smartdns/anti-ad-smartdns.conf; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/anti-ad-smartdns.conf" ]; then
        grep "^address" /etc/smartdns/anti-ad-smartdns.conf | grep -v "address /pv.kuaizhan.com/#" | grep -v "address /changyan.sohu.com/#" >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/anti-ad-smartdns.conf
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/neodevpro/neodevhost/master/smartdns.conf || if [ -f "/etc/smartdns/smartdns.conf" ]; then rm /etc/smartdns/smartdns.conf; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/smartdns.conf" ]; then
        grep "^address" /etc/smartdns/smartdns.conf | grep "\." | grep -v "address /pv.kuaizhan.com/#" | grep -v "address /changyan.sohu.com/#" | sed 's/\.\/#$/\/#/g' >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/smartdns.conf
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/AdAway/adaway.github.io/master/hosts.txt || if [ -f "/etc/smartdns/hosts.txt" ]; then rm /etc/smartdns/hosts.txt; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/hosts.txt" ]; then
        grep "^127" /etc/smartdns/hosts.txt > /etc/smartdns/host
        sed -i '1d' /etc/smartdns/host
        sed -i 's/127.0.0.1 /address \//g;s/$/\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/host
        rm -f /etc/smartdns/hosts.txt
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/FuckNoMotherCompanyAlliance/Fuck_CJMarketing_hosts/master/hosts || if [ -f "/etc/smartdns/hosts" ]; then rm /etc/smartdns/hosts; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/hosts" ]; then
        grep "^0" /etc/smartdns/hosts | tr -d "\r" > /etc/smartdns/host
        sed -i 's/www.xitongqingli.com /www.xitongqingli.com/' /etc/smartdns/host
        sed -i 's/0.0.0.0 /address \//g;s/$/\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/host
        rm -f /etc/smartdns/hosts
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/Goooler/1024_hosts/master/hosts || if [ -f "/etc/smartdns/hosts" ]; then rm /etc/smartdns/hosts; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/hosts" ]; then
        grep "^127" /etc/smartdns/hosts | tr -d "\r" | sed 's/\.$//g' > /etc/smartdns/host
        sed -i 's/127.0.0.1 /address \//g;s/$/\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/host
        rm -f /etc/smartdns/hosts
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/VeleSila/yhosts/master/hosts.txt || if [ -f "/etc/smartdns/hosts.txt" ]; then rm /etc/smartdns/hosts.txt; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/hosts.txt" ]; then
        grep "^0" /etc/smartdns/hosts.txt | grep -v "0.0.0.0 XiaoQiang" | grep -v "0.0.0.0 localhost" | sed 's/\.$//g' > /etc/smartdns/host.txt
        sed -i 's/0.0.0.0 /address \//g;s/$/\/#/g' /etc/smartdns/host.txt
        cat /etc/smartdns/host.txt >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/host.txt
        rm -f /etc/smartdns/hosts.txt
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts || if [ -f "/etc/smartdns/hosts" ]; then rm /etc/smartdns/hosts; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/hosts" ]; then
        grep "^0" /etc/smartdns/hosts | sed 's/[ ]*#.*$//g' > /etc/smartdns/host.txt
        sed -i '1d' /etc/smartdns/host.txt
        sed -i 's/0.0.0.0 /address \//g;s/$/\/#/g' /etc/smartdns/host.txt
        cat /etc/smartdns/host.txt | grep -v "address /inf/#" | grep -v "address /fe/#" | grep -v "address /ff/#" >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/host.txt
        rm -f /etc/smartdns/hosts
    fi
    (wget -t 5 -T 5 -c -P /etc/smartdns --no-check-certificate --header "Host: raw.githubusercontent.com" https://185.199.109.133/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt || if [ -f "/etc/smartdns/reject-list.txt" ]; then rm /etc/smartdns/reject-list.txt; fi) >> /etc/custom.tag 2>&1
    if [ -f "/etc/smartdns/reject-list.txt" ]; then
        sed -i 's/^/address \//g;s/$/\/#/g' /etc/smartdns/reject-list.txt
        cat /etc/smartdns/reject-list.txt | grep -v "address /pv.kuaizhan.com/#" >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/reject-list.txt
    fi
    sort -u /etc/smartdns/aaa.conf > /etc/smartdns/ad.conf
    rm -f /etc/smartdns/aaa.conf
    /etc/init.d/smartdns restart >> /etc/custom.tag 2>&1
    echo "smartdns block ad domain list finish" >> /etc/custom.tag
}

init_custom_config() {
    uci set smartdns.cfg016bb1.enabled='1'
    uci set smartdns.cfg016bb1.server_name='smartdns'
    uci set smartdns.cfg016bb1.port='53'
    uci set smartdns.cfg016bb1.auto_set_dnsmasq='1'
    uci set smartdns.cfg016bb1.tcp_server='1'
    uci set smartdns.cfg016bb1.ipv6_server='1'
    uci set smartdns.cfg016bb1.bind_device='0'
    uci set smartdns.cfg016bb1.dualstack_ip_selection='1'
    uci set smartdns.cfg016bb1.prefetch_domain='1'
    uci set smartdns.cfg016bb1.serve_expired='1'
    uci set smartdns.cfg016bb1.cache_size='16384'
    uci set smartdns.cfg016bb1.cache_persist='1'
    uci set smartdns.cfg016bb1.resolve_local_hostnames='1'
    uci set smartdns.cfg016bb1.force_aaaa_soa='0'
    uci set smartdns.cfg016bb1.force_https_soa='0'
    uci set smartdns.cfg016bb1.rr_ttl='30'
    uci set smartdns.cfg016bb1.rr_ttl_min='30'
    uci set smartdns.cfg016bb1.rr_ttl_max='300'
    uci set smartdns.cfg016bb1.seconddns_enabled='1'
    uci set smartdns.cfg016bb1.seconddns_port='5335'
    uci set smartdns.cfg016bb1.seconddns_tcp_server='0'
    uci set smartdns.cfg016bb1.seconddns_server_group='oversea'
    uci set smartdns.cfg016bb1.seconddns_no_speed_check='1'
    uci set smartdns.cfg016bb1.seconddns_no_rule_addr='0'
    uci set smartdns.cfg016bb1.seconddns_no_rule_nameserver='1'
    uci set smartdns.cfg016bb1.seconddns_no_rule_ipset='0'
    uci set smartdns.cfg016bb1.seconddns_no_rule_soa='0'
    uci set smartdns.cfg016bb1.seconddns_no_dualstack_selection='1'
    uci set smartdns.cfg016bb1.seconddns_no_cache='1'
    uci set smartdns.cfg016bb1.seconddns_force_aaaa_soa='1'
    uci set smartdns.cfg016bb1.coredump='0'
    uci commit smartdns
    touch /etc/smartdns/ad.conf
    cat >> /etc/smartdns/custom.conf << EOF


# Include another configuration options
conf-file /etc/smartdns/ad.conf

# remote dns server list
server 114.114.114.114 -group china #114DNS
server 114.114.115.115 -group china #114DNS
server 119.29.29.29 -group china #TencentDNS
server 182.254.116.116 -group china #TencentDNS
server 2402:4e00:: -group china #TencentDNS
server-tls 223.5.5.5 -group china -group bootstrap #AlibabaDNS
server-tls 223.6.6.6 -group china -group bootstrap #AlibabaDNS
server-tls 2400:3200::1 -group china -group bootstrap #AlibabaDNS
server-tls 2400:3200:baba::1 -group china -group bootstrap #AlibabaDNS
server 180.76.76.76 -group china #BaiduDNS
nameserver /cloudflare-dns.com/bootstrap
nameserver /dns.google/bootstrap
nameserver /doh.opendns.com/bootstrap
server-tls 1.1.1.1 -group oversea -exclude-default-group #CloudflareDNS
server-tls 1.0.0.1 -group oversea -exclude-default-group #CloudflareDNS
server-https https://cloudflare-dns.com/dns-query -group oversea -exclude-default-group #CloudflareDNS
server-tls 8.8.8.8 -group oversea -exclude-default-group #GoogleDNS
server-tls 8.8.4.4 -group oversea -exclude-default-group #GoogleDNS
server-https https://dns.google/dns-query -group oversea -exclude-default-group #GoogleDNS
server-tls 208.67.222.222 -group oversea -exclude-default-group #OpenDNS
server-tls 208.67.220.220 -group oversea -exclude-default-group #OpenDNS
server-https https://doh.opendns.com/dns-query -group oversea -exclude-default-group #OpenDNS
EOF
    /etc/init.d/smartdns restart >> /etc/custom.tag 2>&1
    echo "smartdns remote dns server list finish" >> /etc/custom.tag

    #uci set network.wan.proto='pppoe'
    #uci set network.wan.username="\${PPPOE_USERNAME}"
    #uci set network.wan.password="\${PPPOE_PASSWORD}"
    #uci set network.wan.ipv6='auto'
    #uci set network.wan.peerdns='0'
    #uci add_list network.wan.dns='127.0.0.1'
    #uci set network.modem=interface
    #uci set network.modem.proto='dhcp'
    #uci set network.modem.device='eth0'
    #uci set network.modem.defaultroute='0'
    #uci set network.modem.peerdns='0'
    #uci set network.modem.delegate='0'
    #uci commit network
    #/etc/init.d/network restart >> /etc/custom.tag 2>&1
    #echo "network finish" >> /etc/custom.tag

    #uci add_list firewall.cfg03dc81.network='modem'
    #uci commit firewall
    # hijack dns queries to router(firewall4)
    # 把局域网内所有客户端对外ipv4和ipv6的53端口查询请求，都劫持指向路由器(nft list chain inet fw4 dns-redirect)(nft delete chain inet fw4 dns-redirect)
    cat >> /etc/nftables.d/10-custom-filter-chains.nft << EOF
chain dns-redirect {
    type nat hook prerouting priority -105;
    udp dport 53 counter redirect to :53
    tcp dport 53 counter redirect to :53
}

EOF
    /etc/init.d/firewall restart >> /etc/custom.tag 2>&1
    echo "firewall finish" >> /etc/custom.tag

    uci set ttyd.cfg01a8ea.ssl='1'
    uci set ttyd.cfg01a8ea.ssl_cert='/etc/nginx/conf.d/_lan.crt'
    uci set ttyd.cfg01a8ea.ssl_key='/etc/nginx/conf.d/_lan.key'
    uci commit ttyd
    /etc/init.d/ttyd restart >> /etc/custom.tag 2>&1
    echo "ttyd finish" >> /etc/custom.tag

    uci set autoreboot.cfg01f8be.enable='1'
    uci set autoreboot.cfg01f8be.week='7'
    uci set autoreboot.cfg01f8be.hour='4'
    uci set autoreboot.cfg01f8be.minute='30'
    uci commit autoreboot
    /etc/init.d/autoreboot restart >> /etc/custom.tag 2>&1
    echo "autoreboot finish" >> /etc/custom.tag

    sleep 30

    # 强制走代理的域名
    echo "cloudflare-dns.com" >> /etc/ssrplus/black.list
    echo "dns.google" >> /etc/ssrplus/black.list
    echo "doh.opendns.com" >> /etc/ssrplus/black.list
    # 强制走代理的 WAN IP
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='1.1.1.1'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='1.0.0.1'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='8.8.8.8'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='8.8.4.4'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='208.67.222.222'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='208.67.220.220'
    uci set shadowsocksr.cfg029e1d.auto_update='1'
    uci set shadowsocksr.cfg029e1d.auto_update_time='5'
    uci add_list shadowsocksr.cfg029e1d.subscribe_url="\${SSR_SUBSCRIBE_URL}"
    uci set shadowsocksr.cfg029e1d.save_words="\${SSR_SAVE_WORDS}"
    uci set shadowsocksr.cfg029e1d.switch='1'
    uci commit shadowsocksr
    /usr/bin/lua /usr/share/shadowsocksr/subscribe.lua >> /etc/custom.tag
    uci set shadowsocksr.cfg013fd6.global_server="\${SSR_GLOBAL_SERVER}"
    uci set shadowsocksr.cfg013fd6.pdnsd_enable='0'
    uci commit shadowsocksr
    /etc/init.d/shadowsocksr restart >> /etc/custom.tag 2>&1
    echo "shadowsocksr finish" >> /etc/custom.tag

    refresh_ad_conf

    uci set ddns.test=service
    uci set ddns.test.service_name='cloudflare.com-v4'
    uci set ddns.test.use_ipv6='1'
    uci set ddns.test.enabled='1'
    uci set ddns.test.lookup_host='test.5icodes.com'
    uci set ddns.test.domain='test@5icodes.com'
    uci set ddns.test.username="\${DDNS_USERNAME}"
    uci set ddns.test.password="\${DDNS_PASSWORD}"
    uci set ddns.test.ip_source='network'
    uci set ddns.test.ip_network='wan6'
    uci set ddns.test.interface='wan6'
    uci set ddns.test.use_syslog='2'
    uci set ddns.test.check_unit='minutes'
    uci set ddns.test.force_unit='minutes'
    uci set ddns.test.retry_unit='seconds'
    uci commit ddns
    /etc/init.d/ddns restart >> /etc/custom.tag 2>&1
    echo "ddns finish" >> /etc/custom.tag

    # crontab -l 查看计划表
    uci set acme.cfg01f3db.account_email="\${DDNS_USERNAME}"
    uci set acme.cfg01f3db.debug='1'

    uci set acme.test=cert
    uci set acme.test.enabled='1'
    uci set acme.test.use_staging='0'
    uci set acme.test.key_type='rsa2048'
    uci add_list acme.test.domains='test.5icodes.com'
    uci set acme.test.update_uhttpd='0'
    uci set acme.test.update_nginx='0'
    uci set acme.test.validation_method='dns'
    uci set acme.test.dns='dns_cf'
    uci add_list acme.test.credentials="CF_Email=\${DDNS_USERNAME}"
    uci add_list acme.test.credentials="CF_Key=\${DDNS_PASSWORD}"

    uci set acme.wildcard=cert
    uci set acme.wildcard.enabled='1'
    uci set acme.wildcard.use_staging='0'
    uci set acme.wildcard.key_type='rsa2048'
    uci add_list acme.wildcard.domains='5icodes.com'
    uci add_list acme.wildcard.domains='*.5icodes.com'
    uci set acme.wildcard.update_uhttpd='0'
    uci set acme.wildcard.update_nginx='0'
    uci set acme.wildcard.validation_method='dns'
    uci set acme.wildcard.dns='dns_cf'
    uci add_list acme.wildcard.credentials="CF_Email=\${DDNS_USERNAME}"
    uci add_list acme.wildcard.credentials="CF_Key=\${DDNS_PASSWORD}"

    uci commit acme
    /etc/init.d/acme restart >> /etc/custom.tag 2>&1
    mkdir -p /data/5icodes.com/test./cert
    /usr/lib/acme/client/acme.sh --home "/etc/acme" --install-cert -d test.5icodes.com --key-file /data/5icodes.com/test./cert/_lan.key --fullchain-file /data/5icodes.com/test./cert/_lan.crt --reloadcmd "service nginx reload" >> /etc/custom.tag 2>&1
    mkdir -p /data/5icodes.com/cert
    /usr/lib/acme/client/acme.sh --home "/etc/acme" --install-cert -d 5icodes.com --key-file /data/5icodes.com/cert/_lan.key --fullchain-file /data/5icodes.com/cert/_lan.crt --reloadcmd "service nginx reload" >> /etc/custom.tag 2>&1
    echo "acme finish" >> /etc/custom.tag

    # to generate your dhparam.pem file, run in the terminal
    openssl dhparam -out /data/5icodes.com/cert/dhparam.pem 2048 >> /etc/custom.tag 2>&1
    echo "dhparam finish" >> /etc/custom.tag
}

if [ -f "/etc/custom.tag" ]; then
    echo "smartdns block ad domain list start" > /etc/custom.tag
    refresh_ad_conf &
else
    echo "init custom config start" > /etc/custom.tag
    init_custom_config &
fi

echo "rc.local finish" >> /etc/custom.tag

exit 0
EOFEOF

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

#修复netdata缺少jquery-2.2.4.min.js的问题，有两种解决方式
#1、不使用汉化，使用lede仓库的luci-app-netdata插件，https://github.com/coolsnowwolf/luci/tree/master/applications/luci-app-netdata
#2、要使用汉化，回滚netdata版本至1.30.1
#cd feeds/packages
#git config --global user.email "i@5icodes.com"
#git config --global user.name "hnyyghk"
#git revert --no-edit 1278eec776e86659b3e812148796a53d0f865edc
#cd ../../

#netdata不支持ssl访问，有两种解决方式
#1、修改编译配置使netdata原生支持ssl访问，参考https://www.right.com.cn/forum/thread-4045278-1-1.html
#sed -i 's/disable-https/enable-https/' feeds/packages/admin/netdata/Makefile
#sed -i 's/DEPENDS:=/DEPENDS:=+libopenssl /' feeds/packages/admin/netdata/Makefile
#sed -i 's/\[web\]/[web]\n\tssl certificate = \/etc\/nginx\/conf.d\/_lan.crt\n\tssl key = \/etc\/nginx\/conf.d\/_lan.key/' feeds/kenzo/luci-app-netdata/root/etc/netdata/netdata.conf
#2、修改netdata页面端口，配置反向代理http协议19999端口至https协议19998端口，参考https://blog.csdn.net/lawsssscat/article/details/107298336
#添加/etc/nginx/conf.d/ssl2netdata.conf如下：
#server {
#    listen 19998 ssl;
#    listen [::]:19998 ssl;
#    server_name _ssl2netdata;
#    include restrict_locally;
#    ssl_certificate /etc/nginx/conf.d/_lan.crt;
#    ssl_certificate_key /etc/nginx/conf.d/_lan.key;
#    ssl_session_cache shared:SSL:32k;
#    ssl_session_timeout 64m;
#    location / {
#        proxy_set_header Host $http_host;
#        proxy_set_header X-Real-IP $remote_addr;
#        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto $scheme;
#        proxy_pass http://localhost:19999;
#    }
#}
