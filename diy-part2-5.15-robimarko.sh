#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2-5.15-robimarko.sh
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

# 修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# 设置密码为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/' package/base-files/files/etc/shadow

# Ax6修改无线国家代码、开关、命名、加密方式及密码
sed -i 's/radio${devidx}.disabled=1/radio${devidx}.country=CN\n\t\t\tset wireless.radio${devidx}.disabled=0/' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/radio\${devidx}.ssid=OpenWrt/radio0.ssid=${WIFI_SSID}\n\t\t\tset wireless.default_radio1.ssid=${WIFI_SSID}_2.4G/" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/radio\${devidx}.encryption=none/radio\${devidx}.encryption=psk-mixed\n\t\t\tset wireless.default_radio\${devidx}.key=${WIFI_KEY}/" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改初始化配置
touch package/base-files/files/etc/custom.tag
sed -i '/exit 0/d' package/base-files/files/etc/rc.local
cat >> package/base-files/files/etc/rc.local << EOFEOF
PPPOE_USERNAME=""
PPPOE_PASSWORD=""
DDNS_USERNAME=""
DDNS_PASSWORD=""
SSR_SUBSCRIBE_URL1=""
SSR_SUBSCRIBE_URL2=""
SSR_FILTER_WORDS=""
SSR_SAVE_WORDS=""
SSR_GLOBAL_SERVER=""

refresh_ad_conf() {
    sleep 30

    wget -c -P /etc/smartdns https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/anti-ad-smartdns.conf" ];then
        grep "^address" /etc/smartdns/anti-ad-smartdns.conf >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/anti-ad-smartdns.conf
    fi
    wget -c -P /etc/smartdns https://raw.githubusercontent.com/neodevpro/neodevhost/master/smartdns.conf 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/smartdns.conf" ];then
        grep "^address" /etc/smartdns/smartdns.conf >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/smartdns.conf
    fi
    wget -c -P /etc/smartdns https://raw.githubusercontent.com/jdlingyu/ad-wars/master/sha_ad_hosts 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/sha_ad_hosts" ];then
        grep "^127" /etc/smartdns/sha_ad_hosts > /etc/smartdns/host
        sed -i '1d' /etc/smartdns/host
        sed -i 's/127.0.0.1 /address \//g;s/$/&\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/sha_ad_hosts
        rm -f /etc/smartdns/host
    fi
    wget -c -P /etc/smartdns https://raw.githubusercontent.com/FuckNoMotherCompanyAlliance/Fuck_CJMarketing_hosts/master/hosts 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/hosts" ];then
        grep "^0" /etc/smartdns/hosts > /etc/smartdns/host
        sed -i 's/0.0.0.0 /address \//g;s/$/&\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host | tr -d "\r" >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/hosts
        rm -f /etc/smartdns/host
    fi
    wget -c -P /etc/smartdns https://raw.githubusercontent.com/Goooler/1024_hosts/master/hosts 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/hosts" ];then
        grep "^127" /etc/smartdns/hosts > /etc/smartdns/host
        sed -i 's/127.0.0.1 /address \//g;s/$/&\/#/g' /etc/smartdns/host
        cat /etc/smartdns/host | tr -d "\r" >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/hosts
        rm -f /etc/smartdns/host
    fi
    wget -c -P /etc/smartdns https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts.txt 2>> /etc/custom.tag
    if [ -f "/etc/smartdns/hosts.txt" ];then
        grep "^0" /etc/smartdns/hosts.txt > /etc/smartdns/host.txt
        sed -i 's/0.0.0.0 /address \//g;s/$/&\/#/g' /etc/smartdns/host.txt
        cat /etc/smartdns/host.txt >> /etc/smartdns/aaa.conf
        rm -f /etc/smartdns/hosts.txt
        rm -f /etc/smartdns/host.txt
    fi
    cat >> /etc/smartdns/aaa.conf << EOF
address /ad.xiaomi.com/#
address /ad1.xiaomi.com/#
address /ad.mi.com/#
address /tat.pandora.xiaomi.com/#
address /api.ad.xiaomi.com/#
address /t7z.cupid.ptqy.gitv.tv/#
address /fix.hpplay.cn/#
address /rps.hpplay.cn/#
address /imdns.hpplay.cn/#
address /f5.market.mi-img.com/#
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
EOF
    echo "# block ad domain list" > /etc/smartdns/ad.conf
    sort -u /etc/smartdns/aaa.conf >> /etc/smartdns/ad.conf
    rm -f /etc/smartdns/aaa.conf
    /etc/init.d/smartdns restart >> /etc/custom.tag
    echo "smartdns block ad domain list finish" >> /etc/custom.tag
}

