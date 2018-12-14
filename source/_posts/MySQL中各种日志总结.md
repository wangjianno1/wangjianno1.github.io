---
title: MySQL中各种日志总结
date: 2018-12-14 14:25:30
tags: MySQL
categories: 数据库
---

# MySQL中的日志种类

MySQL中有六种日志文件，分别是错误日志（error log）、查询日志（general & slow query log）、重做日志（redo log）、回滚日志（undo log）、二进制日志（binary log）以及中继日志（relay log）。

其中重做日志和回滚日志与事务操作息息相关，二进制日志也与事务操作有一定的关系，这三种日志，对理解MySQL中的事务操作有着重要的意义。

# 错误日志（error log）

记录MySQL服务进程在启动/关闭或者运行过程中遇到的错误消息，是数据库管理工作中排查错误的重要工具。执行如下命令可以查看错误日志的位置：

```sql
show variables like 'log_error';
```

![](/images/mysql_log_1_1.png)

# 查询日志（query log）

查询日志包括普通查询日志（general query log）和慢查询日志（slow query log）。其中普通查询日志记录客户端连接和执行的SQL语句信息，慢查询日志记录执行时间超出指定值和没有利用索引（log_queries_not_using_indexes）的SQL语句。

普通查询日志，一般不开启，比较占空间。执行如下命令可以查看普通查询日志的开启状态和日志文件位置：

```sql
show variables like 'general_log%';
```

![](/images/mysql_log_1_2.png)

执行如下命令可以查看慢查询日志的开启状态和日志文件位置：

```sql
show variables like 'slow_%log%';
```

![](/images/mysql_log_1_3.png)

# 重做日志（redo log）

（1）重做日志简介

确保事务的持久性。防止在发生故障的时间点，尚有脏页未写入磁盘，在重启mysql服务的时候，根据redo log进行重做，从而达到事务的持久性这一特性。事务开始之后就产生redo log，redo log的落盘并不是随着事务的提交才写入的，而是在事务的执行过程中，便开始写入redo log文件中。当对应事务的脏页写入到磁盘之后，redo log的使命也就完成了，重做日志占用的空间就可以重用（被覆盖）。

（2）重做日志相关配置

默认情况下，对应的物理文件位于数据库的data目录下的ib_logfile0和ib_logfile1。innodb_log_group_home_dir指定日志文件组所在的路径，默认`./`，表示在数据库的数据目录下。innodb_log_files_in_group指定重做日志文件组中文件的数量，默认是2。innodb_log_file_size指定重做日志文件的大小。innodb_mirrored_log_groups指定了日志镜像文件组的数量，默认是1。

# 回滚日志（undo log）

（1）回滚日志简介

保存了事务发生之前的数据的一个版本，可以用于回滚，同时可以提供多版本并发控制下的读（MVCC），也即非锁定读。当事务提交之后，undo log并不能立马被删除，而是放入待清理的链表，由purge线程判断是否由其他事务在使用undo段中表的上一个事务之前的版本信息，决定是否可以清理undo log的日志空间。

（2）回滚日志相关配置

MySQL 5.6之前，undo表空间位于共享表空间的回滚段中，共享表空间的默认的名称是ibdata，位于数据文件目录中。MySQL 5.6之后，undo表空间可以配置成独立的文件，但是提前需要在配置文件中配置，完成数据库初始化后生效且不可改变undo log文件的个数。如果初始化数据库之前没有进行相关配置，那么就无法配置成独立的表空间了。

# 二进制日志（binary log）

用于主从复制。在主从复制中，从库利用主库上的binlog进行重播，实现主从同步。用于数据库的基于时间点的还原。具体参见《MySQL主从复制replication原理及配置》。执行命令`show variables like 'log_bin';`可以查看二进制日志是否开启：

![](/images/mysql_log_1_4.png)

# 中继日志（relay log）

在主从复制的架构中，从库的IO线程接收到主库的binlog日志后，将接收到的日志内容依次添加到从库的relay-log文件的最末端，然后从库的SQL线程检测到relay-log中新增加了内容后，会马上解析relay-log的内容，并将其在从库中回放执行。


学习资料参考于：
http://www.cnblogs.com/liulei-LL/p/7648006.html
https://mp.weixin.qq.com/s/yGytaV7owibajI04Z7rHNw
