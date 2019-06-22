---
title: 网络抓包工具之WireShark
date: 2019-06-22 23:05:34
tags:
categories: Network
---

# WireShark简介

WireShark，前称Ethereal，是当今世界最流行的网络协议嗅探、抓包和分析工具，它使我们得以窥探网络上流动的数据及其协议细节。网络管理员使用WireShark来检测网络问题；网络安全工程师使用WireShark来检查网络安全相关问题；开发者可以使用WireShark来开发调试新的通信协议；普通使用者可以使用WireShark来学习网络协议栈相关的知识。

# tcpdump与WireShark关系

tcpdump是命令行界面CUI，WireShark是图形用户界面GUI，WireShark相对tcpdump而言，界面更友好、功能更强大。

Unix平台（包括Mac OS）下的WireShark是基于libpcap实现的，Window平台下的WireShark则是基于winpcap实现的。libpcap，Packet Capture Libray，即数据包捕获函数库，源于tcpdump项目。最开始是由tcpdump中剥离出的抓包、过滤、capture file的读写代码提炼而成，现在也是由tcpdump项目的开发组织tcpdump.org维护。

捕获抓包机制是在数据链路层增加一个旁路处理（并不干扰系统自身的网络协议栈的处理），对发送和接收的数据包通过Unix内核做过滤和缓冲处理，最后直接传递给上层应用程序。一个包的捕捉分为三个主要部分，包括面向底层包捕获、面向中间层的数据包过滤和面向应用层的用户接口。

libpcap作为捕捉网络数据包的库，它是一个独立于系统的用户级API接口，为底层网络检测提供了一个可移植的框架。

鉴于WireShark和tcpdump都共同使用libpcap作为其底层抓包的库，可以用WireShark打开tcpdump抓包保存的pcap文件进行分析。

WireShark使用详细参考：
https://www.cnblogs.com/TankXiao/archive/2012/10/10/2711777.html
