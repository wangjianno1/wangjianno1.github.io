---
title: NAT原理及NAT技术实现
date: 2019-02-20 16:05:28
tags:
categories: Network
---

# NAT简介

NAT，Network Address Translation，中文为网络地址转换。NAT是一个IETF（Internet Engineering Task Force，Internet工程任务组）标准，允许一个整体机构以一个公用IP（Internet Protocol）地址出现在Internet上。顾名思义，它是一种把内部私有网络地址（IP地址）翻译成公网网络IP地址的技术。因此我们可以认为，NAT在一定程度上，能够有效的解决公网IPv4地址不足的问题。

NAT功能通常被集成到路由器、防火墙、ISDN路由器或者单独的NAT设备中。比如Cisco路由器中已经加入这一功能，网络管理员只需在路由器的IOS中设置NAT功能，就可以实现对内部网络的屏蔽。再比如防火墙将WEB Server的内部地址192.168.1.1映射为外部地址202.96.23.11，外部访问202.96.23.11地址实际上就是访问访问192.168.1.1。

# NAT的分类

NAT有三种类型，如下：

![](/images/network_nat_1_1.png)

（1）静态NAT（Static NAT）

静态NAT是指将内部网络的私有IP地址转换为公有IP地址，IP地址对是一对一的，是一成不变的，某个私有IP地址只转换为某个公有IP地址。因此，静态NAT并不能解决IP地址短缺的问题。 

（2）动态NAT（Pooled NAT）

动态NAT是指将内部网络的私有IP地址转换为公用IP地址时，IP地址对是不确定的，而是随机的，所有被授权访问上Internet的私有IP地址可随机转换为任何指定的合法IP地址。也就是说，只要指定哪些内部地址可以进行转换，以及用哪些合法地址作为外部地址时，就可以进行动态转换。动态转换可以使用多个合法外部地址集。当ISP提供的合法IP地址略少于网络内部的计算机数量时，可以采用动态转换的方式。 

（3）网络地址端口转换NAPT（Port-Level NAT）

网络地址端口转换NAPT（Network Address Port Translation）则是把内部地址映射到外部网络的一个IP地址的不同端口上。**它可以将中小型的网络隐藏在一个合法的IP地址后面**。NAPT与动态地址NAT不同，它将内部连接映射到外部网络中的一个单独的IP地址上，**同时在该地址上加上一个由NAT设备选定的端口号**。

NAPT是使用最普遍的一种转换方式，它又包含三种转换方式，即SNAT，DNAT和FULL-NAT(SNAT+DNAT)。简单来说，若NAT网关在处理数据包时，只修改数据包的SRC IP，称为SNAT；若NAT网关在处理数据包时，只修改数据包的DEST IP，称为DNAT；若NAT网关在处理数据包时，即修改了SRC IP也修改了DEST IP，则称为FULL-NAT。

如下NAT网关，在收到局域网的数据包，做SNAT转换，即将源地址修改为公网地址。与此同时，连接跟踪模块ip_conntrack/nf_conntrack将本次的网络通信连接记录到连接跟踪表Track Table中。当公网服务器的响应数据包到达NAT网关时，NAT网关根据连接跟踪表Trace Table来查出响应数据包的实际归属客户机的私网地址，并做DNAT转换，即将目的地址修改为客户机的私网地址。值得注意的是，这个过程中包括了SNAT和DNAT，但这不称为是FULL-NAT，因为FULL-NAT是在数据包达到NAT网关后就做SNAT和DNAT，然后等响应数据包转发到NAT网关时，还做SNAT和DNAT。

![](/images/network_nat_1_2.png)

备注：注意这里的Track Table，非常重要哦，它记录了每一个连接，并将不同的连接绑定到NAT公网IP的不同端口号上。

3.NAT的技术实现

（1）iptables

（2）LVS SNAT模式，需要打阿里的SNAT patch包

（3）dpdk-lvs SNAT模式

学习资料参考于：
https://blog.csdn.net/hzhsan/article/details/45038265
http://www.forz.site/2017/06/25/%E7%BD%91%E7%BB%9C%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2NAT%E5%8E%9F%E7%90%86%E5%8F%8A%E5%BA%94%E7%94%A8/
http://blog.51cto.com/lustlost/943110
