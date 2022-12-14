#########################################################################
# File Name: diy.sh
# Author: Carbon (ecrasy@gmail.com)
# Description: feel free to use
# Created Time: 2022-07-23 13:01:29 UTC
# Modified Time: 2023-01-10 09:50:04 UTC
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

# Add base config files
# mkdir -p package/base-files/files/etc/config
# cp -f $GITHUB_WORKSPACE/data/etc/config/* package/base-files/files/etc/config/
# echo "Add base config files"

echo -e "DIY Jobs Completed!!!\n"
