---
title: TCP握手代理SYNProxy
date: 2019-03-05 11:09:23
tags:
categories: Network
---

# SYNProxy

SYNProxy，顾名思义就是一个TCP握手代理 ，该代理截获TCP连接创建的请求，它可以保证只有与自己完成整个TCP握手的连接才被认为是正常的连接，此时才会由代理真正发起与真实服务器的TCP连接。整个流程图如下：

![](/images/network_tcpproxy_1_1.png)

上述流程分为四个阶段：

（1）T1

Client与SYNProxy三次握手建立TCP连接。

（2）T2

SYNProxy与Server三次握手建立TCP连接。

（3）T3

Client与Server之间传输数据。

（4）T4

SYNProxy清理资源，释放TCP连接。

备注：SYNProxy可以有效解决SYNFlood攻击问题。
