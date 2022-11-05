# BuildOfficialOpenWrt

Build OpenWrt for official source code.  
[LEDE源码编译版本](https://github.com/ecrasy/BuildOpenWrt)  


## IPv6自动设置ula_prefix
[data/etc/054-ula-prefix](https://github.com/ecrasy/BuildOfficialOpenWrt/blob/main/data/etc/054-ula-prefix)  
脚本负责在WAN网络连接之后查询 **ula prefix**  
然后设置给全局网络使用  
由于运营商给 **ula prefix** 时有延迟  
所以开头加了  
`sleep 2s`  
但是2秒这个值是不准确的  
可以在系统启动之后检查/tmp/_ula_prefix文件的内容  
如果为空则证明时间过短  
需要稍微加一点等待的时间  
一般是2秒到5秒之间  

## update_configs.sh
脚本接受2个参数，  
第一个是config文件的目录，  
第二个是openwrt的源码目录，  
目录可以是相对路径或者绝对路径，  
脚本根据参数提供的目录更新config文件。

## cloudshark 
master分支编译的云鲨无法运行  
也看不到log信息  
tag 22.03.2编译的云鲨正常  
目前使用一个星期没发现什么大问题
