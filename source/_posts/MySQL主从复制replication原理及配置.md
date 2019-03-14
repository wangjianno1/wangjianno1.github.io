---
title: MySQL主从复制replication原理及配置
date: 2018-02-02 15:26:51
tags: MySQL
categories: 数据库
---

# mysql二进制日志binlog简介

mysql二进制日志binlog可以说是MySQL最重要的日志了，它记录了所有的DDL和DML（除了数据查询语句）语句，还包含语句所执行的消耗的时间，MySQL的二进制日志是事务安全型的。一般来说开启二进制日志大概会有1%的性能损耗（参见MySQL官方中文手册5.1.24版）。

二进制有两个最重要的使用场景：

（1）mysql基于binlog的主从复制。

（2）数据恢复，通过使用mysqlbinlog工具来使恢复数据。

二进制日志binlog包括两类文件：

（1）二进制日志索引文件

文件名后缀为`.index`，用于记录所有的二进制文件。缺省路径为`/var/lib/mysql/mysql-bin.index`。

（2）二进制日志文件

文件名后缀为`.00000*`，记录数据库所有的DDL和DML（除了数据查询语句）语句事件。缺省路径为`/var/lib/mysql/mysql-bin.000001`。

# mysql binlog日志格式

mysql中binlog是二进制日志，它有三种格式，

	STATEMENT格式，该格式是基于sql语句，就是将有变更的sql语句写入到binlog日志中
	ROW格式，该格式是基于行的，也就是将数据记录修改后的内容直接记录到binlog中
	MIXED格式，该格式是STATEMENT和ROW的混合使用

MySQL默认使用基于语句的复制，当基于语句的复制会引发问题的时候就会使用基于行的复制，MySQL会自动进行选择。

备注：若一个工资表中有一万个用户，我们把每个用户的工资+1000，那么基于ROW的binlog日志则要记录一万行的内容，由此造成的开销比较大，且日志量也很大。而基于STATEMENT格式的binlog日志仅仅一条语句就可以了，因此往往基于STATEMENT格式的binlog日志量会比较小。

另外，可以使用mysqlbinlog工具查看binlog文件的内容，也可以使用编程语言按照binlog的格式去解析binlog数据。

# mysql主从复制的实现方式

目前来说，mysql主从复制有两种实现方式：

（1）基于binlog的复制

针对这三种binlog日志格式，在主从复制或备份还原时，就有三种的复制方式，

	基于SQL语句的复制(statement-based replication, SBR)
	基于行的复制(row-based replication, RBR)
	混合模式复制(mixed-based replication, MBR)

（2）基于事务（GTID）的复制（mysql5.6及以后版本才支持）

备注：本节如下内容都是基于binlog的复制方式来展开的。基于事务（GTID）的复制的方式以后再研究哦。

# 基于binlog的主从复制的原理

主从同步的原理如下：

![](/images/mysqlrep_1_1.png)

同步的过程为：

（1）主库中的每一个事务在操作数据后，主库会将该操作dump出来，写入到二进制文件binlog中，binlog其实就是一系列的数据库操作内容。

（2）从库的IO线程连接上主库，并请求从指定日志文件的指定位置（或者从最开始的日志）之后的日志内容。

（3）主库接收到来自从库的IO线程的请求后，负责复制的IO线程会根据请求信息读取日志指定位置之后的日志信息，返回给从库的IO线程。返回信息中除了日志所包含的信息之外，还包括本次返回的信息已经到主库端的binlog文件的名称以及binlog的位置。

（4）从库的IO线程接收到信息后，将接收到的日志内容依次添加到从库的relay-log文件的最末端，并将读取到的主库的binlog的文件名和位置记录到master-info文件中，以便在下一次读取的时候能够清楚的告诉主库“我需要从某个binlog的哪个位置开始往后的日志内容，请发给我”。

（5）从库的SQL线程检测到relay-log中新增加了内容后，会马上解析relay-log的内容，并将其在从库中回放执行。

# 基于binlog的mysql主从复制的配置

（1）在master节点开启binlog日志，并配置server-id

在mysql主库的配置文件my.cnf添加如下内容：

	[mysqld]
	server-id = 1    //全局唯一server-id用来标示mysql主库在主从集群中的位置
	log_bin = /var/log/mysql/mysql-bin.log     //开启BinaryLog，binlog为/var/log/mysql/mysql-bin.log

