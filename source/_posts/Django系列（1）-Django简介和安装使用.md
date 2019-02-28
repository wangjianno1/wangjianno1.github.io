---
title: Django系列（1）_Django简介和安装使用
date: 2018-01-28 18:33:15
tags: Python WEB开发
categories: Django
---

# Django简介

Python下有许多款不同的Web框架。Django是重量级选手中最有代表性的一位。许多网站和APP都基于Django。 Django是一个开放源代码的Web应用框架，由Python写成。Django遵守BSD版权，初次发布于2005年7月, 并于2008年9月发布了第一个正式版本1.0。Django的优势如下：

（1）快速web开发

Python web框架。

（2）大量内置应用

例如后台管理系统admin、用户认证系统auth、会话系统sessions等等。

（3）安全性高

提供表单验证、SQL注入、跨站点访问等支持。

（4）易于扩展

引入APP的概念，以APP来扩展WEB项目。

# Django内部工作流程

![django工作流程图](/images/django_1_4.png)

    1.用户通过浏览器请求一个页面的url
    2.请求到达Request Middlewares（中间件），中间件对request做一些预处理或者直接response请求
    3.URLConf通过urls.py文件和请求的URL找到相应的View（视图）
    4.View Middlewares被访问，它同样可以对request做一些处理或者直接返回response
    5.调用View中的函数
    6.View中的方法可以选择性的通过Models访问底层的数据
    7.所有的Model-to-DB的交互都是通过manager完成的
    8.如果需要，Views可以使用一个特殊的Context（上下文处理器）
    9.Context被传给Template（存放前段文件）用来生成页面
        a.Template使用Filters和Tags去渲染输出
        b.输出被返回到View
        c.HTTPResponse被发送到Response Middlewares
        d.任何Response Middlewares都可以丰富response或者返回一个完全不同的response
        e.Response返回到浏览器，呈现给用户


# Django的安装

Django的安装有pip和源码安装两种方式（本次使用的是Django 1.11.2，Python环境是2.7.13），如下：

（1）pip

直接执行如下命令即可：

```bash
pip install Django==1.11.2
```

（2）源码安装

下载pytz 2017.2 版本；下载Django 1.11.2版本。分别解压，然后通过`python setup.py install`先安装pytz，再安装Django即可。二者被安装到lib/python2.7/site-packages目录中。

备注：使用`python -m django --version`命令查看是否安装成功

# 创建Django web project

安装完django之后，就拥有django-admin工具命令了，该工具可以用来创建项目、创建APP等等。可以执行执行`django-admin help`查看其支持的子命令。

（1）创建Django web项目

执行命令`django-admin startproject testproject`命令，创建一个名称为testproject的WEB项目。在当前目录自动生成如下目录结构：

![django工程目录结构](/images/django_1_1.png)

其中各个文件的作用简单说明如下：

	manage.py   #与项目进行交互的命令工具集，例如启动服务器、数据库操作、Django Shell等等。可以执行python manage.py来查看其支持的子命令。例如python manage.py runserver
	wsgi.py     #Python应用和WEB服务器的通信协议
	urls.py     #url路由
	settings.py #项目的总配置文件，里面包括了数据库、web应用、时间等各种配置，非常重要
	__init__.py #包的__init__.py，说明我们的项目目录是一个python package，可以被import导入

（2）启动web server

执行如下命令即可启动web server：

	cd testproject && python manage.py runserver             #监听127.0.0.1:8000
	cd testproject && python manage.py runserver 8080        #指定监听端口
	cd testproject && python manage.py runserver realip:8080 #监听realip:8080

（3）测试

在浏览器中输入`http://ip:port`即可访问。效果如下：

![django helloworld页面](/images/django_1_2.png)

# 在web project中创建app

创建app的过程大致为：

首先执行命令`python manage.py startapp testapp`创建一个名称为testapp的应用，然后添加应用名到setting中的INSTALLED_APPS里面，最后是编写app的具体的业务逻辑以及配置url路由等。

备注：Django官网演示的demo是将app目录和manage.py，以及project目录是同级，其实app的目录可以放到任何位置，所有怎么组织一个基于Django项目的目录结构是很灵活的。

自动生成如下的APP目录结构如下：

![django web app目录结构](/images/django_1_3.png)

其中各个文件的作用简单说明如下：

	views.py  #view.py中定义了很多函数，这些函数是url路由请求的响应函数。每个函数最终返回的是html文件
	model.py  #定义数据库表，用来做ORM映射的
	admin.py  #用来给Djanjo内置的admin app来使用，用来做该APP的admin后台相关的操作
	tests.py  #用来做测试使用的

# Django中project和app的区别

Django有project和app两个概念。project的范畴是整个项目工程，包含一些全局配置，这些配置构成一个全局的运行平台。app代表的是project一个相对独立的功能模块，业务逻辑都在各个app中。
