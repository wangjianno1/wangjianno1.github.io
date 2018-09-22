---
title: 计算机网络中MTU|MSS的概念及实际应用
date: 2018-09-22 18:03:51
tags:
categories: Network
---

# MTU

MTU，Maximum Transmit Unit，中文全称为最大传输单元。即物理接口（数据链路层）提供给其上层最大一次传输数据的大小，比如IP层、MPLS层等等，因为目前应用最多的接口是以太网，所以谈谈以太网口的MTU，假定其上层协议是IP，缺省MTU=1500，意思是：整个IP包最大从这个接口发送出去的是1500个字节。可以通过配置修改成更大或更小的值，只要在系统的边界值以内即可，但是切记要在链路的两端都要修改，而且要大小一样，如果不一样，会造成大侧的数据被小侧丢弃。

简单来说，MTU是数据链路层的概念，用来限制其上层网络IP协议层的数据包最大长度（包括协议头和数据内容）。常见数据链路层技术的MTU如下：

![](/images/mtu_mss_1_1.png)

# MSS

MSS，Maximum Segment Size ，中文全称为最大TCP分段大小，不包含TCP头和option，只包含TCP Payload ，TCP用来限制自己每次发送的最大分段尺寸。MSS就是TCP数据包每次能够传输的最大数据分段。为了达到最佳的传输效能TCP协议在建立连接的时候通常要协商双方的MSS值，通讯双方会根据双方提供的MSS值得最小值确定为这次连接的最大MSS值。

# MTU和MSS的关系图

以TCP/UDP+IP+Ethernet的网络模型为例来说，以太网的MTU为1500Bytes，因为IP层Header固定20Bytes，TCP/UDP层header固定20Bytes，则要求TCP/UDP层payload最大为1500-20-20=1460Bytes。

![](/images/mtu_mss_1_2.png)

# 对于使用GRE Tunnel的私有网络的一个坑

由于使用了GRE Tunnel技术的使用网络，在数据通信时，会在IP层数据包的基础上再另外加上GRE Header，这个GRE Header一共24 Bytes。因此在这样的网络环境中我们必须重新设置网络的MTU值，即Ethernet网MTU需要设置成1500-24=1476Bytes啦，否则网络通信会出现问题。

# 查看和修改Linux的MTU值

（1）使用ip a或ifconfig查看网卡的MTU设置

![](/images/mtu_mss_1_3.png)

（2）修改网卡MTU设置

```bash
ifconfig eth0 mtu number
```

或编辑

```bash
vi /etc/sysconfig/network-scripts/ifcfg-eth0  #增加MTU=XXX
```

学习资料参考于：
http://teenyscrew.blogspot.com/2014/06/gre-tunnel-mtu.html
