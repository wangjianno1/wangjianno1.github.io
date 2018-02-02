---
title: MySQL变量学习小结
date: 2018-02-02 14:30:15
tags: MySQL
categories: 数据库
---

# MySQL变量简介

变量实际上用于控制数据库的一些行为和方式的参数。比如我们启动数据库的时候设定多大的内存，使用什么样的隔离级别，日志文件的大小，存放位置等等一系列的东东。当然我们数据库系统启动后，有些变量(参数)也可以通过动态修改来及时调整数据库。这个变量在Oracle里边是通过pfile或者spfile来控制，称之为参数，是一个意思。关于变量几个要点如下：

（1）变量取值

有些变量具有默认值，可以在启动时及启动后修改。

（2）设置范围

全局与回话级别，全局级别需要super权限，会话级别只影响自身会话。

（3）设置方法

启动前可以通过配置文件以及启动选项来修改，启动后通过SET子句来设置。

# MySQL变量的类型

（1）用户变量

以"@"开始，形式为"@变量名"。用户变量跟mysql客户端是绑定的，设置的变量，只对当前用户使用的客户端生效。

（2）全局变量

定义时，以如下两种形式出现，`set GLOBAL 变量名`或者`set @@global.变量名`，对所有客户端生效。只有具有super权限才可以设置全局变量。

（3）会话变量

只对连接的客户端有效。

（4）局部变量

作用范围在begin到end语句块之间。在该语句块里设置的变量。declare语句专门用于定义局部变量。set语句是设置不同类型的变量，包括会话变量和全局变量。

# MySQL变量的查看和配置

（1）查看一个全局变量的值

```bash
select @@global.sort_buffer_size;
show global variables like 'sort_buffer_size';
```

（2）查看一个session变量的值

```bash
select @@sort_buffer_size;
select @@session.sort_buffer_size;
show session variables like 'sort_buffer_size';
show variables like 'sort_buffer_size';    #show variables缺省显示的是session变量
```

（3）设置一个全局变量的值

```bash
set global sort_buffer_size=value;
set @@global.sort_buffer_size=value;
```

（4）设置一个session变量的值

```bash
set session sort_buffer_size=value;
set @@session.sort_buffer_size=value;
set sort_buffer_size=value;
```

# MySQL变量操作命令举例

```bash
show variables like '%isolation%';
show session variables like '%isolation%';
show global variables like '%isolation%';
```


学习资料参考于：
http://blog.csdn.net/leshami/article/details/39585253