init_custom_config() {
    sleep 30

    uci set dhcp.cfg01411c.port='6053'
    uci commit dhcp
    /etc/init.d/dnsmasq restart >> /etc/custom.tag
    echo "dnsmasq finish" >> /etc/custom.tag

    uci set smartdns.cfg016bb1.enabled='1'
    uci set smartdns.cfg016bb1.server_name='smartdns'
    uci set smartdns.cfg016bb1.port='53'
    uci set smartdns.cfg016bb1.tcp_server='0'
    uci set smartdns.cfg016bb1.ipv6_server='0'
    uci set smartdns.cfg016bb1.dualstack_ip_selection='1'
    uci set smartdns.cfg016bb1.prefetch_domain='1'
    uci set smartdns.cfg016bb1.serve_expired='1'
    uci set smartdns.cfg016bb1.redirect='none'
    uci set smartdns.cfg016bb1.cache_size='16384'
    uci set smartdns.cfg016bb1.rr_ttl='30'
    uci set smartdns.cfg016bb1.rr_ttl_min='30'
    uci set smartdns.cfg016bb1.rr_ttl_max='300'
    uci set smartdns.cfg016bb1.seconddns_enabled='1'
    uci set smartdns.cfg016bb1.seconddns_port='5335'
    uci set smartdns.cfg016bb1.seconddns_tcp_server='0'
    uci set smartdns.cfg016bb1.seconddns_server_group='oversea'
    uci set smartdns.cfg016bb1.seconddns_no_speed_check='1'
    uci set smartdns.cfg016bb1.seconddns_no_rule_addr='0'
    uci set smartdns.cfg016bb1.seconddns_no_rule_nameserver='0'
    uci set smartdns.cfg016bb1.seconddns_no_rule_ipset='0'
    uci set smartdns.cfg016bb1.seconddns_no_rule_soa='0'
    uci set smartdns.cfg016bb1.seconddns_no_dualstack_selection='0'
    uci set smartdns.cfg016bb1.seconddns_no_cache='0'
    uci set smartdns.cfg016bb1.force_aaaa_soa='0'
    uci set smartdns.cfg016bb1.coredump='0'
    uci del smartdns.cfg016bb1.old_redirect
    uci add_list smartdns.cfg016bb1.old_redirect='none'
    uci del smartdns.cfg016bb1.old_port
    uci add_list smartdns.cfg016bb1.old_port='53'
    uci del smartdns.cfg016bb1.old_enabled
    uci add_list smartdns.cfg016bb1.old_enabled='1'
    uci commit smartdns
    touch /etc/smartdns/ad.conf
    cat >> /etc/smartdns/custom.conf << EOF


# Include another configuration options
conf-file /etc/smartdns/ad.conf

# remote dns server list
server 114.114.114.114 #114DNS
server 114.114.115.115 #114DNS
server 119.29.29.29 #TencentDNS
server 182.254.116.116 #TencentDNS
server 2402:4e00:: #TencentDNS
server 223.5.5.5 #AlibabaDNS
server 223.6.6.6 #AlibabaDNS
server 2400:3200::1 #AlibabaDNS
server 2400:3200:baba::1 #AlibabaDNS
server 180.76.76.76 #BaiduDNS
server 2400:da00::6666 #BaiduDNS
server-tls 1.1.1.1 -group oversea -exclude-default-group #CloudflareDNS
server-tls 1.0.0.1 -group oversea -exclude-default-group #CloudflareDNS
server-https https://dns.cloudflare.com/dns-query -group oversea -exclude-default-group #CloudflareDNS
server-tls 8.8.8.8 -group oversea -exclude-default-group #GoogleDNS
server-tls 8.8.4.4 -group oversea -exclude-default-group #GoogleDNS
server-https https://dns.google/dns-query -group oversea -exclude-default-group #GoogleDNS
server-tls 208.67.222.222 -group oversea -exclude-default-group #OpenDNS
server-tls 208.67.220.220 -group oversea -exclude-default-group #OpenDNS
server-https https://doh.opendns.com/dns-query -group oversea -exclude-default-group #OpenDNS
EOF
    /etc/init.d/smartdns restart >> /etc/custom.tag
    echo "smartdns remote dns server list finish" >> /etc/custom.tag

    uci set network.wan.proto='pppoe'
    uci set network.wan.username="\${PPPOE_USERNAME}"
    uci set network.wan.password="\${PPPOE_PASSWORD}"
    uci set network.wan.ipv6='auto'
    uci set network.wan.peerdns='0'
    uci add_list network.wan.dns='127.0.0.1'
    uci set network.modem=interface
    uci set network.modem.proto='dhcp'
    uci set network.modem.device='eth0'
    uci set network.modem.defaultroute='0'
    uci set network.modem.peerdns='0'
    uci set network.modem.delegate='0'
    uci commit network
    /etc/init.d/network restart >> /etc/custom.tag
    echo "network finish" >> /etc/custom.tag

    sleep 30

    uci add_list firewall.cfg03dc81.network='modem'
    uci commit firewall
    /etc/init.d/firewall restart >> /etc/custom.tag
    echo "firewall finish" >> /etc/custom.tag

    uci set ttyd.cfg01a8ea.ssl='1'
    uci set ttyd.cfg01a8ea.ssl_cert='/etc/nginx/conf.d/_lan.crt'
    uci set ttyd.cfg01a8ea.ssl_key='/etc/nginx/conf.d/_lan.key'
    uci commit ttyd
    /etc/init.d/ttyd restart >> /etc/custom.tag
    echo "ttyd finish" >> /etc/custom.tag

    uci set autoreboot.cfg01f8be.enable='1'
    uci set autoreboot.cfg01f8be.week='7'
    uci set autoreboot.cfg01f8be.hour='3'
    uci set autoreboot.cfg01f8be.minute='30'
    uci commit autoreboot
    /etc/init.d/autoreboot restart >> /etc/custom.tag
    echo "autoreboot finish" >> /etc/custom.tag

    uci set ddns.test=service
    uci set ddns.test.service_name='cloudflare.com-v4'
    uci set ddns.test.use_ipv6='1'
    uci set ddns.test.enabled='1'
    uci set ddns.test.lookup_host='test.5icodes.com'
    uci set ddns.test.domain='test@5icodes.com'
    uci set ddns.test.username="\${DDNS_USERNAME}"
    uci set ddns.test.password="\${DDNS_PASSWORD}"
    uci set ddns.test.ip_source='network'
    uci set ddns.test.ip_network='wan_6'
    uci set ddns.test.interface='wan_6'
    uci set ddns.test.use_syslog='2'
    uci set ddns.test.check_unit='minutes'
    uci set ddns.test.force_unit='minutes'
    uci set ddns.test.retry_unit='seconds'
    uci commit ddns
    /etc/init.d/ddns restart >> /etc/custom.tag
    echo "ddns finish" >> /etc/custom.tag

    echo "dns.cloudflare.com" >> /etc/ssrplus/black.list
    echo "dns.google" >> /etc/ssrplus/black.list
    echo "doh.opendns.com" >> /etc/ssrplus/black.list
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='1.1.1.1'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='1.0.0.1'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='8.8.8.8'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='8.8.4.4'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='208.67.222.222'
    uci add_list shadowsocksr.cfg034417.wan_fw_ips='208.67.220.220'
    uci set shadowsocksr.cfg029e1d.auto_update='1'
    uci set shadowsocksr.cfg029e1d.auto_update_time='4'
    uci add_list shadowsocksr.cfg029e1d.subscribe_url="\${SSR_SUBSCRIBE_URL1}"
    uci add_list shadowsocksr.cfg029e1d.subscribe_url="\${SSR_SUBSCRIBE_URL2}"
    uci set shadowsocksr.cfg029e1d.filter_words="\${SSR_FILTER_WORDS}"
    uci set shadowsocksr.cfg029e1d.save_words="\${SSR_SAVE_WORDS}"
    uci set shadowsocksr.cfg029e1d.switch='1'
    uci commit shadowsocksr
    /usr/bin/lua /usr/share/shadowsocksr/subscribe.lua >> /etc/custom.tag
    uci set shadowsocksr.cfg013fd6.global_server="\${SSR_GLOBAL_SERVER}"
    uci set shadowsocksr.cfg013fd6.pdnsd_enable='0'
    uci del shadowsocksr.cfg013fd6.tunnel_forward
    uci commit shadowsocksr
    /etc/init.d/shadowsocksr restart >> /etc/custom.tag
    echo "shadowsocksr finish" >> /etc/custom.tag

    refresh_ad_conf
}

