# BuildOfficialOpenWrt

Build OpenWrt for official source code.  
[LEDE源码编译版本](https://github.com/ecrasy/BuildOpenWrt)  

用了一段时间Smartdns和Chinadns-NG  
感觉这两个模块有点脱裤子放屁  
根本就是无用功，多余不说还可能带来安全隐患  

Dnsmasq作为OpenWrt的基础组件  
完全遵照RFC标准开发  
为很多路由系统所用（商用的和开源的）  
Smartdns更像是一个满足个人特殊需求的小作品  
完全无法代替Dnsmasq  
甚至在获取DNS的速度上也很难保证达到其声称的目标  

Chinadns-NG的设计初衷是可信DNS  
对于使用Passwall的用户来说是没必要的多此一举  
国内的DNS查询是无所谓可信不可信的  
因为无论如何你能拿到的结果都是完全掌握在政府手里的  
国外的DNS查询结果来自于自建VPS  
这个不需要Chinadns-NG来告诉你是否可信  

## 概览 
Intel J4125用了两个多月master分支编译的固件，  
非常稳定，速度很快，  
LEDE版本出现的有些问题，  
官方源码编译的反而没有。  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/config.jpg)  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/net.jpg)  

## 官方源码编译固件的恢复配置
这是基于官方源码master分支编译的固件的恢复配置  
使用恢复配置可以实现下面图片中的路由运行效果  
免去每次烧写固件需要重新设置的烦恼  
在系统->备份与升级->恢复配置  
上传备份然后等待重启  
官方固件的登录密码默认为空  
wan口已配置为pppoe拨号上网  
需要手动填写拨号的账户密码(光猫桥接拨号)  
或者手动切换为DHCP协议(光猫拨号)  
[点击下载配置](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/backup-OpenWrt-common.tar.gz)    

## IPv6自动设置ula_prefix
[ula prefix](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/data/etc/095-ula-prefix)  
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
如果想打开DHCPv6功能分配IPv6地址  
则需要手动配置lan打开DHCPv6功能
```
config dhcp 'lan'
	option interface 'lan'
	option limit '150'
	option start '2'
	option leasetime '6h'
	option force '1'
	option ra 'server'
	option dhcpv6 'server'
	option ra_management '1'
	option ra_default '1'
```	
DHCP配置文件(默认不开DHCPv6)：  
[/etc/config/dhcp](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/dhcp)  

**获取IPv6-PD：**  
ssh登录到OpenWrt路由器  
打开编辑  
[/etc/config/network](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/network)  
手动更改wan6为:  
```
config interface 'wan6'
	option device '@wan'
	option proto 'dhcpv6'
	option reqaddress 'try'
	option reqprefix 'auto'
```  
这里的修改是让wan6成为wan的别名  
wan的IPv6获取设置为手动  
wan6的IPv6获取设置为自动  
实际运行效果图：   

![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/net.jpg)  

## 通过VPS搭建代理
[Wiki教程](https://github.com/ecrasy/BuildOpenwrt/wiki)  

