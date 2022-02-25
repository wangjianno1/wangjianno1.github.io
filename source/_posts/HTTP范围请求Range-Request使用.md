---
title: HTTP范围请求Range Request使用
date: 2019-06-09 18:01:14
tags:
categories: HTTP
---

# HTTP范围请求

HTTP协议范围请求允许服务器只发送HTTP消息的一部分到客户端。范围请求在传送大的媒体文件，或者与文件下载的断点续传功能搭配使用时非常有用。类似于FlashGet或者迅雷这类的HTTP下载工具都是使用此类响应实现断点续传或者将一个大文档分解为多个下载段同时下载。

# 检测服务器端是否支持范围请求

假如在响应中存在Accept-Ranges首部（并且它的值不为 “none”），那么表示该服务器支持范围请求。例如，你可以使用 cURL 发送一个HEAD请求来进行检测。

    curl -I http://i.imgur.com/z4d4kWk.jpg
    HTTP/1.1 200 OK
    ...
    Accept-Ranges: bytes
    Content-Length: 146515

在上面的响应中， Accept-Ranges: bytes表示界定范围的单位是 bytes 。这里 Content-Length也是有效信息，因为它提供了要检索的图片的完整大小。
如果站点未发送Accept-Ranges首部，那么它们有可能不支持范围请求。一些站点会明确将其值设置为"none"，以此来表明不支持。在这种情况下，某些应用的下载管理器会将暂停按钮禁用。

    curl -I https://www.youtube.com/watch?v=EwTZ2xpQwpA
    HTTP/1.1 200 OK
    ...
    Accept-Ranges: none

# 向服务端发送范围请求

假如服务器支持范围请求的话，你可以使用Range首部来生成该类请求。该首部指示服务器应该返回文件的哪一或哪几部分。

## 单一范围

我们可以请求资源的某一部分。这次我们依然用cURL来进行测试。"-H"可以在请求中追加一个首部行，在这个例子中，是用Range首部来请求图片文件的前1024个字节。

    curl http://i.imgur.com/z4d4kWk.jpg -i -H "Range: bytes=0-1023"

这样生成的请求如下：

    GET /z4d4kWk.jpg HTTP/1.1
    Host: i.imgur.com
    Range: bytes=0-1023

服务器端会返回状态码为206 Partial Content的响应：

    HTTP/1.1 206 Partial Content
    Content-Range: bytes 0-1023/146515
    Content-Length: 1024
    ...
    (binary content)

在这里，Content-Length首部现在用来表示先前请求范围的大小（而不是整张图片的大小）。Content-Range响应首部则表示这一部分内容在整个资源中所处的位置。

## 多重范围

Range头部也支持一次请求文档的多个部分。请求范围用一个逗号分隔开。

    curl http://www.example.com -i -H "Range: bytes=0-50, 100-150"

服务器返回206 Partial Content状态码和Content-Type：multipart/byteranges; boundary=3d6b6a416f9b5头部，Content-Type：multipart/byteranges表示这个响应有多个byterange。每一部分byterange都有他自己的Centen-type头部和Content-Range，并且使用boundary参数对body进行划分。

    HTTP/1.1 206 Partial Content
    Content-Type: multipart/byteranges; boundary=3d6b6a416f9b5
    Content-Length: 282
    --3d6b6a416f9b5
    Content-Type: text/html
    Content-Range: bytes 0-50/1270
    <!doctype html>
    <html>
    <head>
        <title>Example Do
    --3d6b6a416f9b5
    Content-Type: text/html
    Content-Range: bytes 100-150/1270
    eta http-equiv="Content-type" content="text/html; c
    --3d6b6a416f9b5--

## 条件式范围请求

当（中断之后）重新开始请求更多资源片段的时候，必须确保自从上一个片段被接收之后该资源没有进行过修改。增加If-Range请求首部可以用来生成条件式范围请求，假如条件满足的话，条件请求就会生效，服务器会返回状态码为206 Partial的响应，以及相应的消息主体。假如条件未能得到满足，那么就会返回状态码为200 OK的响应，同时返回整个资源。该首部可以与Last-Modified验证器或者ETag一起使用，但是二者不能同时使用。

    If-Range: Wed, 21 Oct 2015 07:28:00 GMT

# 范围请求的响应

与范围请求相关的有三种状态：

（1）在请求成功的情况下，服务器会返回206 Partial Content状态码。

（2）在请求的范围越界的情况下（范围值超过了资源的大小），服务器会返回416Requested Range Not Satisfiable（请求的范围无法满足）状态码。

（3）在不支持范围请求的情况下，服务器会返回200 OK状态码。

学习资料参考于：
https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Range_requests
