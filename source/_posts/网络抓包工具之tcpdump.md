---
title: 网络抓包工具之tcpdump
date: 2019-06-22 23:07:46
tags:
categories: Network
---

# tcpdump简介

tcpdump可以根据使用者的定义对网络上的数据包进行截获并分析。tcpdump可以将网络中传送的数据包的“头”完全截获下来提供分析。它支持针对网络层、协议、主机、网络或端口的过滤，并提供and、or、not等逻辑语句来帮助你去掉无用的信息。

# tcpdump的使用方法

（1）使用格式

```bash
tcpdump [options] [-i 网络接口] [-w 数据包dump到的目标文件] [-c 监听次数] [-r dump出来的文件] [数据包筛选规则]
```

（2）重要的选项

    -i           #指定要监听的网络接口，如eth0，eth1，lo等。若指定为any，表示监听所有的网卡接口
    -nn          #直接以ip和port显示，而非主机名或服务名称
    -w filename  #将监听所得的数据包存储到文件中
    -r filename  #从指定tcpdump出来的文件中读取dump文件
    -c num       #指定监听的数据包数，如果不指定-c，那么tcpdump会持续不断的监听

# 使用举例

```bash
#监听eth0接口
tcpdump -i eth0 -nn
#监听eth0接口且满足“port为21的数据包”的筛选规则
tcpdump -i eth0 -nn 'port 21'
#监听eth0接口且满足“port为22且源主机为192.168.1.101的数据包”的筛选规则
tcpdump -i eth0 -nn 'port 22 and src host 192.168.1.101'
#只抓取所有网卡的icmp协议数据包，并直接打印到终端上，也可以只抓取tcp/udp/arp等
tcpdump -nni any 'icmp'
#抓取网卡eth0的数据包，并输出到wireshark.cap文件中
tcpdump -nni eth0 -w wireshark.cap
```

# 闲杂

WireShark是图形化的数据包抓取工具，和tcpdump实现的功能是一致的。使用tcpdump的-w选项将tcpdump的输出到一个cap命名的文件中，然后用WireShark打开该文件，则可以用WireShark分析tcpdump抓取的数据包。
