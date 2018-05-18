---
title: 浏览器HTTP缓存机制（Last-Modified/Etag/Expires/Cache-Control等）
date: 2018-05-18 15:16:06
tags:
categories: 杂货铺
---

# 浏览器HTTP缓存简介

WEB缓存是一种保存WEB资源副本并在下次请求时直接使用该副本的技术。WEB缓存可以分为如下几种：

- 浏览器HTTP缓存
- CDN缓存
- 服务器缓存
- 数据库数据缓存

因为可能会直接使用副本免于重新发送请求，或者仅仅确认资源没变无需重新传输资源实体，WEB缓存可以减少延迟加快网页打开速度、重复利用资源减少网络带宽消耗、降低请求次数或者减少传输内容从而减轻服务器压力。

该篇文章主要讨论浏览器HTTP缓存机制，浏览器HTTP缓存可以分为强缓存和协商缓存。强缓存和协商缓存最大也是最根本的区别是：强缓存命中的话不会发请求到服务器（比如chrome中的200 from memory cache），协商缓存一定会发请求到服务器，通过资源的请求首部字段验证资源是否命中协商缓存，如果协商缓存命中，服务器会将这个请求返回，但是不会返回这个资源的实体，而是通知客户端可以从缓存中加载这个资源（304 not modified）。

浏览器HTTP缓存机制是通过一些HTTP请求头或响应头来控制的，浏览器HTTP缓存相关的头部有`Last-Modified/Etag/Expires/Cache-Control`等等。

# 浏览器HTTP缓存机制之强缓存相关的请求头/响应头

（1）Pragma

Pragma是HTTP/1.1之前版本遗留的通用首部字段，仅作为于HTTP/1.0的向后兼容而使用。虽然它是一个通用首部，但是它在响应报文中时的行为没有规范，依赖于浏览器的实现。RFC中该字段只有no-cache一个可选值，会通知浏览器不直接使用缓存，要求向服务器发请求校验新鲜度。因为它优先级最高，当存在时一定不会命中强缓存。

（2）Cache-Control

Cache-Control是一个通用首部字段，也是HTTP/1.1控制浏览器缓存的主流字段。Cache-Control头部的格式如下：

```
Cache-Control: cache-directive
```

作为请求首部时，cache-directive的可选值有：

![](/images/httpcache_1_1.png)

作为响应首部时，cache-directive的可选值有：

![](/images/httpcache_1_2.png)

举例来说，

```
Cache-Control: max-age=3600
```

这里声明的是一个相对的秒数，表示从现在起，3600秒内缓存都是有效的，这样就避免了服务端和客户端时间不一致的问题。但是Cache-Control是HTTP1.1才有的，不适用于HTTP1.0，而Expires既适用于HTTP1.0，也适用于HTTP1.1，所以说在大多数情况下同时发送这两个头会是一个更好的选择，当客户端两种头都能解析的时候，会优先使用Cache-Control。

另外，Cache-Control 允许自由组合可选值，例如：

```
Cache-Control: max-age=3600, must-revalidate
```

它意味着该资源是从原服务器上取得的，且其缓存（新鲜度）的有效时间为一小时，在后续一小时内，用户重新访问该资源则无须发送请求。 当然这种组合的方式也会有些限制，比如 no-cache 就不能和 max-age、min-fresh、max-stale 一起搭配使用。

（3）Expires

Expires是一个响应首部字段，它指定了一个日期/时间，在这个时间/日期之前，HTTP缓存被认为是有效的。无效的日期比如0，表示这个资源已经过期了。如果同时设置了Cache-Control响应首部字段的max-age，则Expires会被忽略。它也是HTTP/1.1之前版本遗留的通用首部字段，仅作为于HTTP/1.0的向后兼容而使用。

举例来说，

```
Expires: Thu, 10 Dec 2015 23:21:37 GMT
```

浏览器端收到包含Expires字段的响应报文后，下一次再次请求该资源时，当前时间是在Expires的日期之前，客户端会认为浏览器缓存是有效的，因此浏览器不会连接服务器，直接从本地缓存中读取。不过Expires有缺点，比如说，服务端和客户端的时间设置可能不同，这就会使缓存的失效可能并不能精确的按服务器的预期进行。

# 浏览器HTTP缓存机制之协商缓存相关的请求头/响应头

（1）ETag/If-None-Match

ETag是一个响应首部字段，它是根据实体内容生成的一段hash字符串，标识资源的状态，由服务端产生。If-None-Match是一个条件式的请求首部。如果请求资源时在请求首部加上这个字段，值为之前服务器端返回的资源上的ETag，则当且仅当服务器上没有任何资源的ETag属性值与这个首部中列出的时候，服务器才会返回带有所请求资源实体的200响应，否则服务器会返回不带实体的304响应。ETag优先级比Last-Modified高，同时存在时会以ETag为准。

![](/images/httpcache_1_3.png)

HTTP 协议规格说明定义 ETag 为“被请求变量的实体值”。 服务器单独负责判断记号是什么及其含义，并在HTTP响应头中将其传送到客户端，以下是服务器端返回的格式：

```
ETag: "d41d8cd98f00b204e9800998ecf8427e"
```

客户端的查询更新格式是这样的：

```
If-None-Match: W/"d41d8cd98f00b204e9800998ecf8427e"
```

如果ETag没改变，则返回状态304，内容为空，这也和Last-Modified一样。

（2）Last-Modified/If-Modified-Since

If-Modified-Since是一个请求首部字段，并且只能用在GET或者HEAD请求中。Last-Modified是一个响应首部字段，包含服务器认定的资源作出修改的日期及时间。当带着If-Modified-Since头访问服务器请求资源时，服务器会检查Last-Modified，如果Last-Modified的时间早于或等于If-Modified-Since则会返回一个不带主体的304响应，否则将重新返回资源。

在浏览器第一次请求某一个URL时，服务器端的返回状态会是200，内容是你请求的资源，同时有一个Last-Modified的属性
标记此文件在服务期端最后被修改的时间，格式类似这样：

```
Last-Modified: Mon, 30 Nov 2015 23:21:37 GMT
```

浏览器第二次请求此URL时，根据HTTP协议的规定，浏览器会向服务器传送If-Modified-Since报头，询问该时间之后文件是否有被修改过：

```
If-Modified-Since: Mon, 30 Nov 2015 23:21:37 GMT
```

如果服务器端的资源没有变化，则自动返回HTTP 304（Not Changed）状态码，内容为空，这样就节省了传输数据量。当服务器端代码发生改变或者重启服务器时，则重新发出资源，返回和第一次请求时类似。从而保证不向客户端重复发出资源，也保证当服务器有变化时，客户端能够得到最新的资源。

# 浏览器HTTP缓存相关的头部优先级

（1）强缓存相关的请求头/响应头优先级

```
Pragma -> Cache-Control -> Expires
```

（2）协商缓存相关的请求头/响应头优先级

```
ETag/If-None-Match -> Last-Modified/If-Modified-Since
```

备注：强缓存的优先级高于协商缓存，也就是说只有本地强缓存策略失效后，才会考虑向考虑向后端询问协商。

学习资料参考于：
https://juejin.im/post/5a673af06fb9a01c927ed880
http://blog.wpjam.com/m/last-modified-etag-expires-cache-control/