---
title: TCP的长连接与短连接
date: 2018-12-09 21:01:50
tags:
categories: Network
---

# TCP的连接的建立与释放

TCP是三次握手建立通信双方的连接，四次握手断开通信双方的连接。

# TCP短连接

所谓短连接，简单来说，Client向Server通过三次握手建立连接后，Client向Server发起通信请求，Server回应数据，完成一次数据的读写后，双方通过四次握手关闭连接。

# TCP长连接

所谓长连接，简单来说，Client向Server通过三次握手建立连接后，Client向Server发起通信请求，Server回应数据，完成一次数据的读写后，双方不会立即关闭这个连接，而是会继续保持这个连接，后续Client和Server端有数据通信时，就不需要再次三次握手建立通信连接。

# HTTP的TCP连接保持

![](/images/network_keepalive_1_1.jpg)

一次HTTP请求完成以后TCP连接能关闭吗？在HTTP/1.0中默认使用TCP短连接，也就是说，浏览器和WEB服务器每进行一次HTTP操作，就建立一次TCP连接，请求结束后就中断TCP连接。而从HTTP/1.1起，默认使用的是TCP长连接，用以保持连接特性。如果是HTTP/1.0，要使用TCP长连接的话，需要在HTTP Request Header中加入Connetion:keep-alive。

在使用TCP长连接的情况下，当一个网页打开完成后，客户端和服务器之间用于传输HTTP数据的TCP连接不会关闭，客户端再次访问这个服务器时，会继续使用这一条已经建立的连接。Keep-Alive不会永久保持连接，它有一个保持时间，可以在不同的WEB服务器软件（如Apache）中设定这个时间。实现TCP长连接需要浏览器和WEB服务器都支持TCP长连接。

简单来说，HTTP协议的长连接和短连接，实质上是TCP协议的长连接和短连接。
