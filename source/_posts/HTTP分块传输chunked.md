---
title: HTTP分块传输chunked
date: 2022-02-26 00:15:39
tags:
categories: HTTP
---

# 分块传输简介

分块传输编码（Chunked transfer encoding）是超文本传输协议（HTTP）中的一种数据传输机制，它允许HTTP由网页服务器发送给客户端应用的数据可以分成多个部分。分块传输编码只在HTTP协议1.1版本（HTTP/1.1）中提供。

通常情况下，HTTP应答消息中发送的数据是整个发送的，Content-Length消息头字段表示数据的长度。数据的长度很重要，因为客户端需要知道哪里是应答消息的结束，以及后续应答消息的开始。然而，使用分块传输编码，数据分解成一系列数据块，并以一个或多个块发送，这样服务器可以发送数据而不需要预先知道发送内容的总大小。

# 分块传输编码使用场景

当客户端向服务器请求一个静态页面或者一张图片时，服务器可以很清楚的知道内容大小，然后通过Content-Length消息首部字段告诉客户端需要接收多少数据。但是如果是动态页面等时，服务器是不可能预先知道内容大小，这时就可以使用`Transfer-Encoding：chunk`模式来传输数据了。即如果要一边产生数据，一边发给客户端，服务器就需要使用`Transfer-Encoding: chunked`这样的方式来代替Content-Length。在进行chunked编码传输时，在回复消息的头部有`Transfer-Encoding: chunked`。

简单来说，使用分块传输，就是服务器在一定时间内计算不出来响应内容的长度，如果不返回Content-Length的话，应用层可能就不知道一个HTTP报文的结尾，而解析不了。

# 分块传输编码格式

分块传输编码使用若干个chunk组成，由一个标明长度为0的chunk结束。每个chunk有两部分组成，第一部分是该chunk的长度，第二部分就是指定长度的内容，每个部分用CR/LF隔开。在最后一个长度为0的chunk中的内容是称为footer的内容，是一些没有写的头部内容。chunk编码格式如下：

    [chunk size][\r\n][chunk data][\r\n][chunk size][\r\n][chunk data][\r\n][chunk size = 0][\r\n][\r\n]

chunk size是以十六进制的ASCII码表示，比如头部是3134这两个字节，表示的是1和4这两个ASCII字符，被HTTP协议解释为十六进制数14，也就是十进制的20，后面紧跟[\r\n](0d 0a)，再接着是连续的20个字节的chunk正文。chunk数据以0长度的chunk块结束，也就是（30 0d 0a 0d 0a）。

需要注意的是，使用HTTP chunked将HTTP的响应正文拆分成很多的块，但他们还是在一个HTTP响应报文中哦，而不是不同的分块用不同的HTTP报文来封装哦。

# 分块编码传输译码过程

首选需要确认收到的数据时使用的chunked编码，也就是找到Transfer-Encoding: chunked，如果你找到了，好的，那接下来就可以按照下面的步骤开始进行解析了。

（1）需要找到数据开始地方，也就是第一个chunk size开始的地方，这个地方的标识符为\r\n\r\n。

（2）要成功获取到这一块的数据长度，这个地方需要注意了，十六进制的ASCII码表示。是的，字符串转成数字，你想起来函数atoi()了吗？恭喜你，你函数选择错了，atoi()只能识别数字0-9，遇到A-F就截断了，不过不用担心，还有一个函数叫做strtol(), 它可以随意的转换2-36进制。

（3）获取到数据块长度了，就可以copy数据了是吧，是不是很简单，但是如果你使用了`str***`相关的函数，那么恭喜你，你又错了，他们遇到\0就会停止，而你需要copy的数据可能会遇到很多个\0，还好有memcpy()这一类的函数可以使用。如果数据时写到指针里面，多次copy数据时记得指针的偏移。

（4）接下就跳过\r\n去获取下一个数据块长度，然后copy数据吧，直到你遇到一个数据块的长度为0,到这里数据就完全获取成功了。

# Nginx关闭chunked模式

Nginx关闭chunked模式配置如下：

    chunked_transfer_encoding off;

# 关于分开传输的一些闲杂知识

（1）服务端选择使用chunked传输，那么服务端是无法知道消息体的长度的，也就是不确定Content-Length的大小。因此使用chunked传输时，HTTP响应Header中是没有Content-Length的。若端上依赖Content-Length则会有一些问题。

（2）目前，CDN使用非常普遍，若客户端请求压缩格式gzip的内容，即请求Header中包含Content-Encoding: gzip，若请求到达CDN时，CDN没有缓存压缩格式为gzip的内容，则服务端需要将内容压缩为gzip返回客户端，服务端为了响应速度，会使用chunked模式传输，这时响应Header中也将没有Content-Length。相反，若客户端不支持gzip压缩，而CDN只缓存了压缩后的数据，那CDN可能也会选择使用chunked模式来传输。

（3）Content-Encoding是消息内容编码，比如br、gzip等等。Transfer-Encoding是消息传输时编码，比如chunked，二者有很大的不同，需要注意一下。

学习资料参考于：
https://blog.csdn.net/whatday/article/details/7571451
https://blog.csdn.net/u012175637/article/details/82467130
