#########################################################################
# File Name: diy.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2025-01-29 06:52:28 UTC
#########################################################################


#!/bin/bash

# Change default LAN IP to 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate 
echo "Change default LAN IP to 192.168.2.1"

# Patch 02_network config file
BOARD_PATH="target/linux/x86/base-files/etc/board.d"
PATCH_FILE="${GITHUB_WORKSPACE}/data/patches/02_network.patch"
RLINE=$(grep -m1 -n 'esac' ${BOARD_PATH}/02_network |awk '{ print $1 }' |cut -d':' -f1)
if [ -n "$RLINE" ]; then
    RLINE=$((RLINE-1))
    OP_RESULT=$(sed -i -e "${RLINE}r ${PATCH_FILE}" ${BOARD_PATH}/02_network)
    echo "Patch 02_network config file: $OP_RESULT"
fi

# Patch 99-default_network config file
BOARD_PATH="package/base-files/files/etc/board.d"
cp $GITHUB_WORKSPACE/data/patches/99-default_network.patch $BOARD_PATH/
cd $BOARD_PATH/
OP_RESULT=$(patch < 99-default_network.patch)
rm -rf 99-default_network.patch
echo "Patch 99-default_network config file: $OP_RESULT"
cd ~-

# Change default shell from ash to bash 
# Note: bash need to be selected from make menuconfig first
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd
echo "Change default shell from ash to bash"

# Replace default ssh banner with my custom banner
rm -rf package/base-files/files/etc/banner
cp $GITHUB_WORKSPACE/data/etc/banner package/base-files/files/etc/
echo "Replace default ssh banner"

# Add model.sh to remove annoying board name for Intel J4125
cp $GITHUB_WORKSPACE/data/etc/model.sh package/base-files/files/etc/
chmod 0755 package/base-files/files/etc/model.sh
echo "Add model.sh"

# Add 92-ula-prefix, try to set up IPv6 ula prefix after wlan up
# and call model.sh
mkdir -p package/base-files/files/etc/hotplug.d/iface
cp $GITHUB_WORKSPACE/data/etc/92-ula-prefix package/base-files/files/etc/hotplug.d/iface/
chmod 0755 package/base-files/files/etc/hotplug.d/iface/92-ula-prefix
echo "Add 92-ula-prefix"

# Custom miniDLNA zh_Hans translation
miniDLNA_PATH="feeds/luci/applications/luci-app-minidlna/po/zh_Hans"
sed -i 's/迷你DLNA/miniDLNA/g' ${miniDLNA_PATH}/minidlna.po
sed -i 's/迷你 SSDP 插座/miniSSDP 插座/g' ${miniDLNA_PATH}/minidlna.po
echo "Custom miniDLNA zh_Hans translation"

# Custom MJPG-streamer zh_Hans translation
ms_PATH="feeds/luci/applications/luci-app-mjpg-streamer/po/zh_Hans"
sed -i 's/MJPG-streamer(网络摄像机串流)/MJPG-streamer/g' ${ms_PATH}/mjpg-streamer.po
echo "Custom MJPG-streamer zh_Hans translation"

# Custom DDns zh_Hans translation
ddns_PATH="feeds/luci/applications/luci-app-ddns/po/zh_Hans"
sed -i 's/动态DNS 服务项/DDNS服务/g' ${ddns_PATH}/ddns.po
sed -i 's/动态 DNS 版本/DDNS版本/g' ${ddns_PATH}/ddns.po
sed -i 's/动态 DNS(DDNS)/DDNS/g' ${ddns_PATH}/ddns.po
sed -i 's/动态DNS/DDNS/g' ${ddns_PATH}/ddns.po
sed -i 's/动态 DNS/DDNS/g' ${ddns_PATH}/ddns.po
echo "Custom DDNS zh_Hans translation"

# Custom Shairplay zh_Hans translation
sp_PATH="feeds/luci/applications/luci-app-shairplay/po/zh_Hans"
if [ -f "${sp_PATH}/shairplay.po" ]; then
    sed -i 's/Shairplay(多媒体程序)/Shairplay/g' ${sp_PATH}/shairplay.po
    echo "Custom Shairplay zh_Hans translation"
fi

# Custom Samba4 zh_Hans translation
SB_PATH="feeds/luci/applications/luci-app-samba4/po/zh_Hans"
sed -i 's/网络共享/Samba4/g' ${SB_PATH}/samba4.po
echo "Custom Samba4 zh_Hans translation"

# Custom CloudShark zh_Hans translation
CShark_PATH="feeds/luci/applications/luci-app-cshark/po/zh_Hans"
sed -i 's/云鲨/CloudShark/g' ${CShark_PATH}/cshark.po
echo "Custom CloudShark zh_Hans translation"

# Add Port status zh_Hans translation
LB_PATH="feeds/luci/modules/luci-base/po/zh_Hans"
TLINE=$(grep -m1 -n '"Port status"' ${LB_PATH}/base.po |awk '{ print $1 }' |cut -d':' -f1)
if [ -n "$TLINE" ]; then
    DLINE=$((TLINE+1))
    sed -i "${DLINE}d" ${LB_PATH}/base.po
    sed -i "${TLINE}a msgstr \"网口状态\"" ${LB_PATH}/base.po
    echo "Add Port status zh_Hans translation"
fi

echo -e "DIY Jobs Completed!!!\n"

