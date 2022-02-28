---
title: 网络抓包工具之WireShark
date: 2019-06-22 23:05:34
tags:
categories: Network
---

# WireShark简介

WireShark，前称Ethereal，是当今世界最流行的网络协议嗅探、抓包和分析工具，它使我们得以窥探网络上流动的数据及其协议细节。网络管理员使用WireShark来检测网络问题；网络安全工程师使用WireShark来检查网络安全相关问题；开发者可以使用WireShark来开发调试新的通信协议；普通使用者可以使用WireShark来学习网络协议栈相关的知识。

如下是WireShark的界面分布：

![](/images/wireshark_1_1.png)


# WireShark中的过滤器

WireShark中有两个过滤器，一个是“捕捉过滤器”，用于决定将什么样的Packets需要被WireShark捕获，可以点击“捕获”|“捕获过滤器”中设定，只有满足了捕获过滤器中的条件的Packets才会被WireShark所捕获；另一种是“显示过滤器”（即主界面中的过滤框），是对WireShark已经捕获的Packets做一下过滤，即显示部分的抓包结果。

# 显式过滤器支持的一些条件表达式

```
tcp/udp/dns/http/tls          #满足指定协议的包     
ip.addr == 192.168.0.108      #源地址或目标地址中包含了192.168.0.108的包
ip.src == 192.168.0.108       #源地址是192.168.0.108的包
ip.dst == 192.168.0.108       #目标地地是192.168.0.108的包
tcp.port == 80                #tcp的端口是80的包
http.request.method == "GET"  #只显示HTTP GET方法的包
tcp.stream eq 6               #追踪流，Follow TCP Stream
tls.handshake.extensions_server_name contains apple.com  #匹配到包含指定字符串的包
http.request.uri matches ".gif$"   #匹配过滤HTTP的请求URI中含有".gif"字符串，并且以.gif结尾（4个字节）的http请求数据包（$是正则表达式中的结尾表示符）
tls.handshake.type eq 1            #过滤出tls中ClientHello报文
tls.handshake.type eq 1 && tls.handshake.extensions_server_name eq v1-dy.ixigua.com    #过滤出指定域名的ClientHello报文，然后使用WireShark追踪流功能筛选出此次握手的报文交互过程
tls.handshake.type eq 1 && tls.handshake.extensions_server_name contains ixigua.com    #过滤出指定域名的ClientHello报文，然后使用WireShark追踪流功能筛选出此次握手的报文交互过程
```

备注：如上的条件可以通过逻辑运算and/or进行组合使用。另外，and和&&等价，or和||等价，not和!等价，==和eq等价，matches表示模糊正则匹配某字符串，contains表示包含某字符串。

# WireShark中追踪流功能

在WireShark中，会将TCP协议层中每个TCP包生成一个WireShark私有的编号（仅存在于WireShark中的编号），即stream index编号。对于“srcip1:srcport1和dstip2:dstport2”，或“srcip2:srcport2和dstip1:dstport1”的TCP数据包，它们的stream index一样的。我们可以利用这一点可以将一个网络会话直接筛选出来，有两种方式来达到这个目的。

（1）Follow TCP Stream菜单开启

当我们在一个数据包上右键选择“追踪流”|“TCP流”时，即追踪TCP流，就把“请求源ip1:port1和请求目标ip2:port2”，或“请求源ip2:port2和请求目标ip1:port1”的所有数据包筛选出来，也即相当于把固定的双方的会话过程筛选出来了。

（2）利用显式过滤器

首先查看某个TCP报文的stream index，然后在显示过滤器中输入tcp.stream eq 6或tcp.stream == 6

![](/images/wireshark_1_2.png)

# 使用WireShark抓取浏览器访问一张jpeg图片的过程

## 访问一张HTTP图片

数据包过程如下：

（1）TCP三次握手建立连接

（2）浏览器发送/GET的HTTP请求报文

（3）服务器通过N个TCP包直接将图片的内容发送给浏览器（因为应用层是一个完整的HTTP响应报文，HTTP响应报文在TCP层会被分片，所以只有一个TCP包的数据部分才有HTTP层的resp header）

（4）服务器发送一个HTTP的响应报文，报文中有标识图片文件的起始位置，编码格式等等（按说TCP分片HTTP报文时，包含HTTP resp header的应该在第一个TCP报文中的，为啥是在最后的一个TCP包中呢，待确认？）

（5）四次握手断开连接

![](/images/wireshark_1_3.png)

## 访问一张HTTPS图片

（1）TCP三次握手建立连接

（2）HTTPS协商阶段，包括ClientHello，ServerHello以及Change Cipher Spec等。在该阶段中，看到的都是TLS协议层的报文。

（3）HTTPS应用数据传输阶段，各种TLS的Application Data的报文。在该阶段中，HTTP报文已经被加密的了，看不到任何HTTP header和body的相关内容啦。

（4）四次握手断开连接

![](/images/wireshark_1_5.png)

# WireShark闲杂

（1）修改抓包列表中时间戳显示格式

点击“视图”|“时间显示格式”|“日期和时间”，可以将抓包中的时间显示为常规的可读性好的时间格式。

（2）着色规则的修改

在WireShark的抓包列表中可以看到各种颜色的报文，可以通过点击“视图”|“着色规则”来进行查看和修改。

![](/images/wireshark_1_4.png)

（3）获取字段名称用于显式过滤器的条件

在“封包详细信息”中展开各字段，在要关注的字段上右击选择Copy|Field Name即可将字段的名称复制到剪贴板中，然后在显式过滤器框中输入条件即可。

# tcpdump与WireShark关系

tcpdump是命令行界面CUI，WireShark是图形用户界面GUI，WireShark相对tcpdump而言，界面更友好、功能更强大。

Unix平台（包括Mac OS）下的WireShark是基于libpcap实现的，Window平台下的WireShark则是基于winpcap实现的。libpcap，Packet Capture Libray，即数据包捕获函数库，源于tcpdump项目。最开始是由tcpdump中剥离出的抓包、过滤、capture file的读写代码提炼而成，现在也是由tcpdump项目的开发组织tcpdump.org维护。

捕获抓包机制是在数据链路层增加一个旁路处理（并不干扰系统自身的网络协议栈的处理），对发送和接收的数据包通过Unix内核做过滤和缓冲处理，最后直接传递给上层应用程序。一个包的捕捉分为三个主要部分，包括面向底层包捕获、面向中间层的数据包过滤和面向应用层的用户接口。

libpcap作为捕捉网络数据包的库，它是一个独立于系统的用户级API接口，为底层网络检测提供了一个可移植的框架。

鉴于WireShark和tcpdump都共同使用libpcap作为其底层抓包的库，可以用WireShark打开tcpdump抓包保存的pcap文件进行分析。

WireShark使用详细参考：
https://www.cnblogs.com/TankXiao/archive/2012/10/10/2711777.html
