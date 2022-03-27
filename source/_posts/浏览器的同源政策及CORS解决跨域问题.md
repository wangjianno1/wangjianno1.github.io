---
title: 浏览器的同源政策及CORS解决跨域问题
date: 2018-02-04 15:46:54
tags:
categories: 大前端
---

# 浏览器的同源政策

同源是针对两个网页资源来说的，如果两个网页同时满足下面三个条件：

（1）协议相同

（2）域名相同

（3）端口相同

那么就称这两个网页资源是同源的。

同源政策是在1995年，由Netscape公司引入浏览器。目前，所有浏览器都实行这个政策。浏览器安全的基石是“同源政策”（same-origin policy）。

# 同源政策的限制

最初遵循同源政策的浏览器让A网页设置的Cookie，B网页不能打开，除非这两个网页“同源”。随着互联网的发展，“同源政策”越来越严格。目前，如果非同源，共有三种行为受到限制：

（1）Cookie、LocalStorage和IndexDB无法读取

（2）DOM无法获得

（3）AJAX请求不能发送

备注：虽然这些限制是必要的，但是有时很不方便，合理的用途也受到影响。

# 规避同源政策导致跨域AJAX问题

同源政策规定，AJAX请求只能发给同源的网址，否则就报错。 一般来说，有如下几种方式来规避同源问题：

（1）架设反向代理服务器，不同源的经过反向代理服务器后，就成为同源的服务器，然后由反向代理服务器将请求分发给不同的服务器来处理。

（2）JSONP

（3）WebSocket

（4）CORS

CORS是跨源资源分享（Cross-Origin Resource Sharing）的缩写。它是W3C标准，是跨源AJAX请求的根本解决方法，它允许浏览器向跨源服务器，发出XMLHttpRequest请求，从而克服了AJAX只能同源使用的限制。相比JSONP只能发GET请求，CORS允许任何类型的请求。

# CORS解决跨域AJAX问题细谈

（1）简单请求 与 非简单请求

浏览器将HTTP分为简单请求和非简单请求。其中非简单请求是那种对服务器有特殊要求的请求，比如请求方法是PUT或DELETE，或者Content-Type字段的类型是application/json等等。

（2）简单请求

对于简单请求，浏览器直接发出CORS请求。

下面是一个例子，浏览器发现这次跨源AJAX请求是简单请求，就自动在头信息之中，添加一个Origin字段。

    GET /sfs HTTP/1.1
    Origin: http://api.bob.com
    Host: api.alice.com
    Accept-Language: en-US
    Connection: keep-alive
    User-Agent: Mozilla/5.0...

上面的头信息中，Origin字段用来说明，本次请求来自哪个源（协议 + 域名 + 端口）。服务器根据这个值，决定是否同意这次请求。

如果Origin指定的源，不在许可范围内，服务器会返回一个正常的HTTP回应。浏览器发现，这个回应的头信息没有包含Access-Control-Allow-Origin字段，就知道出错了，从而抛出一个错误，被XMLHttpRequest的onerror回调函数捕获。注意，这种错误无法通过状态码识别，因为HTTP回应的状态码有可能是200。如果Origin指定的域名在许可范围内，服务器返回的响应，会多出几个头信息字段。

    Access-Control-Allow-Origin: http://api.bob.com
    Access-Control-Allow-Credentials: true
    Access-Control-Expose-Headers: FooBar
    Content-Type: text/html; charset=utf-8

（3）非简单请求

非简单请求的CORS请求，会在正式通信之前，增加一次HTTP查询请求，称为"预检"请求（cors-preflight-request）， 预检的HTTP Request Method为OPTIONS。浏览器先询问服务器，当前网页所在的域名是否在服务器的许可名单之中，以及可以使用哪些HTTP动词和头信息字段。只有得到肯定答复，浏览器才会发出正式的XMLHttpRequest请求，否则就报错。

由此可见，当触发预检时，一次AJAX请求会消耗掉两个TTL，严重影响性能。那么如何节省掉OPTIONS请求来提升性能呢？从上文可以看出，有两个方案：一是，发出简单请求；二是服务器端设置Access-Control-Max-Age字段，那么当第一次请求该URL时会发出OPTIONS请求，浏览器会根据返回的Access-Control-Max-Age字段缓存该请求的OPTIONS预检请求的响应结果（具体缓存时间还取决于浏览器的支持的默认最大值，取两者最小值，一般为10分钟）。在缓存有效期内，该资源的请求（URL和header字段都相同的情况下）不会再触发预检。

学习资料参考于：
http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html
http://www.ruanyifeng.com/blog/2016/04/cors.html
http://javascript.ruanyifeng.com/#bom
