---
title: Linux下的小工具hping3 | fping | arping
date: 2018-02-03 23:59:53
tags:
categories: Linux
---

# hping3

（1）hping3简介

hping是用于生成和解析TCP/IP协议数据包的开源工具。创作者是Salvatore Sanfilippo。目前最新版是hping3。hping优势在于能够定制数据包的各个部分，因此用户可以灵活对目标机进行细致地探测。

（2）hping3命令的使用格式及重要选项

	-c count  #发出数据包的数量
	-S        #发送的TCP数据包，置位为SYN，即发出SYN TCP
	-p        #指定端口

（3）hping3使用举例

```bash
hping3 -c 4 -S -p 80 www.baidu.com   #向www.baidu.com的80端口，发送4个SYN数据包
```

备注：用的就不是ICMP协议了

学习资料参考于：
http://man.linuxde.net/hping3

# fping

fping程序类似于ping。fping与ping不同的地方在于，fping可以在命令行中指定多个探测主机，也可以指定含有要ping的主机列表文件。与ping要等待某一主机连接超时或发回反馈信息不同，fping给一个主机发送完数据包后，马上给下一个主机发送数据包，实现多主机同时ping。如果某一主机ping通，则此主机将被打上标记，并从等待列表中移除，如果没ping通，说明主机无法到达，主机仍然留在等待列表中，等待后续操作。fping命令的使用举例：

```bash
fping -f hostlist.txt       #从hostlist.txt中读取机器列表，进行ping存活检测
fping -c 3 -f hostlist.txt  #从hostlist.txt中读取机器列表，并且每个目标机器被ping 3次
fping -g 192.168.1.0/24     #对某一个网段中的机器进行ping存活检测
```

# arping

向局域网中的机器发起arp解析，获取目标主机的MAC地址。

arping命令使用格式为：

```bash
arping [options] [-c count] [-w deadline] [-s source] -I interface destination
```

arping命令使用举例：

```bash
arping 10.16.31.249        #请求IP地址为10.16.31.249的主机MAC地址
arping -I eth0 10.16.54.3  #从网卡eth0发起主机10.16.54.3的MAC地址询问
```

备注：arping用的就不是ICMP协议了
