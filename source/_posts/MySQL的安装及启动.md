---
title: MySQL的安装及启动
date: 2018-02-02 14:06:37
tags: MySQL
categories: 数据库
---

# 源码安装

安装环境前提声明：

	系统发行版本：Red Hat Enterprise Linux Server release 5.4
	内核版本：2.6.18
	数据库版本：mysql-5.6.35
	cmake版本：cmake-2.8.8

完整的安装步骤如下：

（1）下载RPM格式的源码包

下载地址为：[MySQL-5.6](https://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-5.6.35-1.rhel5.src.rpm)

（2）解压源码包

使用`rpm -ivh MySQL-5.6.35-1.rhel5.src.rpm`解压，解压后的源码tar.gz文件在/usr/src/redhat/SOURCES/目录中。然后将tar.gz文件copy出来，解压到某个用户目录就行了。

（3）安装cmake工具

到`http://www.cmake.org`官网上下载cmake工具，然后使用`./configure && make && make install`安装到系统中

（4）生成MySQL的makefile文件

执行如下cmake命令：

```bash
cmake -DCMAKE_INSTALL_PREFIX=/home/jianzai/mysql \
 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
 -DDEFAULT_CHARSET=utf8 \
 -DDEFAULT_COLLATION=utf8_general_ci \
 -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
 -DWITH_MYISAM_STORAGE_ENGINE=1 \
 -DWITH_INNOBASE_STORAGE_ENGINE=1 \
 -DWITH_READLINE=1 \
 -DENABLED_LOCAL_INFILE=1 \
 -DMYSQL_DATADIR=/home/jianzai/mysql/data
```

其中DCMAKE_INSTALL_PREFIX参数指定mysql的安装位置。

（5）编译链接安装

```bash
make && make install
```

（6）使用mysql_install_db脚本初始化数据库
执行`cd /home/jianzai/mysql && ./scripts/mysql_install_db`命令即可。需要说明mysql_install_db做了如下初始化工作：

a）用来初始化MySQL的数据目录（data directory）和创建系统表（当data directory和系统表不存在的时候）

b）用来初始化innodb引擎管理使用的系统表空间（system tablespace）和数据结构（data structure）

c）在目录中生成Mysql的配置文件my.cnf

备注：关于mysql_install_db脚本的说明参见http://blog.chinaunix.net/uid-23284114-id-5520029.html
mysql_install_db后面也可以带上`--user=mysql`参数，用来表示使用linux系统中mysql账户来启动mysqld服务进程。

（7）启动mysql

a）直接启动方式

```bash
./libexec/mysqld --defaults-file=etc/my.cnf --user=mysql &
```

2）安全启动方式

```bash
./bin/mysqld_safe --defaults-file=etc/my.cnf --user=mysql &
```

备注：这里面的user指的是操作系统的账户，表示使用账户名mysql启动mysql daemon进程。不是mysql账户哦。

（8）使用MySQL客户端登录验证

值得注意的是，刚安装的MySQL数据库的超级账号root是没有密码的，因此可以直接使用`./bin/mysql -h127.0.0.1 -uroot`来登录。如果需要从远程主机上登录，则需要授权后才可以。

# YUM安装

（1）安装

直接执行命令`yum install mysql-server`或`apt-get install mysql-server`即可。

（2）启动

直接执行命令`/etc/init.d/mysqld start`或`service mysqld start`即可。

备注：`yum install mysql-server`不仅会安装mysql服务器，而且会安装mysql客户端等工具。若只想安装mysql客户端而已，可以执行`yum install mysql`命令即可。另外，在centos7之后，在yum源里面就没有mysql的资源了，可以使用mariadb来代替，即执行`yum install mariadb-server mariadb`即可。若确实需要在centos7之后版本上安装MySQL，可以改变系统的YUM源（包含了MySQL的）就可以啦。
