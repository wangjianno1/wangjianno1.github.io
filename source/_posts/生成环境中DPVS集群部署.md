---
title: 生成环境中DPVS集群部署
date: 2019-02-21 16:30:01
tags: DPVS
categories: SRE
---

# DPVS集群部署网络结构

在DPVS架构中有三个部分，分别是客户端、LB（即DPVS）以及RS。所谓one-arm指的是客户端和RS在同一个逻辑网络中，也就是DPVS上只有一个网卡，该网卡即连接客户端网络，也连接RS所在的网络。所有two-arm指的是用户和RS不在同一个逻辑网络中，也就是DPVS上需要有两块网卡，一块网卡连接客户端网络，一块网卡连接RS所在的网络。

one-arm的架构图如下：

![](/images/dpvs_deploy_1_1.png)

two-arm的架构图如下：

![](/images/dpvs_deploy_1_2.png)

# 搭建单DPVS实例步骤

以搭建two-arm结构的DPVS FULLNAT集群为例来说明，拓扑结构如下：

![](/images/dpvs_deploy_1_2.png)

（1）准备操作系统、内核、GCC等编译环境

（2）下载dpvs、dpdk代码，并编译安装

（3）修改配置文件，如需要被DPVS接管网卡的名称、绑核、大页内存等配置，并启动dpvs

此时执行`./dpip link show`命令，就可以看到dpdk已经托管了网卡，命令输出结果类似如下：

    1: dpdk0: socket 0 mtu 1500 rx-queue 8 tx-queue 8
        UP 10000 Mbps full-duplex fixed-nego promisc-off
        addr A0:36:9F:9D:61:F4 OF_RX_IP_CSUM OF_TX_IP_CSUM OF_TX_TCP_CSUM OF_TX_UDP_CSUM

（4）配置DPVS的工作模式

包括dpdk网卡ip配置，路由配置，添加vip服务，添加rs服务，添加localip等等，命令如下：

```bash
#为dpdk1网卡配置ip，该ip将作为vip
./dpip addr add 10.0.0.100/32 dev dpdk1

#为dpdk1和dpdk0配置同网段路由
./dpip route add 10.0.0.0/16 dev dpdk1
./dpip route add 192.168.100.0/24 dev dpdk0

#添加vip服务
./ipvsadm -A -t 10.0.0.100:80 -s rr

#添加rs ip，-b表示是FULLNAT模式
./ipvsadm -a -t 10.0.0.100:80 -r 192.168.100.2 -b
./ipvsadm -a -t 10.0.0.100:80 -r 192.168.100.3 -b

#在dpdk0网卡上配置local ip
./ipvsadm --add-laddr -z 192.168.100.200 -t 10.0.0.100:80 -F dpdk0
```

（5）测试

执行命令`./dpip addr show`测试，命令输出结果如下：

    inet 10.0.0.100/32 scope global dpdk1
         valid_lft forever preferred_lft forever
    inet 192.168.100.200/32 scope global dpdk0
         valid_lft forever preferred_lft forever sa_used 0 sa_free 1032176 sa_miss 0

执行命令`./dpip route show`测试，命令输出结果如下：

    inet 10.0.0.100/32 via 0.0.0.0 src 0.0.0.0 dev dpdk1 mtu 1500 tos 0 scope host metric 0 proto auto
    inet 192.168.100.200/32 via 0.0.0.0 src 0.0.0.0 dev dpdk0 mtu 1500 tos 0 scope host metric 0 proto auto
    inet 192.168.100.0/24 via 0.0.0.0 src 0.0.0.0 dev dpdk0 mtu 1500 tos 0 scope link metric 0 proto auto
    inet 10.0.0.0/16 via 0.0.0.0 src 0.0.0.0 dev dpdk1 mtu 1500 tos 0 scope link metric 0 proto auto

执行命令`./ipvsadm -ln`测试，命令输出结果如下：

    IP Virtual Server version 0.0.0 (size=0)
    Prot LocalAddress:Port Scheduler Flags
      -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  10.0.0.100:80 rr
      -> 192.168.100.2:80             FullNat 1      0          0
      -> 192.168.100.3:80             FullNat 1      0          0

执行命令`curl http://10.0.0.100`进行测试验证。

# DPVS的高可用部署方案

目前有两种模式构建高可用DPVS集群，一种是OSPF/ECMP，另一种是Master/Backup。OSPF/ECMP模式需要路由器模拟软件Quagga的支持，Master/Backup主备模式需要用到keepalived。

（1）OSPF/ECMP + DPVS FULLNAT架构的部署

首先在每台机器上按FULLNAT模式部署单DPVS实例，然后需要配置路由器模拟软件，需要使用Quagga软件，在每台DPVS上需要配置`/etc/quagga/ospfd.conf`，具体如下：

    network 210.34.183.21/32 area 0.0.0.20
    network 210.34.183.22/32 area 0.0.0.20
    network 210.34.183.23/32 area 0.0.0.20
    network 210.34.183.24/32 area 0.0.0.20
    network 210.34.183.25/32 area 0.0.0.20
    network 210.34.183.26/32 area 0.0.0.20

然后DPVS上联的路由器就会分别形成到目的地址210.34.183.21-26的多条等价路由，然后又ECMP的HASH规则将数据包转发到不同的RS上。以目的地址210.34.183.21/32为例，在路由器上会形成如下的路由：

    210.34.183.21/32 via 172.10.0.0.2 dev eth0
    210.34.183.21/32 via 172.10.0.0.3 dev eth0
    210.34.183.21/32 via 172.10.0.0.4 dev eth0

这里172.10.0.0.2-4是我们的三个DPVS实例。

（2）OSPF/ECMP + DPVS SNAT架构的部署

首先在每台机器上按SNAT模式部署单DPVS实例，然后需要配置路由器模拟软件，需要使用Quagga软件，在每台DPVS上需要配置`/etc/quagga/ospfd.conf`，具体如下：

    network 172.10.0.0/30 area 0.0.0.10  #通告ospf内敛地址
    network 172.10.0.100/32 area 0.0.0.10  #通告一个vip地址

备注：这里每台DPVS实例上都需要一条`network 172.10.0.100/32 area 0.0.0.10`，然后上联路由器会认为172.10.0.100/32是一个vip，上联路由器将缺省路由指向172.10.0.100/32，然后就可以是各个dpvs均摊流量了，这里有些不理解，待推敲。

（3）Keepalived + DPVS SNAT架构的部署

利用dpvs包中的keepalived配置一个漂移IP即可，然后上联交换机指向这个漂移IP即可。

学习资料参考于：
https://github.com/iqiyi/dpvs/blob/master/doc/tutorial.md
