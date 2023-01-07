# BuildOfficialOpenWrt

Build OpenWrt for official source code.  
[LEDE源码编译版本](https://github.com/ecrasy/BuildOpenWrt)  

## 概览 
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/config.jpg)  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/pics/network.jpg)  

## IPv6自动设置ula_prefix
[data/etc/054-ula-prefix](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/data/etc/054-ula-prefix)  
脚本负责在WAN网络连接之后查询 **ula prefix**  
然后设置给全局网络使用  
由于运营商给 **ula prefix** 时有延迟  
所以开头加了睡眠等待  
总共会尝试8次  
每次失败会睡眠等待1秒  
可以在系统启动之后检查/tmp/_ula_prefix文件的内容  
如果为空则证明可能尝试次数不足  
需要稍微加一点等待的时间或者增加尝试次数？  
一般是4次大概4秒之后成功  
视不同的机器最终结果可能略有差异  

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
额外配置的DNS转发地址  
来自于pppoe拨号获取的dns信息  
![image](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/wiki/DHCP.jpg)  

