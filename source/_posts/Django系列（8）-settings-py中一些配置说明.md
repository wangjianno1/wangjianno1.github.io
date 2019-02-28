---
title: Django系列（8）_settings.py中一些配置说明
date: 2018-01-28 22:58:18
tags: Python WEB开发
categories: Django
---

# ALLOWED_HOSTS

ALLOWED_HOSTS是为了限定HTTP请求中的Host Header值，以防止黑客构造包来发送请求。只有HTTP请求的Host Header包含在ALLOWED_HOSTS列表中才被允许访问。强烈建议不要使用（`*`）通配符去配置。配置范例如下：

```python
ALLOWED_HOSTS = [
    '.example.com',
    '10.16.20.86',
]
```

# DEBUG

DEBUG配置为True时，会暴露出一些出错信息或配置信息以方便调试。但是在上线的时候应该将其关掉，防止配置信息或者敏感出错信息泄露。

# INSTALLED_APPS

一般在项目中我们会通过`python manage.py startapp appname`创建用户自定义的APP。如果创建了，则需要将其加入到INSTALLED_APPS 数组中才可以被访问到。INSTALLED_APPS中有默认的APP，用户可以将自己创建的APP，也配置到其中，举例如下：

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # config your app here
    'myappname1',
    'myappname2',
]
```
