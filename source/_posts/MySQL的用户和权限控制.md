---
title: MySQL的用户和权限控制
date: 2018-02-02 15:20:51
tags: MySQL
categories: 数据库
---

# MySQL的用户管理和权限管理，都体现在如下的六张表中

	mysql.user
	mysql.db
	mysql.host
	mysql.tables_priv
	mysql.columns_priv
	mysql.procs_priv

# 各种权限表

（1）user表

user表是MySQL中最重要的一个权限表，记录允许连接到服务器的账号信息，里面的权限是全局级的。user表的信息有用户列、权限列、安全列和资源控制列。 这个表示中有Host、User、Password三个字段，

	Host表示远程主机，即MySQL客户端的ip，表示从该Host上用指定的User和Password才可以登录数据库
	User表示用户名
	Password表示用户密码

备注：在不同的Host上使用同一个User来登录数据库，对应的登录密码可以是不一样的。因此，可以认为Host+User唯一对应一个用户哦。

（2）db表

db表中存储了用户对某个数据库的操作权限，决定用户能从哪个主机存取哪个数据库。主要反映的是用户对Mysql中哪些db有操作权限。

（3）host表

host表中存储了某个主机对某个数据库有什么操作权限。

# 创建mysql新用户

前提声明，如下命令中，10.12.21.23代表的mysql客户端所在的机器，wahaha是用户名，guest123是用户密码。

新增mysql用户有如下几种方法：

（1）直接在mysql库中user表中添加记录来创建新用户并授权

```bash
insert into user(host, user, password, select_priv, insert_priv, update_priv) VALUES('10.12.21.23', 'wahaha', PASSWORD('guest123'), 'Y', 'Y', 'Y');
```

（2）使用grant命令创建新用户并授权

```bash
grant all privileges on *.* to 'wahaha'@'10.12.21.23' identified by 'password';
```

或如下授予部分权限：

```bash
grant select, insert, update, delete, create, drop on *.* to 'wahaha'@'10.12.21.23' identified by 'guest123';
```

（3）使用create user命令

```bash
create user wahaha identified by 'guest123';
```

备注：使用`create user`命令创建用户后，还需要对用户进行授权。

# 修改MySQL中用户名密码

mysql安装后，root账户的密码默认是空，即不需要密码就可以登录。我们可以通过如下几种方法来修改指定用户的登录密码（前提申明，如下命令中，10.12.21.23代表的mysql客户端所在的机器，wahaha是用户名，guest123是用户密码）：

（1）使用mysqladmin工具（不会用这个）

```bash
mysqladmin -u root password "guest123";
```

上述命令表示将root的密码修改成guest123.

（2）直接修改MySQL中系统db mysql中user表

```
# mysql -uroot -p
Enter password: 【输入原来的密码】
mysql> use mysql;
mysql> update user set password=PASSWORD("guest123") where user='wahaha';
mysql> flush privileges;
mysql> exit;
```

备注：其中PASSWORD()是mysql的一个内置函数，用来将明文密码转换成暗文。

（3）使用set命令（这个很赞哦）

```bash
set password for 'wahaha'@'10.12.21.23' = PASSWORD('guest123');
```

# mysql中常见问题处理

（1）客户端授权问题

如果远程主机上client连接MySQL提示“ #1130 - Host ‘localhost’ is not allowed to connect to this MySQL server”表示不允许从当前机器上连接mysql服务器，需要使用GRANT授权，命令如下：

```bash
grant all privileges on . to 'wahaha'@'%';  #该句中的%表示允许从所有主机上用wahaha用户去连接mysql服务器
grant all privileges on . to 'whaha'@'10.12.21.23'; #该句表示授权从10.12.21.23主机上使用wahaha用户去连接mysql服务器
```

备注：

A）使用grant语句后，记得使用`flush privileges`命令让其生效

B）当使用上面的语句授权时，发现nova账号的密码被重置了。是不是从不同机器上客户端用同一个账号连接Mysql服务器，使用的密码是不一样的。

C）部署phpMyAdmin时，需要为部署phpMyAdmin的服务器授权客户端来源权限。

备注：当修改完mysql的用户及授权信息后，一般需要执行`flush privileges`命令。执行后mysql会重新载入授权表，从而使最新的权限变更生效。
