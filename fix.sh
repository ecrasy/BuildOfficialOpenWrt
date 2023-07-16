#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2023-07-16 23:50:37 UTC
#########################################################################


#!/bin/bash

# fix error from https://github.com/openwrt/luci/issues/5373
# luci-app-statistics: misconfiguration shipped pointing to non-existent directory
str="^[^#]*option Include '/etc/collectd/conf.d'"
cmd="s@$str@#&@"
sed -ri "$cmd" feeds/luci/applications/luci-app-statistics/root/etc/config/luci_statistics
echo "Fix luci-app-statistics ref wrong path error"

# fix stupid coremark benchmark error
touch package/base-files/files/etc/bench.log
chmod 0666 package/base-files/files/etc/bench.log
echo "Touch coremark log file to fix uhttpd error!!!"

# fix python3.9.12 sys version parse error
# python3_path="feeds/packages/lang/python/python3"
# cp $GITHUB_WORKSPACE/data/patches/lib-platform-sys-version.patch ${python3_path}/patches/
# echo "Fix python host compile install error!!!"

# fixing dnsmasq v2.86 compile error
# from: https://github.com/openwrt/openwrt/issues/9043
dnsmasq_path="package/network/services/dnsmasq"
dnsmasq_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=2.86' ${dnsmasq_path}/Makefile)
if [ ! -z "${dnsmasq_ver}" ]; then
    rm -rf $dnsmasq_path
    cp -r $GITHUB_WORKSPACE/data/dnsmasq ${dnsmasq_path}
    echo "Try dnsmasq v2.89 for openwrt 22.03"
else
# upgrade nftables to version 1.0.5
    nftables_path="package/network/utils/nftables"
    nftables_ver=$(grep -m1 'PKG_VERSION:=0.9.6' ${nftables_path}/Makefile)
    if [ ! -z "${nftables_ver}" ]; then
        rm -rf package/network/utils/nftables
        rm -rf package/libs/libnftnl
        cp -r $GITHUB_WORKSPACE/data/app/nftables package/network/utils/
        cp -r $GITHUB_WORKSPACE/data/app/libnftnl package/libs/
        echo "try nftables version 1.0.6 for dnsmasq v2.87+"
    fi
fi

# make minidlna depends on libffmpeg-full instead of libffmpeg
# little bro ffmpeg mini custom be gone
sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
echo "Set minidlna depends on libffmpeg-full instead of libffmpeg"

# make cshark depends on libustream-openssl instead of libustream-mbedtls
# i fucking hate stupid mbedtls so much, be gone
sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
echo "Set cshark depends on libustream-openssl instead of libustream-mbedtls"

# remove ipv6-helper depends on odhcpd*
sed -i "s/+odhcpd-ipv6only//g" package/feeds/CustomPkgs/ipv6-helper/Makefile
echo "Remove ipv6-helper depends on odhcpd*"

# remove hnetd depends on odhcpd*
sed -i "s/+odhcpd//g" package/feeds/routing/hnetd/Makefile
echo "Remove hnetd depends on odhcpd*"

# make shairplay depends on mdnsd instead of libavahi-compat-libdnssd
sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" feeds/packages/sound/shairplay/Makefile
echo "Set shairplay depends on mdnsd instead of libavahi-compat-libdnssd"

# revert luci-app-firewall commit c54efde
#FW_PATH="feeds/luci/applications/luci-app-firewall/htdocs/luci-static/resources/view/firewall"
#CM_LINE=$(grep -m1 -n 'Enable network address' ${FW_PATH}/zones.js |awk '{ print $1 }' |cut -d':' -f1)
#if [ ! -z "${CM_LINE}" ]; then
#    DL=$CM_LINE
#    RL=$((DL-1))
#    sed -i -e "${DL}d" -e "${RL} s/,$/);/" ${FW_PATH}/zones.js
#    echo "Revert luci-app-firewall commit c54efde"
#fi

# upgrade libtorrent-rasterbar to version 2.0.8
RAS_PATH="feeds/packages/libs/libtorrent-rasterbar"
RAS_VER=$(grep -m1 'PKG_VERSION:=2.0.7' ${RAS_PATH}/Makefile)
if [ ! -z "${RAS_VER}" ]; then
    rm -rf ${RAS_PATH}
    cp -r $GITHUB_WORKSPACE/data/app/libtorrent-rasterbar feeds/packages/libs/
    echo "Try libtorrent-rasterbar v2.0.8 for qBittorrent"
fi

RRDTOOL_PATH="feeds/packages/utils/rrdtool1"
RRDTOOL_URL=$(grep -m1 'PKG_SOURCE_URL:= \\' ${RRDTOOL_PATH}/Makefile)
if [ ! -z "${RRDTOOL_URL}" ]; then
    cp $GITHUB_WORKSPACE/data/patches/rrdtool1-Makefile ${RRDTOOL_PATH}/Makefile
    echo "Fix rrdtool1 package url mirrors error"
fi

GD_PATH="feeds/packages/utils/gptfdisk"
GD_VER=$(grep -m1 'PKG_VERSION:=1.0.9' ${GD_PATH}/Makefile)
if [ ! -z "${GD_VER}" ]; then
    sed -i '0,/^TARGET_CXXFLAGS.*/s/^TARGET_CXXFLAGS.*/TARGET_CFLAGS += -D_LARGEFILE64_SOURCE\n&/' ${GD_PATH}/Makefile
    echo "Fix gptfdisk compile error"
fi

echo -e "Fixing Jobs Completed!!!\n"

