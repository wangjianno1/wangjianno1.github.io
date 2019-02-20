---
title: 开源路由器模拟软件Quagga
date: 2019-02-20 17:48:53
tags:
categories: Network
---

# Quagga简介

Quagga是一个开源路由软件套件，可以将Linux变成支持如RIP、OSPF、BGP和IS-IS等主要路由协议的路由器。它具有对IPv4和IPv6的完整支持，并支持路由/前缀过滤。Quagga可以是你生命中的救星，以防你的生产路由器一旦宕机，而你没有备用的设备而只能等待更换。通过适当的配置，Quagga甚至可以作为生产路由器。

Quagga可以模拟很多的路由协议，如BGP、OSPF、OSPFv6、RIP以及RIPng等等。

# Quagga的安装和使用

我们执行命令`yum install quagga`即可安装Quagga路由软件，命令结束后会在系统上安装如下的工具服务：

```bash
/usr/sbin/zebra
/usr/sbin/bgpd
/usr/sbin/ospf6d
/usr/sbin/ospfd
/usr/sbin/isisd
/usr/sbin/ripd
/usr/sbin/ripngd
/usr/sbin/babeld
```

其中zebra是Quagga的核心守护进程，负责内核接口和静态路由。bgpd、ospfd以及ospf6d等守护进程就是用来模拟具体路由协议算法的。当bgpd、ospfd以及ospf6d等守护进程学习到了新的路由规则，就会调用zebra来更新系统的路由表。我们可以通过`service start xxxd`来启动其中的任一个守护进程。

# 使用Quagga配置支持OSPF协议的路由器

![](/images/network_ospf_1_1.png)

在上面的例子中，有两个网络环境，一个是192.168.1.0/24，一个是172.16.1.0/24。现在我们想使用site-A-PTR和site-B-PTR两台普通的Linux服务器来搭建两台路由器。两个路由器之间的连接使用的是对等网络10.10.10.0/30。

（1）配置zebra

在site-A-PTR上配置`/etc/quagga/zebra.conf`如下：

```
log file /var/log/quagga/quagga.log
interface eth0
ip address 10.10.10.1/30
description to-site-B
interface eth1
ip address 192.168.1.1/24
description to-site-A-LAN
```

然后再site-B-PTR上配置`/etc/quagga/zebra.conf`如下：

```
log file /var/log/quagga/quagga.log
interface eth0
ip address 10.10.10.1/30
description to-site-B
interface eth1
ip address 172.17.1.1/24
description to-site-B-LAN
```

（2）配置OSPF

在site-A-PTR上配置`/etc/quagga/ospfd.conf`如下：

```
router ospf
router-id site-a-ptr
network 10.10.10.0/30 area 0
network 192.168.1.0/24 area 0
```

在site-B-PTR上配置`/etc/quagga/ospfd.conf`如下：

```
router ospf
router-id site-b-ptr
network 10.10.10.0/30 area 0
network 172.16.1.0/24 area 0
```

备注：如上`network 10.10.10.0/30 area 0`，表示ospf对周边的路由器公布，凡是目的地址是10.10.10.0/30这个段的数据包，发送给我就好啦。

学习资料参考于：
https://linux.cn/article-4232-1.html
https://linux.cn/article-4232-2.html
