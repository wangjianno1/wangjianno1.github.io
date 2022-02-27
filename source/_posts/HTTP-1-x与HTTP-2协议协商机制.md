---
title: HTTP/1.x与HTTP/2协议协商机制
date: 2022-02-27 23:12:31
tags:
categories: HTTP
---

# HTTP协议协商机制简介

HTTP协议协商机制指的是，客户端与服务端协商使用HTTP/1.x还是HTTP/2来进行通信。其实HTTP/2可以运行在TLS上，也可以不使用TLS，也即对应如下两种：

（1）HTTP/2 over TLS，h2

字符串"h2"标识HTTP/2使用传输层安全性(TLS)的协议。该标识符用于TLS应用层协议协商（ALPN）扩展TLS-ALPN字段以及识别HTTP/2 over TLS的任何地方。

（2）HTTP/2 over TCP，h2c

字符串"h2c"标识通过明文TCP运行HTTP/2的协议。此标识符用于HTTP/1.1升级标头字段以及标识HTTP/2 over TCP的任何位置。

相应地，HTTP协议版本协商机制也有两种，一种HTTP Upgrade；另一种是TLS ALPN扩展来协商。

# HTTP Upgrade机制


为了更方便地部署新协议，HTTP/1.1引入了Upgrade机制，它使得客户端和服务端之间可以借助已有的HTTP语法升级到其它协议。

要发起HTTP/1.1协议升级，客户端必须在请求头部中指定这两个字段：

    Connection: Upgrade
    Upgrade: protocol-name[/protocol-version]

客户端通过Upgrade头部字段列出所希望升级到的协议和版本，多个协议之间用英文逗号和空格（0x2C, 0x20）隔开。除了这两个字段之外，一般每种新协议还会要求客户端发送额外的新字段，这里略过不写。

如果服务端不同意升级或者不支持Upgrade所列出的协议，直接忽略即可（当成HTTP/1.1请求，以HTTP/1.1响应）；如果服务端同意升级，那么需要这样响应：

    HTTP/1.1 101 Switching Protocols
    Connection: upgrade
    Upgrade: protocol-name[/protocol-version]
     
    [... data defined by new protocol ...]

可以看到，HTTP Upgrade响应的状态码是101，并且响应正文可以使用新协议定义的数据格式。

举例来说，

    GET / HTTP/1.1
    Host: example.com
    Connection: Upgrade, HTTP2-Settings
    Upgrade: h2c
    HTTP2-Settings: <base64url encoding of HTTP/2 SETTINGS payload>

在HTTP Upgrade机制中，HTTP/2的协议名称是h2c，代表HTTP/2 ClearText。如果服务端不支持HTTP/2，它会忽略Upgrade字段，直接返回HTTP/1.1响应，例如：

    HTTP/1.1 200 OK
    Content-Length: 243
    Content-Type: text/html
     
    ...

如果服务端支持HTTP/2，那就可以回应101状态码及对应头部，并且在响应正文中可以直接使用HTTP/2二进制帧：

    HTTP/1.1 101 Switching Protocols
    Connection: Upgrade
    Upgrade: h2c
     
    [ HTTP/2 connection … ]

以下是通过HTTP Upgrade机制将HTTP/1.1升级到HTTP/2的Wireshark抓包：

![](/images/http2_1_9.png)

根据HTTP/2协议中的描述，额外补充几点：

（1）41号包中，客户端发起的协议升级请求中，必须通过HTTP2-Settings指定一个经过Base64编码过的HTTP/2 SETTINGS帧；

（2）45号包中，服务端同意协议升级，响应正文中必须包含HTTP/2 SETTING帧（二进制格式，不需要Base64编码）；

（3）62号包中，客户端可以开始发送各种HTTP/2帧，但第一个帧必须是Magic帧（内容固定为`PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n`），做为协议升级的最终确认；

HTTP Upgrade机制本身没什么问题，但很容易受网络中间环节影响。例如不能正确处理Upgrade头部的代理节点，很可能造成最终升级失败。之前我们统计过WebSocket的连通情况，发现大量明明支持WebSocket的浏览器却无法升级，只能使用降级方案。

# TLS ALPN扩展

HTTP/2协议本身并没有要求它必须基于HTTPS（TLS部署，但是出于以下三个原因，实际使用中，HTTP/2和HTTPS几乎都是捆绑在一起：

（1）HTTP数据明文传输，数据很容易被中间节点窥视或篡改，HTTPS可以保证数据传输的保密性、完整性和不被冒充；

（2）正因为HTTPS传输的数据对中间节点保密，所以它具有更好的连通性。基于HTTPS部署的新协议具有更高的连接成功率；

（3）当前主流浏览器，都只支持基于HTTPS部署的HTTP/2；

如果前面两个原因还不足以说服你，最后这个绝对有说服力，除非你的HTTP/2服务只打算给自己客户端用。

基于HTTPS的协议协商非常简单，多了TLS之后，双方必须等到成功建立TLS连接之后才能发送应用数据。而要建立TLS连接，本来就要进行CipherSuite等参数的协商。引入HTTP/2之后，需要做的只是在原本的协商机制中把对HTTP协议版本的协商加进去。

Google在SPDY协议中开发了一个名为NPN（Next Protocol Negotiation，下一代协议协商）的TLS扩展。随着SPDY被HTTP/2取代，NPN也被官方修订为ALPN（Application Layer Protocol Negotiation，应用层协议协商）。二者的目标和实现原理基本一致，这里只介绍后者。如图：

![](/images/http2_1_10.png)

可以看到，客户端在建立TLS连接的ClientHello握手中，通过ALPN扩展列出了自己支持的各种应用层协议。其中，HTTP/2协议名称是h2。

![](/images/http2_1_11.png)

如果服务端支持HTTP/2，在ServerHello中指定ALPN的结果为h2就可以了；如果服务端不支持HTTP/2，从客户端的ALPN列表中选一个自己支持的即可。

并不是所有HTTP/2客户端都支持ALPN，理论上建立TLS连接后，依然可以再通过HTTP Upgrade进行协议升级，只是这样会额外引入一次往返。

# 其他闲杂问题

HTTP/2需要基于HTTPS部署是当前主流浏览器的要求。如果你的HTTP/2服务要支持浏览器访问，那就必须基于HTTPS部署；如果只给自己客户端用，可以不部署HTTPS（这个页面列举了很多支持h2c的HTTP/2服务端、客户端实现）。

支持HTTP/2的Web Server基本都支持HTTP/1.1。这样，即使浏览器不支持HTTP/2，双方也可以协商出可用的HTTP版本，没有兼容性问题。如下表：

![](/images/http2_1_12.png)

学习资料参考于：
https://imququ.com/post/protocol-negotiation-in-http2.html
