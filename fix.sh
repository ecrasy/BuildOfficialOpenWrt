#########################################################################
# File Name: fix.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-30 04:57:44 UTC
# Modified Time: 2025-02-22 05:58:38 UTC
#########################################################################


#!/bin/bash

version_comp () {
    if [[ $1 == $2 ]]
    then
        echo "="
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0}))
        then
            echo ">"
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            echo "<"
            return 2
        fi
    done

    echo "="
    return 0
}

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

# Try latest dnsmasq
tmp_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=' $GITHUB_WORKSPACE/data/dnsmasq/Makefile)
tmp_pkg=$(grep -m1 'PKG_RELEASE:=' $GITHUB_WORKSPACE/data/dnsmasq/Makefile)
dnsmasq_data_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
if [ -n "${dnsmasq_data_ver}" ]; then
    dnsmasq_path="package/network/services/dnsmasq"
    tmp_ver=$(grep -m1 'PKG_UPSTREAM_VERSION:=' ${dnsmasq_path}/Makefile)
    tmp_pkg=$(grep -m1 'PKG_RELEASE:=' ${dnsmasq_path}/Makefile)
    dnsmasq_repo_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
    cr=$(version_comp "${dnsmasq_repo_ver}" "${dnsmasq_data_ver}")
    if [ "$cr" == "<" ]; then
        rm -rf $dnsmasq_path
        cp $GITHUB_WORKSPACE/data/etc/ipcalc.sh package/base-files/files/bin/ipcalc.sh
        cp -r $GITHUB_WORKSPACE/data/dnsmasq ${dnsmasq_path}
        echo "Upgrade dnsmasq from ${dnsmasq_repo_ver} to ${dnsmasq_data_ver}"
    else
        echo "Dnsmasq no change need to make: ${dnsmasq_repo_ver}"
    fi
fi

# Try latest golang
tmp_ver=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' $GITHUB_WORKSPACE/data/golang/golang/Makefile)
tmp_pkg=$(grep -m1 'GO_VERSION_PATCH:=' $GITHUB_WORKSPACE/data/golang/golang/Makefile)
golang_data_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
if [ -n "${golang_data_ver}" ]; then
    golang_path="feeds/packages/lang/golang"
    tmp_ver=$(grep -m1 'GO_VERSION_MAJOR_MINOR:=' ${golang_path}/golang/Makefile)
    tmp_pkg=$(grep -m1 'GO_VERSION_PATCH:=' ${golang_path}/golang/Makefile)
    golang_repo_ver="${tmp_ver##*=}.${tmp_pkg##*=}"
    cr=$(version_comp "${golang_repo_ver}" "${golang_data_ver}")
    if [ "$cr" == "<" ]; then
        rm -rf $golang_path
        cp -r $GITHUB_WORKSPACE/data/golang ${golang_path}
        echo "Upgrade golang from ${golang_repo_ver} to ${golang_data_ver}"
    else
        echo "Golang no change need to make: ${golang_repo_ver}"
    fi
fi

# Try latest v2ray-core
tmp_ver=$(grep -m1 'PKG_VERSION:=' ${GITHUB_WORKSPACE}/data/v2ray-core/Makefile)
v2ray_data_ver="${tmp_ver##*=}"
if [ -n "${v2ray_data_ver}" ]; then
    v2ray_path="feeds/packages/net/v2ray-core"
    if [ -d "${v2ray_path}" ]; then
        tmp_ver=$(grep -m1 'PKG_VERSION:=' ${v2ray_path}/Makefile)
        v2ray_repo_ver="${tmp_ver##*=}"
        cr=$(version_comp "${v2ray_repo_ver}" "${v2ray_data_ver}")
        if [ "$cr" == "<" ]; then
            rm -rf $v2ray_path
            cp -r $GITHUB_WORKSPACE/data/v2ray-core ${v2ray_path}
            echo "Upgrade v2ray-core from ${v2ray_repo_ver} to ${v2ray_data_ver}"
        else
            echo "V2ray-core no change need to make: ${v2ray_repo_ver}"
        fi
    fi
fi

# make minidlna depends on libffmpeg-full not libffmpeg
sed -i "s/libffmpeg /libffmpeg-full /g" feeds/packages/multimedia/minidlna/Makefile
echo "Set minidlna depends on libffmpeg-full not libffmpeg"

# make cshark depends on libustream-openssl not libustream-mbedtls
# i fucking hate stupid mbedtls so much, be gone
sed -i "s/libustream-mbedtls/libustream-openssl/g" feeds/packages/net/cshark/Makefile
echo "Set cshark depends on libustream-openssl not libustream-mbedtls"

# remove ipv6-helper depends on odhcpd*
sed -i "s/+odhcpd-ipv6only//g" feeds/CustomPkgs/net/ipv6-helper/Makefile
echo "Remove ipv6-helper depends on odhcpd*"

# remove hnetd depends on odhcpd*
sed -i "s/+odhcpd//g" feeds/routing/hnetd/Makefile
echo "Remove hnetd depends on odhcpd*"

# make shairplay depends on mdnsd not libavahi-compat-libdnssd
shairplay_path=feeds/packages/sound/shairplay/Makefile
if [ -f ${shairplay_path} ]; then
    sed -i "s/+libavahi-compat-libdnssd/+mdnsd/g" ${shairplay_path}
    echo "Set shairplay depends on mdnsd not libavahi-compat-libdnssd"
fi

# set v2raya depends on v2ray-core
sed -i "s/xray-core/v2ray-core/g" feeds/packages/net/v2raya/Makefile
echo "set v2raya depends on v2ray-core"

# upgrade libtorrent-rasterbar to version 2.0.9
RAS_PATH="feeds/packages/libs/libtorrent-rasterbar"
RAS_VER=$(grep -m1 'PKG_VERSION:=2.0.8' ${RAS_PATH}/Makefile)
if [ -n "${RAS_VER}" ]; then
    rm -rf ${RAS_PATH}
    cp -r $GITHUB_WORKSPACE/data/app/libtorrent-rasterbar feeds/packages/libs/
    echo "Try libtorrent-rasterbar v2.0.9 for qBittorrent"
fi

RRDTOOL_PATH="feeds/packages/utils/rrdtool1"
RRDTOOL_URL=$(grep -m1 'PKG_SOURCE_URL:= \\' ${RRDTOOL_PATH}/Makefile)
if [ -n "${RRDTOOL_URL}" ]; then
    cp $GITHUB_WORKSPACE/data/patches/rrdtool1-Makefile ${RRDTOOL_PATH}/Makefile
    echo "Fix rrdtool1 package url mirrors error"
fi

GD_PATH="feeds/packages/utils/gptfdisk"
GD_VER=$(grep -m1 'PKG_VERSION:=1.0.9' ${GD_PATH}/Makefile)
if [ -n "${GD_VER}" ]; then
    sed -i '0,/^TARGET_CXXFLAGS.*/s/^TARGET_CXXFLAGS.*/TARGET_CFLAGS += -D_LARGEFILE64_SOURCE\n&/' ${GD_PATH}/Makefile
    echo "Fix gptfdisk compile error"
fi

echo -e "Fixing Jobs Completed!!!\n"

