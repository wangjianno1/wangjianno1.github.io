---
title: Linux中iftop/iotop的使用
date: 2018-02-04 01:56:21
tags:
categories: Linux
---

# iftop简介

iftop能显示指定网卡流量的topN，使用`yum install iftop`即可安装。例如使用命令`iftop -n -i eth0`输出结果如下：

![](/images/iftop_1_1.png)

备注：
中间的<=或=>这两个左右箭头，表示的是流量的方向；TX表示发送流量 ；RX表示接收流量； TOTAL表示总流量； cum表示运行iftop到目前时间的总流量 ；peak表示流量的峰值 ；rates表示过去2s/10s/40s的平均流量.

iftop的主要选项有：

	-n           —— 不显示IP，不解析主机名
	-i interface —— 指定的网卡接口

# iotop

iotop能显示磁盘IO（即读写磁盘）进程的topN，使用`yum install iotop`即可安装。iotop和top命令显示类似，不详细展开了。

