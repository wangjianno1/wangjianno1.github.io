---
title: uWSGI | uwgsi | WSGI区别和联系
date: 2018-02-02 18:22:36
tags: Python实践
categories: Python
---

# uWSGI | WSGI | uwsgi三者的区别

## WSGI

WSGI，全称为Web Server Gateway Interface，是Python语言中专有的接口协议，WSGI是一种类似于CGI/FastCGI等的通信协议。

下面以一个例子来说明WSGI协议，

（1）编写一个支持WSGI协议的web服务器

server.py使用支持WSGI协议的wsgiref服务器，并关联了用户程序application，代码如下：

```python
#server.py
from wsgiref.simple_server import make_server #从wsgiref模块导入
from hello import application                 #导入我们自己编写的application函数

httpd = make_server('', 8000, application)    #创建一个服务器，IP地址为空，端口是8000，处理函数是application
print('Serving HTTP on port 8000...')
httpd.serve_forever()                         #开始监听HTTP请求
```

（2）编写用于生成动态网页的用户程序

```python
#hello.py
def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b'<h1>Hello, web!</h1>']
```
其中environ用来接收web服务传递过来的HTTP请求协议头内容。start_response构造HTTP返回头。return返回的是html的body。如上就简单的实现了一个遵循WSGI规范的web服务器和用户程序，它们都严格遵循WSGI协议。

（3）测试

在浏览器中输入`http://localhost:8080/`即可访问测试了。

备注：在Python中，为了让程序员更关注业务处理逻辑，可以使用web框架，让解析http请求头中的路由信息交由框架来完成，Python的web框架有上百个，比如web2py，Bottle等等，同时html也有模板，比如jinja2等等。

## uwsgi

uwsgi与WSGI类似，也是一种通信协议，它是uWSGI服务器自有的协议，它用于定义传输信息的类型（type of information），每一个uwsgi packet前4byte为传输信息类型描述。与WSGI协议是两种东西，据说该协议是fcgi协议的10倍快。

## uWSGI

uWSGI是一个Web服务器，它实现了WSGI协议、uwsgi、http等协议。

# Nginx对uwsgi协议的支持

Nginx中ngx_http_uwsgi_module模块就是对uwsgi协议的支持。通过该模块，我们可以部署分布式的服务。

![](/images/uwsgi_1_1.png)

# 使用uWSGI服务器部署Python WSGI应用

架构图如下：

![](/images/uwsgi_1_2.png)

其中APP是支持WSGI协议的APP，例如django应用。

学习资料参考于：
http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001432012393132788f71e0edad4676a3f76ac7776f3a16000
http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001432012745805707cb9f00a484d968c72dbb7cfc90b91000
