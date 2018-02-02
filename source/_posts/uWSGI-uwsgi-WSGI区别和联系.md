---
title: uWSGI | uwgsi | WSGI区别和联系
date: 2018-02-02 18:22:36
tags: Python实践
categories: Python
---

# uWSGI | WSGI | uwsgi三者的区别

（1）WSGI

WSGI是一种类似于CGI/FastCGI等的通信协议，具体参见http://blog.csdn.net/wangjianno2/article/details/50939952

（2）uwsgi

uwsgi是与WSGI一样是一种通信协议，它是uWSGI服务器自有的协议，它用于定义传输信息的类型（type of information），每一个uwsgi packet前4byte为传输信息类型描述。与WSGI协议是两种东西，据说该协议是fcgi协议的10倍快。

（3）uWSGI

uWSGI是一个Web服务器，它实现了WSGI协议、uwsgi、http等协议。

# Nginx对uwsgi协议的支持

nginx中ngx_http_uwsgi_module模块就是对uwsgi协议的支持。通过该模块，我们可以部署分布式的服务。

![](/images/uwsgi_1_1.png)

# 使用uWSGI服务器部署Python WSGI应用

架构图如下：

![](/images/uwsgi_1_2.png)

其中APP是支持WSGI协议的APP，例如django应用。
