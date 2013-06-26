iMACcheck
=========

A tool for get TV MAC address,can use to test network for electronic product

一个用于电视机生产在线检测记录MAC address的工具，可用来检测电子产品的网络。

![效果图](http://github.com/Garfielt/iMACcheck/raw/master/iMACcheck.jpg)

主要功能：
1、监听网络，获取符合固定标识的MAC地址；
2、记录MAC，甄别重复，链接后端机器获取MAC批次信息；
3、可通过telnet完成部分批处理设置工作。

该工具经历了几次改进，MAC地址获取机制经历了：
1、HTTP请求触发；
2、ARP监听扫描；
3、自实现DNS服务器实现；
4、自实现DHCP服务器实现。

可单机使用也可连接同一个数据记录源一起使用。

现批量使用版本已可达到最快最高效的检测网口物理、协议层。（默认认为在网口上收发收据均正常视为网口物理及协议层均正常）

最终DHCP监听版暂不提供，如有需要请联系索取，联系方式下附！

内容介绍：
iMac.py 自实现的DNSserver方式监听方式MAC获取；
iMac_Testtool.py DNSserver + ARP监听方式MAC获取；
Macserver asp写的MAC记录校验、MAC分类批次管理的服务器端。

联系我：
http://blog.iscsky.net
http://weibo.com/liuwt123

Copyright (c) 2012, Garfielt <liuwt123@gmail.com>.
License: MIT (see LICENSE.txt for details)

微软部分内容请参加遵循微软要求。
