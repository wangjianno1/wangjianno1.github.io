---
title: HTTP内容协商及Vary头部介绍
date: 2022-02-25 23:52:23
tags:
categories: HTTP
---

# HTTP内容协商机制简介

要了解Vary的作用，先得了解HTTP内容协商机制。有时候，同一个URL可以提供多份不同的文档，这就要求服务端和客户端之间有一个选择最合适版本的机制，这就是内容协商。
协商方式有两种，一种是服务端把文档可用版本列表发给客户端让用户选，这可以使用300 Multiple Choices状态码来实现。这种方案有不少问题，首先多一次网络往返；其次服务端同一文档的某些版本可能是为拥有某些技术特征的客户端准备的，而普通用户不一定了解这些细节。举个例子，服务端通常可以将静态资源输出为压缩和未压缩两个版本，压缩版显然是为支持压缩的客户端而准备的，但如果让普通用户选，很可能选择错误的版本。所以HTTP的内容协商通常使用另外一种方案，服务端根据客户端发送的请求头中某些字段自动发送最合适的版本。可以用于这个机制的请求头字段又分两种：内容协商专用字段（Accept/Accept-XXX字段）、其他字段（User Agent/Cookies等）。

首先来看Accept/Accept-XXX字段，详见下表：

![](/images/http_vary_1_1.png)

例如，客户端发送以下请求头：

    Accept:*/*
    Accept-Encoding:gzip,deflate,sdch
    Accept-Language:zh-CN,en-US;q=0.8,en;q=0.6

分别表示它可以接受任何MIME类型的资源；支持采用gzip、deflate或sdch压缩过的资源；可以接受zh-CN、en-US和en三种语言，并且zh-CN的权重最高（q取值0-1，最高为1，最低为0，默认为1），服务端应该优先返回语言等于zh-CN的版本。

浏览器的响应头可能是这样的：

    Content-Type: text/javascript
    Content-Encoding: gzip

表示这个文档确切的MIME类型是`text/javascript`；文档内容进行了gzip压缩；响应头没有Content-Language字段，通常说明返回版本的语言正好是请求头Accept-Language中权重最高的那个。

有时候，上面四个Accept字段并不够用，例如要针对特定浏览器如IE6输出不一样的内容，就需要用到请求头中的User-Agent字段。类似的，请求头中的Cookie也可能被服务端用做输出差异化内容的依据。

备注：Content-Encoding是消息内容编码，比如br、gzip等等。Transfer-Encoding是消息传输时编码，比如chunked，二者有很大的不同，需要注意一下。

# HTTP Vary头部

在上面的内容协商的机制中，当客户端和服务端之间可能存在一个或多个中间实体（比如有多级缓存服务器），而缓存服务最基本的要求是给用户返回正确的文档。如果源站服务端根据不同User-Agent返回不同内容，而中间的缓存服务器把IE6用户的响应缓存下来，并返回给使用其他浏览器的用户，肯定会出问题。

因此HTTP协议规定，如果源站服务端提供的内容取决于User-Agent这样「常规Accept协商字段之外」的请求头字段，那么响应头中必须包含Vary字段，且Vary的内容必须包含User-Agent。同理，如果服务端同时使用请求头中User-Agent和Cookie这两个字段来生成内容，那么响应中的Vary字段看上去应该是这样的：

    Vary: User-Agent, Cookie

也就是说Vary字段用于列出一个响应字段列表，告诉缓存服务器遇到同一个URL对应着不同版本文档的情况时，如何缓存和筛选合适的版本。

举例来说，首次请求没命中缓存服务，详细过程如下：

![](/images/http_vary_1_2.png)

再次请求时，命中缓存服务器，其交互过程如下：

![](/images/http_vary_1_3.png)

简单来说，Vary响应头的值是一个或多个请求头。Vary响应头，是源站服务器用来告诉缓存服务器的，需要将Vary响应头中指定的请求头加入了缓存服务器的缓存Key中。

# Nginx中配置Vary

Nginx中的`gzip_vary on | off;`配置可以打开Nginx的响应Vary头部功能。

学习资料参考于：
https://imququ.com/post/vary-header-in-http.html
