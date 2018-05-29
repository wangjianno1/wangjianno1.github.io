---
title: Linux中arp命令的使用
date: 2018-05-29 18:12:18
tags:
categories: Linux
---

# arp命令介绍

arp命令用于操作服务器的arp表缓冲区，它可以显示arp缓冲区中的所有条目、删除指定的条目或者添加静态的IP地址与MAC地址对应关系。

# arp命令的使用格式及常用选项

```
arp [options] parameter1 parameter2...
```

常用的命令选项有：

```
-a: 显示本机中arp缓存区中所有的arp条目
-d: 从arp缓冲区中删除指定主机的arp条目
-i: 指定要操作指定网卡的arp缓存区
-s: 设置指定的主机的IP地址与MAC地址的静态映射
-n: 以数字方式显示arp缓冲区中的条目
```

# arp常用的操作命令使用举例

```bash
arp             #显示本机arp缓存中所有arp条目
arp -n          #只显示ip，不反解成主机名
arp -a          #显示本机arp缓存中所有的arp条目
arp -n -i eth0  #显示指定网卡的所有的arp表项目
arp -d 10.1.10.118          #删除arp表缓存中10.1.10.118对应的arp表项
arp -i eth0 -d 10.1.10.118  #删除指定网卡的arp表缓存中10.1.10.118对应的arp表项
arp -s 10.1.1.1 00:11:22:33:44:55:66  #新增一条IP到MAC地址的映射记录
```