（2）在master端建立复制用户（该用户是slave用来读取master的binlog日志所使用的账户），命令范例如下：

```sql
create user 'dba'@'192.168.3.%' identified by '123456';
grant replication slave on *.* to 'dba'@'192.168.3.%';
```

（3）给slave节点配置server-id

在mysql从库的配置文件my.cnf添加如下内容：

	[mysqld]
	server-id = 2    //全局唯一server-id用来标示mysql从库在主从集群中的位置

备注：从库一般不需要开启记录binlog日志，但是当有其他mysql数据库以该库作为主库来实现主从同步时，那么该库也就需要打开binlog日志。

（4）配置slave，连接到master

在master和slave都配置好后，只需要把slave指向master即可。需要在从库上执行`change master to`命令，如下：

```sql
change master to master_host='10.1.6.159', master_port=3306, master_user='dba', master_password='123456';
```

备注：master_host指定的是master库所在的机器ip，master_user和master_password是第（2）步中在master端建立的复制用户和密码。

另外，在执行`change master to`命令时，可以通过配置master_log_file和master_log_pos两个参数，使slave节点从master节点的指定位置开始同步，命令类似如下：

```sql
change master to master_host='192.168.3.100', master_port=3306, master_user='dba', master_password='123456', master_log_file='mysql-bin.000004', master_log_pos=1687;
```

对于mysql 5.7+及MariaDB来说，支持“多源复制”架构，使用`change master to`命令时，需要明确当前slave的名称，执行命令范例如下：

```sql
change master 'xx_db' to master_host='10.27.102.202', master_user='dba', master_password='123456', master_log_file='mysql.000006', master_log_pos=238976927;    --其中xx_db是“多源复制”中某一个slave IO线程
```

（5）启动slave，也即启动从库的IO线程和SQL线程。

```sql
start slave;
```

（6）校验复制状态

在Slave节点上执行`show slave status`命令查看复制状态。一般情况下，当Slave_IO_Running和Salve_SQL_Running都为YES时，我们才认为主从复制的状态是正常的。

# 基于binlog的mysql主从复制的部分复制配置

mysql的主从之间的复制可以对整个数据库实例进行复制，也可以对数据库实例中的某个库或某个表进行复制。部分复制可以通过如下选项参数来控制：

master端的控制参数有`--binlog-do-db/--binlog-ignore-db`

slave端的控制参数有`--replicate-do-db/--replicate-ignore-db/--replicate-do-table/--replicate-ignore-table/--replicate-wild-do-table/--replicate-wild-ignore-table`

# mysql多源复制

多源复制也就是多mater复制，允许一个slave对应多个master。在mysql5.7以前，主从复制集群都是“一主多从”的结构，即一个slave只有一个master，一个master可以有多个slave。而在mysql5.7及以后的版本中，支持一个slave对应多个master的结构。如下为多源复制的应用场景之一：

当我们需要将跨数据库实例来查询数据时，往往在效率和用户程序实现上比较难，但有了多源复制之后，我们可以将多个mysql数据库中数据同步复制到同一个Slave中，这样通过对Salve数据库实例操作，来达到跨数据库实例操作的目的。

# 目前基于主从复制机制中binlog的实时获取和解析来实现数据库“变更抓取”系统的开源项目有：

（1）LinkedIn的DataBus项目

（2）Alibaba的canal项目

（3）Baidu的Fountain DAS项目（未开源）

# mysql主从复制的闲杂知识

（1）在MySQL主从复制架构中，读操作可以在所有的服务器上面进行，而写操作只能在主服务器上面进行。主从复制架构虽然给读操作提供了扩展，可如果写操作也比较多的话（多台从服务器还要从主服务器上面同步数据），单主模型的复制中主服务器势必会成为性能瓶颈。

（2）多线程复制，是指将slave端的复制线程配置成多线程的，这样可以提高主从同步复制数据的效率。

学习资料参考：
http://www.cnblogs.com/fxjwind/archive/2013/03/05/2944864.html
http://highscalability.com/blog/2012/3/19/linkedin-creating-a-low-latency-change-data-capture-system-w.html
http://www.csdn.net/article/1970-01-01/2814280
http://blog.csdn.net/mycwq/article/details/17136001
http://pangge.blog.51cto.com/6013757/1299028
