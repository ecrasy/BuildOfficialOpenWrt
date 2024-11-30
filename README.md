# BuildOfficialOpenWrt

## Build OpenWrt for official source code.  
[LEDE源码编译版本](https://github.com/ecrasy/BuildOpenWrt)  

SmartDNS,FakeDNS,ChinaDNS-NG,Turbo-ACC等组件建议勿选  
经测试这些模块会拖累系统造成网络故障  

## Caution
最近来自中国大陆的Jia Cheong Tan  
向测试验证过程做了手脚  
一旦Linux发行版在编译过程后运行测试程序  
就会触发“植入后门”  
把后门植入xz 5.6.0 和 5.6.1，以及liblzma  
需要谨慎对待来自中国大陆的代码  

## 概览   
尝鲜官方源码24.10分支,   
稳定分支官方源码23.05分支,   
以后不再编译其它分支.   
24.10分支固件会出现DNS请求错乱的问题.   
目前来说23.05仍然是首选.   
固件在x86机器上测试超过一周，  
运行良好无故障发生.  
![image](/pics/config.jpg)  
![image](/pics/net.jpg)  

## 官方源码编译固件的恢复配置
这是基于官方源码编译的固件的恢复配置  
使用恢复配置可以实现下面图片中的路由运行效果  
免去每次烧写固件需要重新设置的烦恼  
在系统->备份与升级->恢复配置  
上传备份然后等待重启  
官方固件的登录密码默认为空  
wan口已配置为pppoe拨号上网  
需要手动填写拨号的账户密码(光猫桥接拨号)  
或者手动切换为DHCP协议(光猫拨号)  
[点击下载配置](/wiki/backup-OpenWrt-common.tar.gz)    

## IPv6自动设置ula_prefix
[ula prefix](/data/etc/095-ula-prefix)  
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
[/etc/config/dhcp](/wiki/dhcp)  

**获取IPv6-PD：**  
ssh登录到OpenWrt路由器  
打开编辑  
[/etc/config/network]/wiki/network)  
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

![image](/pics/net.jpg)  

## 通过VPS搭建代理
[Wiki教程](https://github.com/ecrasy/BuildOpenwrt/wiki)  

