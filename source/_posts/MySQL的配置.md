---
title: MySQL的配置
date: 2018-02-02 14:23:38
tags: MySQL
categories: 数据库
---

# MySQL的配置文件my.cnf

mysql的配置文件有：

	/etc/my.cnf

或

	~/.my.cnf

或

	{mysql安装目录}/etc/my.cnf

在.cnf配置文件中，分为几个配置组，例如[client]， [mysqld]，[mysqld_safe]等等，分别的作用如下：

	[client]是客户端去加载的。 
	[mysqld]是mysqld服务器程序加载的
	[mysqld_safe]是mysqld_safe是启动脚本加载的
	......