# 把局域网内所有客户端对外ipv4的53端口查询请求，都劫持指向路由器(iptables -n -t nat -L PREROUTING -v --line-number)(iptables -t nat -D PREROUTING 2)
# allow queries to router
iptables -t nat -A PREROUTING -p udp --dport 53 -d \$(uci get network.lan.ipaddr) -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 53 -d \$(uci get network.lan.ipaddr) -j ACCEPT
# anything else is hijacked
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53
# 把局域网内所有客户端对外ipv6的53端口查询请求，都劫持指向路由器(ip6tables -n -t nat -L PREROUTING -v --line-number)(ip6tables -t nat -D PREROUTING 1)
# allow queries to router
[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -d \$(uci get network.globals.ula_prefix | sed 's/\/48/1/g') -j ACCEPT
[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -d \$(uci get network.globals.ula_prefix | sed 's/\/48/1/g') -j ACCEPT
# anything else is hijacked
[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53
[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53
# 把局域网内所有客户端对外ipv4和ipv6的53端口查询请求，都劫持指向路由器(nft --handle list chain inet fw4 dstnat)(nft delete rule inet fw4 dstnat handle 337)
#nft add rule inet fw4 dstnat udp dport 53 redirect to :53
#nft add rule inet fw4 dstnat tcp dport 53 redirect to :53

if [ -f "/etc/custom.tag" ];then
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
echo " $COMMIT_COMMENT                                               " >> package/base-files/files/etc/banner
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
