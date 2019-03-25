---
title: Django系列（10）_中间件Middleware技术
date: 2019-03-25 16:08:03
tags:
categories: Django
---

# django中间件简介

django中间件是django的请求/响应处理过程中的钩子框架，它是一个用于全局修改Django输入或输出的轻量、低级的“插件”系统。每个中间件组件负责一些特定的功能。例如，django包含一个中间件组件， AuthenticationMiddleware，它使用会话关联请求和用户。

django中间件是一个普通的类或者函数，需要注意的是，在django1.10之前和之后中间件的定义有些异同，不过从原理层面来说还是相通的。一般说来，每个中间件中包括了如下几个函数：

（1）process_request(self, request)

该方法在HTTP请求到达django框架时被调用

（2）process_view(self, request, fnc, arg, kwarg)

该方法在views.py中的函数被调用之前被调用

（3）process_response(self, request, response)

该方法在执行完view函数，准备将响应结果发到客户端之前被执行

（4）process_exception(self, request, exception)

view函数在抛出异常时该函数被调用，得到的exception参数是实际上抛出的异常实例，通过此方法可以进行很好的错误控制，提供友好的用户界面。

（5）process_template_response

# django中间件在整个请求处理过程的执行逻辑

假设项目settings.py中MIDDLEWARE字段配置如下：

```python
MIDDLEWARE = [
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
]
```

那么当请求进来先从上到下执行一遍各中间件的process_request方法，接下来再从上下执行一遍各中间件的process_view方法，接下来执行view函数。若view函数执行异常，则从下往上执行一遍各中间件的process_exception函数。若view函数执行无异常，则从下往上执行一遍各中间件的process_template_response方法，接下来再从下往上执行一遍各中间件的process_response方法。

![](/images/django_10_1.png)

因此，各中间件在settings.py中MIDDLEWARE数组中的位置会决定了各中间件中函数被执行的顺序。

另外，我们也可以自定义中间件。
