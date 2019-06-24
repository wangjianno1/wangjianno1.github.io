---
title: HTTP常见状态码说明
date: 2019-06-09 18:09:19
tags:
categories: 大前端
---

# HTTP常见状态码

（1）502

502，名称为Bad Gateway，表示作为网关或者代理工作的服务器尝试执行请求时，从上游服务器接收到无效的响应。

（2）503

HTTP 503，Service Unavailable，服务器不可用。

（3）504

504，名称为Gateway Time-out，表示网关或者代理工作的服务器尝试执行请求时，未能及时从上游服务器（URI标识出的服务器，例如HTTP、FTP、LDAP）或者辅助服务器（例如DNS）收到响应。说白了，504即Nginx代理超过了自己设置的超时时间，不等待上游的返回结果，直接给客户端返回504错误。注意：某些代理服务器在DNS查询超时时会返回400或者500错误。

通俗的来说，nginx作为一个代理服务器，将请求转发到其他服务器或者php-cgi来处理，当nginx收到了无法理解的响应时，就返回502。当nginx超过自己配置的超时时间还没有收到请求时，就返回504错误。

（4）206

HTTP范围请求Range Requsets以及部分响应(partial responses)，HTTP 206表示Range Request HTTP请求中，正常返回部分内容Partial Content，和200是差不多的。服务器已经成功处理了部分GET请求。该请求必须包含Range头信息来指示客户端希望得到的内容范围，并且可能包含If-Range来作为请求条件。

（5）416

HTTP 416 Range Not Satisfiable错误状态码意味着服务器无法处理所请求的数据区间。最常见的情况是所请求的数据区间不在文件范围之内，也就是说，Range首部的值，虽然从语法上来说是没问题的，但是从语义上来说却没有意义。

416响应报文包含一个Content-Range首部，提示无法满足的数据区间（用星号`*`表示），后面紧跟着一个“/”，再后面是当前资源的长度。例如：`Content-Range: */12777`，遇到这一错误状态码时，浏览器一般有两种策略：要么终止操作（例如，一项中断的下载操作被认为是不可恢复的），要么再次请求整个文件。

（6）429

在HTTP协议中，429状态码表示Too Many Requests，表示在一定的时间内用户发送了太多的请求，超出了“频次限制”，即被服务端流控了。

（7）499

499状态码表示“client has closed connection”，这很有可能是因为服务器端处理的时间过长，客户端“不耐烦”了。要解决此问题，就需要在程序上面做些优化了。

（8）400

Bad Request。

学习资料参考于：
https://juejin.im/entry/589148f92f301e00690e863d
https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status
