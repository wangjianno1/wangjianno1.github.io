---
title: Django系列（2）_url路由配置
date: 2018-01-28 21:53:41
tags: Python WEB开发
categories: Django
---

# Django的url路由过程

Django的url路由过程如下：

（1）django通过settings.py中ROOT_URLCONF参数来确定url根路由文件。一般都是project_name/project_name/urls.py。

（2）django在根路由文件中，读取urlpatterns变量（urlpatterns变量是包含了django.conf.urls.url()实例的list，每一个url实例是url和回调函数的映射）。

（3）django按照urlpatterns列表中元素的先后顺序进行匹配，直到第一个匹配的django.conf.urls.url()实例。

（4）匹配后，分两种情况，如果url()实例的回调部分是一个普通的view函数，则直接执行该函数即可。如果url()实例的回调部分是一个include定义的外部urlconf规则，那么会将url路由交给外部的urlconf继续路由处理。

备注：若没有匹配到任何路由，则会返回错误信息给用户。

# url路由配置举例

（1）基本的url路由

```python
urlpatterns = [
    url(r'^index/$', views.getallhost, name='main-view'),
]
```

（2）加载外部的url路由

```python
urlpatterns = [
    url(r'^api/hostname/', include('testapp.urls')),
]
```

备注：在上述例子中，需要在testapp这个app中定义一个urls.py文件，然后在urls.py文件中定义urlpatterns变量。另外包含了include外部路由的url()对象，正则表达式部分一定要是斜杠(/)结尾哦。django会将http请求的url截断掉匹配的部分（上述例子中就会截断掉api/hostname/），然后将剩余的部分交给testapp.urls这个外部路由规则继续处理。举例来说，用户访问的url为`http://ip:port/api/hostname/update`，那么会截断掉api/hostname/部分，剩下的update交给testapp.urls来处理。

学习内容参考于：
https://docs.djangoproject.com/en/1.11/topics/http/urls/
