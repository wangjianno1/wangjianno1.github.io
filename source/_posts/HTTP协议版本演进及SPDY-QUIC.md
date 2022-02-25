---
title: HTTP协议版本演进及SPDY|QUIC
date: 2018-02-02 19:05:07
tags: BKM
categories: HTTP
---

# HTTP协议版本演进

（1）HTTP/0.9

1991年HTTP/0.9提出，是HTTP的原型版本。但是HTTP/0.9的设计有严重的缺陷，它很快被HTTP/1.0取代了。

（2）HTTP/1.0

HTTP/1.0是第一个得到广泛使用的HTTP版本。HTTP/1.0添加了版本号、各种HTTP首部、一些额外的方法，以及对多媒体对象的处理，它集合了一系列的最佳实践。

（3）HTTP/1.0+

在20世纪90年代中叶，HTTP协议增加了很多的特性，例如持久的keep-alive连接、虚拟主机支持，以及代理连接等等，这些特性成为了非官方的事实标准。这种非正式的HTTP扩展版本通常称为HTTP/1.0+

（4）HTTP/1.1

HTTP/1.1重点关注的是校正HTTP设计中的结构性缺陷，明确语义，引入重要的性能优化措施，并提出了一些不好的特性。HTTP/1.1是当前使用的HTTP版本。

（5）HTTP/2.0（又名为HTTP-NG）

HTTP-NG是HTTP/1.1后继结构的原型建议，它重点关注的是性能的大幅优化，以及更强大的服务逻辑远程执行框架。HTTP-NG的研究工作终止于1988年，但目前HTTP-NG还处在没有被推广实施的阶段。

# SPDY

SPDY，一种开放的网络传输协议，由Google开发，用来发送网页内容。基于传输控制协议TCP的应用层协议。Google最早是在Chromium中提出的SPDY协议。被用于Google Chrome浏览器中来访问Google的SSL加密服务。SPDY并不是首字母缩略字，而仅仅是"speedy"的缩写。SPDY现为Google的商标。HTTP/2的关键功能主要来自SPDY技术，换言之，SPDY的成果被采纳而最终演变为HTTP/2。

SPDY并不是一个标准协议，但SPDY的开发组推动SPDY成为正式标准，而成为了互联网草案。后来SPDY未能单独成为正式标准，不过SPDY开发组的成员全程参与了HTTP/2的制定过程。Google Chrome、Mozilla Firefox、Safari、Opera、Internet Explorer等主要浏览器均已经或曾经支持SPDY协议。SPDY协议类似于HTTP，但旨在缩短网页的加载时间和提高安全性。SPDY协议通过压缩、多路复用和优先级来缩短加载时间。HTTP/2协议完成之后，Google认为SPDY可以功成身退了，于是最终Google Chrome淘汰对SPDY的支持，全面改为采用HTTP/2。

# QUIC

QUIC是快速UDP网络连接（英文全称为Quick UDP Internet Connections）的缩写，这是一种实验性的传输层网络传输协议，由Google公司开发，在2013年实现。Google希望使用这个协议来取代TCP协议，使网页传输速度加快，计划将QUIC提交至互联网工程任务小组（IETF），让它成为下一代的正式网络规范。

目前来说，HTTP的数据传输都基于TCP协议。TCP协议在创建连接之前需要进行三次握手，如果需要提高数据交互的安全性，既增加传输层安全协议（TLS），还会增加更多的握手次数。而QUIC协议可以在1到2个数据包（取决于连接的服务器是新的还是已知的）内，完成连接的创建（包括TLS）。

QUIC协议内置了TLS栈，实现了自己的传输加密层，而没有使用现有的TLS1.2。同时QUIC还包含了部分HTTP/2的实现。如下为使用了QUIC协议和传统的HTTP的协议栈的对比图：

![](/images/http_proto_1_1.png)

备注：QUIC协议是Google使用QUIC+UDP来取代TCP，来优化WEB服务器和浏览器间数据传输。也就是说Google让HTTP通信底层使用了UDP协议。


学习资料参考于：
http://www.infoq.com/cn/articles/quic-google-protocol-web-platform-from-tcp-to-udp
