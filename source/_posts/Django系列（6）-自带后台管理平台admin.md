---
title: Django系列（6）_自带后台管理平台admin
date: 2018-01-28 22:47:19
tags: Python WEB开发
categories: Django
---

# django后台管理模块admin简介

admin是Django自带的一个功能强大的自动化后台数据管理界面。被授权的用户可直接在Admin中管理数据库。admin是Django自带的一个app，名称为django.contrib.admin。

# 后台模块admin的使用

（1）创建后台用户

执行命令python manage.py createsuperuser创建后台管理用户，输入账号、密码和邮箱等信息。

（2）在app_name/admins.py中引入需要admin管理的对象

```python
from django.contrib import admin
from .models import Record
admin.site.register(Record)
```

备注：该例子中引入的是Record模型。

（3）启动django应用并测试

打开http://ip:port/admin即可打开后台系统登录界面，输入第（1）步中创建的用户名和密码，即可登录到管理页面，效果图如下：

![django管理页面图](/images/django_6_1.png)

备注：admin web管理页面默认是英文的，我们可以通过在setting.py中修改变量LANGUAGE_CODE= 'zh_Hans'即可展示中文的管理页面了。



学习资料参考于：
https://docs.djangoproject.com/en/1.11/intro/tutorial02/
