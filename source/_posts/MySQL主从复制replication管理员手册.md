---
title: MySQL主从复制replication管理员手册
date: 2018-02-02 15:46:49
tags: MySQL
categories: 数据库
---

# 查看master库的binlog是否开启

```sql
show variables like 'log_%';
```

# 查看master的所有binlog文件的名称和大小

```sql
show master logs; 
show binary logs;   --同show master logs一样的效果
```

![](/images/mysqlrep_2_1.png)

# 查看master状态，即最后(最新)一个binlog日志文件的文件名称，及其最后一个操作事件的End Position值

在主库上执行如下命令：

```sql
show master status;
```

![](/images/mysqlrep_2_2.png)

# 查看主库master的所有从库

在主库master上执行如下命令，可以查看master的所有从库：

```sql
select * from information_schema.processlist as p where p.command = 'Binlog Dump';
```

或者

```sql
show slave hosts;
```

# 刷新binlog日志，自此刻开始产生一个新编号的binlog日志文件

```sql
flush logs;
```

# 重置（清空）所有binlog日志

```sql
reset master;
```

# 查看当前有哪些线程在运行，排查有问题的操作动作

```sql
show processlist;
show full processlist;   --加上full选项后，可以在Info字段查看完成的sql语句，否则只显示前100个字符
```

![](/images/mysqlrep_2_3.png)

如下为各列的含义和用途：

	id       #一个标识，并非操作系统中的线程ID哦，你要kill一个语句的时候很有用
	user     #显示单前用户，如果不是root，这个命令就只显示你权限范围内的sql语句
	host     #显示这个语句是从哪个ip的哪个端口上发出的
	db       #显示这个进程目前连接的是哪个数据库
	command  #显示当前连接的执行的命令，一般就是休眠（sleep），查询（query），连接 （connect）
	time     #此这个状态持续的时间，单位是秒
	state    #显示使用当前连接的sql语句的状态
	info     #显示这个sql语句，因为长度有限，所以长的sql语句就显示不全，但是一个判断问题语句的重要依据

备注：我们可以执行命令`mysqladmin processlist`或直接查询`information_schema.processlist`表来查看同样的内容。

# 使用show binlog events命令来读取并解析binlog日志

```sql
show binlog events\G;    --查询并解析第一个(最早)的binlog日志内容
show binlog events in 'mysql-bin.000021'\G;    --指定查询mysql-bin.000021这个binlog文件的内容
show binlog events in 'mysql-bin.000021' from 8224\G; --指定查询mysql-bin.000021这个binlog文件，从8224这个pos点开始查看
show binlog events in 'mysql-bin.000021' from 8224 limit 10\G;   --指定查询mysql-bin.000021这个binlog文件，从8224这个pos点开始查起，查询10条
show binlog events in 'mysql-bin.000021' from 8224 limit 2,10\G;    --指定查询mysql-bin.000021这个binlog文件，从8224这个pos点开始查起，偏移2行，查询10条
```

举例来说，

![](/images/mysqlrep_2_4.png)

Pos:204,End_log_pos:365表示，该event是记录在mysql-bin.000001文件的第204字节和第365字节之间。

# 使用mysqlbinlog /path/to/mysql-binlog-file工具来读取并解析binlog日志

```bash
mysqlbinlog /var/lib/mysql/mysql-bin.000001
```

# 通过show slave status命令查看从库的同步状态

在slave节点上执行如下命令，

```sql
show slave status\G;
```

![](/images/mysqlrep_2_5.png)

