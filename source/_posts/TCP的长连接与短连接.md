---
title: TCP的长连接与短连接
date: 2018-12-09 21:01:50
tags:
categories: Network
---

# TCP的连接的建立与释放

TCP是三次握手建立通信双方的连接，四次握手断开通信双方的连接。

# 短连接

所谓短连接，简单来说，Client向Server通过三次握手建立连接后，Client向Server发起通信请求，Server回应数据，完成一次数据的读写后，双方通过四次握手关闭连接。

# 长连接

所谓长连接，简单来说，Client向Server通过三次握手建立连接后，Client向Server发起通信请求，Server回应数据，完成一次数据的读写后，双方不会立即关闭这个连接，而是会继续保持这个连接，后续Client和Server端有数据通信时，就不需要再次三次握手建立通信连接。

# HTTP的TCP连接保持

![](/images/network_keepalive_1_1.jpg)

一次HTTP请求完成以后TCP连接能关闭吗？如果使用的是HTTP 1.1，这个连接默认是keep-alive，也就是说TCP连接不会关闭；如果是HTTP 1.0，要看看之前的HTTP Request Header中有没有Connetion:keep-alive，如果有，那TCP连接也是不能关闭。
