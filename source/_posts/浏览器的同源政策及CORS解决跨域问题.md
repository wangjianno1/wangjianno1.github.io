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


学习资料参考于：
http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html
http://www.ruanyifeng.com/blog/2016/04/cors.html
http://javascript.ruanyifeng.com/#bom
