# BuildOfficialOpenWrt

Build OpenWrt for official source code.  
[LEDE源码编译版本](https://github.com/ecrasy/BuildOpenWrt)  

## 概览 
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/config.jpg)  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/network.jpg)  

## 官方源码编译固件的恢复配置
这是基于官方源码master分支编译的固件的恢复配置  
在系统->备份与升级->恢复配置  
上传备份然后等待重启  
登录密码是默认密码password  
wan口配置为pppoe拨号上网  
需要手动填写拨号的账户密码  
[backup-OpenWrt-common.tar.gz](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/backup-OpenWrt-common.tar.gz)    

## IPv6自动设置ula_prefix
[data/etc/054-ula-prefix](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/data/etc/054-ula-prefix)  
脚本负责在WAN网络连接之后查询 **ula prefix**  
总共会尝试8次  
每次失败会睡眠等待1秒  
可以在系统启动之后检查日志内容：  
/tmp/_ula_prefix  

## update_configs.sh
脚本接受2个参数，  
第一个是config文件的目录，  
第二个是openwrt的源码目录，  
目录可以是相对路径或者绝对路径，  
脚本根据参数提供的目录更新config文件。

## cloudshark 
master分支编译的云鲨目前(20230107)正常运行  
目前(20230107)master分支固件使用中没发现什么大问题

## 额外配置  
为了适配最新的dnsmasq v2.88  
去掉了冲突的odhcpd模块  
如果DHCP v6无法分配IP  
则需要额外配置一下  
DHCP配置文件：  
[/etc/config/dhcp](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/dhcp)  

下面是可选的DNS转发配置：  
dnsmasq会自动处理pppoe-wan拨号获取的dns设置  
所以这个设置可做可不做  
下面配置的DNS转发地址  
来自于pppoe拨号获取的dns信息  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/DHCP.jpg)  

获取IPv6-PD：  
ssh登录到OpenWrt路由器  
打开编辑/etc/config/network  
手动更改wan6为:  
```
config interface 'wan6'
	option device '@wan'
	option proto 'dhcpv6'
	option reqaddress 'try'
	option reqprefix 'auto'
```  
让wan6成为wan的别名  
wan的IPv6获取设置为手动  
wan6的IPv6获取设置为自动  
实际运行效果图：  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/network.jpg)  

