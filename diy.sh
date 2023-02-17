#########################################################################
# File Name: diy.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2023-02-17 10:22:33 UTC
#########################################################################


#!/bin/bash

# Change default LAN IP to 192.168.2.1
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate 
echo "Change default LAN IP to 192.168.2.1"

# Set eth0 to wan and eth1 to lan as default
rm -rf package/base-files/files/etc/board.d/99-default_network
cp $GITHUB_WORKSPACE/data/etc/99-default_network package/base-files/files/etc/board.d/
echo "Set eth0 to wan and eth1 to lan as default while eth1 exists"

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

# Add 095-ula-prefix, try to set up IPv6 ula prefix after wlan up
# and call model.sh
mkdir -p package/base-files/files/etc/hotplug.d/iface
cp $GITHUB_WORKSPACE/data/etc/095-ula-prefix package/base-files/files/etc/hotplug.d/iface/
chmod 0755 package/base-files/files/etc/hotplug.d/iface/095-ula-prefix
echo "Add 095-ula-prefix"

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
sed -i 's/动态DNS 服务项/DDns服务/g' ${ddns_PATH}/ddns.po
sed -i 's/动态 DNS 版本/DDns版本/g' ${ddns_PATH}/ddns.po
sed -i 's/动态DNS/DDns/g' ${ddns_PATH}/ddns.po
sed -i 's/动态 DNS/DDns/g' ${ddns_PATH}/ddns.po
echo "Custom DDns zh_Hans translation"

# Custom Shairplay zh_Hans translation
sp_PATH="feeds/luci/applications/luci-app-shairplay/po/zh_Hans"
sed -i 's/Shairplay(多媒体程序)/Shairplay/g' ${sp_PATH}/shairplay.po
echo "Custom Shairplay zh_Hans translation"

# Custom Samba4 zh_Hans translation
SB_PATH="feeds/luci/applications/luci-app-samba4/po/zh_Hans"
sed -i 's/网络共享/Samba4/g' ${SB_PATH}/samba4.po
echo "Custom Samba4 zh_Hans translation"

# Custom CloudShark zh_Hans translation
CShark_PATH="feeds/luci/applications/luci-app-cshark/po/zh_Hans"
sed -i 's/云鲨/CloudShark/g' ${CShark_PATH}/cshark.po
echo "Custom CloudShark zh_Hans translation"

echo -e "DIY Jobs Completed!!!\n"

