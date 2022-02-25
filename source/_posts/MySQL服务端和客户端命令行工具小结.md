---
title: MySQL服务端和客户端命令行工具小结
date: 2019-03-15 12:01:27
tags:
categories: 数据库
---

# MySQL服务端命令行工具

![](/images/mysql_tools_1_1.png)

备注：mysqld工具可能不在bin目录下，可能在`${mysql安装目录}/mysql/libexec`下。

# MySQL客户端命令行工具

![](/images/mysql_tools_1_2.png)

# MySQL官方图形化管理工具MySQL Workbench

MySQL Workbenck也有两个版本：

    MySQL Workbench Community Edition，也就是社区版本
    MySQL Workbench Standard Edition，也就是商业版本，是按年收取费用的

# 其他MySQL附带工具

（1）mysql_config

MySQL在安装完后，一般在`${MYSQL_HOME}/bin`目录下有mysql_config工具，它不是一个二进制文件，是一个脚本工具。当我们在编译自己的mysql客户端时，可用通过mysql_config工具获取很多的有用的编译参数，例如使用`mysql_config --include`可以获取mysql的mysql在安装时的一些头文件位置，或者`mysql_config --libs`可以获取mysql的头文件及共享库等编译参数。例如：

```bash
mysql_config --include   #得到-I/usr/include/mysql
mysql_config --libs      #得到-L/usr/lib/mysql-lmysqlclient -lz -lcrypt -lnsl -lm -L/usr/lib -lssl -lcrypto
```