如下为各字段的含义：

	Slave_IO_State         #Slave IO线程的执行状态
	Master_User            #被用于连接主服务器的当前用户
	Master_Port            #当前的主服务器接口
	Connect_Retry          #--master-connect-retry选项的当前值
	Master_Log_File        #Slave I/O线程当前正在读取的主服务器二进制日志文件的名称
	Read_Master_Log_Pos    #在当前的主服务器二进制日志中，Slave I/O线程已经读取的位置
	Relay_Log_File         #Slave SQL线程当前正在读取和执行的中继日志relaylog文件的名称
	Relay_Log_Pos          #在当前的中继日志relaylog中，Slave SQL线程已读取和执行的位置
	Relay_Master_Log_File  #由SQL线程执行的包含多数近期事件的主服务器二进制日志文件的名称
	Slave_IO_Running       #Slave I/O线程是否被启动并成功地连接到主服务器上（状态信息为Yes/No）
	Slave_SQL_Running      #Slave SQL线程是否被启动（状态信息为Yes/No）
	Replicate_Do_DB        #使用--replicate-do-db选项指定的需要同步的数据库名称
	Replicate_Ignore_DB    #使用--replicate-ignore-db选项指定不需要同步的数据库名称
	Replicate_Do_Table,Replicate_Ignore_Table,Replicate_Wild_Do_Table,Replicate_Wild_Ignore_Table  #使用--replicate-do-table,--replicate-ignore-table,--replicate-wild-do-table和--replicate-wild-ignore_table选项指定的需要同步或不需要同步的数据库表名称
	Last_Errno,Last_Error  #被多数最近被执行的查询返回的错误数量和错误消息。错误数量为0并且消息为空字符串意味着“没有错误”。如果Last_Error值不是空值，它也会在从属服务器的错误日志中作为消息显示
	Relay_Log_Space        #所有原有的中继日志结合起来的总大小
	Seconds_Behind_Master  #本字段是Slave数据库实例“落后”Master数据库多少的一个指示（即延迟，单位为秒）

备注：在日常MySQL数据运维中，我们需要判断主从复制的状态是否正常。通常来说，只需要Slave_IO_Running参数和Slave_SQL_Running参数都为Yes的情况下，并且Seconds_Behind_Master延迟小于一定数值的时候，我们就可以认定mysql主从是同步的。

另外，对于MySQL 5.7+及MariaDB来说，它们支持“多源复制”，也即是“多主库对应一个从库”的复制结构，那么对于slave库来说，同时会从多个主库上复制数据，也即有多个Slave IO线程和SQL线程，那么直接执行`show slave status`会返回为空，此时可以执行如下命令来查看slave的同步状态：

```sql
show all slaves status \G;      --查看所有slave的复制状态，也是在Slave节点上执行
show slave 'xx_db' status \G;   --仅查看某一个slave的复制状态，也是在Slave节点上执行
```

# 关闭或启动slave IO线程或SQL线程

```sql
start slave;          --启动slave
stop slave;           --停止slave
start slave 'xx_db';  --对于mysql 5.7+及MariaDB来说，支持“多源复制”，可以启动指定Connection_name的slave
stop slave 'xx_db';   --对于mysql 5.7+及MariaDB来说，支持“多源复制”，可以停止指定Connection_name的slave
```

# 删除主从配置的设置

我们使用`change master to`命令来配置主从同步关系，假设我们不仅想停止主从同步，而且想删除这种主从同步的关系。可以使用如下的操作的方法：

```sql
stop slave;       --停掉slave的同步
reset slave all;  --删除主从同步的配置，然后执行show slave status将看不到这个同步任务
```

备注：如果使用`reset slave`仅仅会重置主从同步的状态，并没有删除主从同步的配置。而`reset slave all`则会删除主从同步配置。

对于在MySQL 5.7+及MariaDB来说，支持“多源复制”，我们想停掉某一个slave的方式如下：

```sql
stop slave 'xx_db';
reset slave all 'xx_db';   --如果是MariaDB，需要执行reset slave 'xx_db' all命令哦
```

# 其他闲杂知识

在MySQL 5.7+中增加了很多的表，用来对主从同步复制进行管理，即在`performance_schema`数据库中以`replication_`开头的一些数据库表。


学习资料参考于：
http://www.cnblogs.com/martinzhang/p/3454358.html
