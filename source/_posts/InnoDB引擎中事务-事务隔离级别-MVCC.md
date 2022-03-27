---
title: InnoDB引擎中事务|事务隔离级别|MVCC
date: 2019-04-11 00:05:53
tags:
categories: 数据库
---

# MySQL事务

MySQL事务主要用于处理操作量大，复杂度高的数据。比如说，在人员管理系统中，你删除一个人员，即需要删除人员的基本资料，也要删除和该人员相关的信息，如信箱，文章等等，这样，这些数据库操作语句就构成一个事务。

关于MySQL事务操作，需要注意如下几点：

（1）在MySQL中只有使用了InnoDB存储引擎的数据库或表才支持事务

（2）事务处理可以用来维护数据库的完整性，保证成批的SQL语句要么全部执行，要么全部不执行

（3）MySQL事务是必须满足4个条件（ACID），即原子性Atomicity、一致性Consistency、隔离性Isolation以及持久性Durability



# MySQL事务操作

MySQL事务操作主要有两种方法：

（1）用BEGIN/ROLLBACK/COMMIT等事务控制语句来实现显式控制事务（显式事务）

    BEGIN开始一个事务
    ROLLBACK事务回滚
    COMMIT事务确认

更详细的说明如下：

    BEGIN或START TRANSACTION显式地开启一个事务
    COMMIT也可以使用COMMIT WORK，不过二者是等价的。COMMIT会提交事务，使已对数据库进行的所有修改成为永久性的
    ROLLBACK也可以使用ROLLBACK WORK，不过二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改
    SAVEPOINT identifier，SAVEPOINT允许在事务中创建一个保存点，一个事务中可以有多个SAVEPOINT
    RELEASE SAVEPOINT identifier删除一个事务的保存点，当没有指定的保存点时，执行该语句会抛出一个异常
    ROLLBACK TO identifier把事务回滚到标记点
    SET TRANSACTION用来设置事务的隔离级别。InnoDB存储引擎提供事务的隔离级别有READ UNCOMMITTED、READ COMMITTED、REPEATABLE READ和SERIALIZABLE

（2）MySQL AUTOCOMMIT自动提交模式（隐式事务）

在MySQL命令行的默认设置下，事务都是自动提交的，即执行一条SQL语句后就会马上执行COMMIT操作。

    SET AUTOCOMMIT=0禁止自动提交
    SET AUTOCOMMIT=1开启自动提交

举例来说，

```sql
create table test(id int);

-- 开始事务，提交事务
-- 所以1被插入
begin;
insert into test values(1);
commit;

-- 先回滚事务，再提交事务
-- 所以2没有被插入
begin;
insert into test values(2);
rollback;
commit;

-- 先回滚到s1，再提交事务
-- 所以3被插入，4没有被插入
begin;
insert into test values(3);
savepoint s1;
insert into test values(4);
rollback to s1;
commit;

-- 回滚事务，事务未提交
-- 所以5没有被插入
start transaction;
insert into test values(5);
rollback;

-- 自动提交，再回滚
-- 所以6会被插入
set autocommit=1;
insert into test values(6);
rollback;

-- 禁止自动提交，再回滚
-- 所以7未被插入
set autocommit=0;
insert into test value(7);
rollback;
```

# 事务提交的类型（一个事务被结束的几种方式）

## 显式提交

所有的数据操纵语句都是要显式提交的，所谓显式提交就是要执行commit/rollback。数据操纵语句执行完后，处理的数据都会放在回滚段中，等待用户进行提交或者回滚，当用户执行commit/rollback后，放在回滚段中的数据就会被删除。显式提交是由你决定是否提交，这种事务允许你自己决定哪批工作必须成功完成，否则所有部分都不能完成。

## 隐式提交

MySQL数据库隐式提交的三种情况：

    正常执行完数据定义语言（DDL）包括create，alter，drop，truncate，rename
    正常执行完数据控制语言（DCL）包括grant，revoke
    正常退出MySQL客户端，没有明确发出commit/rollback

隐式事务又称自动提交事务，在遇到上面的各种操作之前，由系统自动帮你完成事务的提交。

## 自动提交

若把AUTOCOMMIT设置为ON，在插入、修改、删除语句（即部分的DML）执行后，系统将自动进行提交。

# 事务并发可能出现的情况

（1）脏读（Dirty Read）

![](/images/innodb_trx_1_6.png)

会话B开启一个事务，把id=1的name为武汉市修改成温州市，此时另外一个会话A也开启一个事务，读取id=1的name，此时的查询结果为温州市，会话B的事务最后回滚了刚才修改的记录，这样会话A读到的数据是不存在的，这个现象就是脏读。脏读只在读未提交隔离级别才会出现。

（2）不可重复读（Non-Repeatable Read）

![](/images/innodb_trx_1_7.png)

会话A开启一个事务，查询id=1的结果，此时查询的结果name为武汉市。接着会话B把id=1的name修改为温州市（隐式事务，因为此时的autocommit为1，每条SQL语句执行完自动提交），此时会话A的事务再一次查询id=1的结果，读取的结果name为温州市。会话B再此修改id=1的name为杭州市，会话A的事务再次查询id=1，结果name的值为杭州市，这种现象就是不可重复读。

（3）幻读（Phantom）

![](/images/innodb_trx_1_8.png)

会话A开启一个事务，查询id>0的记录，此时会查到name=武汉市的记录。接着会话B插入一条name=温州市的数据（隐式事务，因为此时的autocommit为1，每条SQL语句执行完自动提交），这时会话A的事务再以刚才的查询条件（id>0）再一次查询，此时会出现两条记录（name为武汉市和温州市的记录），这种现象就是幻读。

# 事务的四种隔离级别

简单来说，所以事务的隔离级别，是事务与事务间的冲突处理机制。

## 读未提交（READ UNCOMMITTED）

![](/images/innodb_trx_1_1.png)

在读未提交隔离级别下，事务A可以读取到事务B修改过但未提交的数据。

读未提交解决了更新丢失，但可能发生**脏读、不可重复读和幻读问题**，一般很少使用此隔离级别。

## 读已提交（READ COMMITTED）

![](/images/innodb_trx_1_2.png)

在读已提交隔离级别下，事务B只能在事务A修改过并且已提交后才能读取到事务B修改的数据。

读已提交隔离级别解决了脏读的问题，但可能发生**不可重复读和幻读**问题，一般很少使用此隔离级别。

## 可重复读（REPEATABLE READ）

![](/images/innodb_trx_1_3.png)

在可重复读隔离级别下，事务B只能在事务A修改过数据并提交后，自己也提交事务后，才能读取到事务B修改的数据。

可重复读隔离级别解决了脏读和不可重复读的问题，但可能发生**幻读**问题。

MySQL InonoDB默认使用可重复读隔离级别。

## 可串行化（SERIALIZABLE）

![](/images/innodb_trx_1_4.png)

![](/images/innodb_trx_1_9.png)

![](/images/innodb_trx_1_10.png)

![](/images/innodb_trx_1_11.png)

各种问题（脏读、不可重复读、幻读）都不会发生，通过加锁实现（读锁和写锁）。

# 事务隔离级别底层原理MVCC

（1）MVCC简介

所谓的MVCC，全称为Multi Version Concurrency Control，中文为多版本并发控制。

（2）版本链

对于使用InnoDB存储引擎的表来说，它的聚簇索引记录中都包含两个必要的隐藏列（row_id并不是必要的，我们创建的表中有主键或者非NULL唯一键时都不会包含row_id列）：

+ trx_id：每次对某条聚簇索引记录进行改动时，都会把对应的事务id赋值给trx_id隐藏列。
+ roll_pointer：每次对某条聚簇索引记录进行改动时，都会把旧的版本写入到undo日志中，然后这个隐藏列就相当于一个指针，可以通过它来找到该记录修改前的信息。

![](/images/innodb_trx_1_5.png)

对该记录每次更新后，都会将旧值放到一条undo日志中，就算是该记录的一个旧版本，随着更新次数的增多，所有的版本都会被roll_pointer属性连接成一个链表，我们把这个链表称之为版本链，版本链的头节点就是当前记录最新的值。另外，每个版本中还包含生成该版本时对应的事务id。需要注意的是，上面的事务都可能是活跃的事务，也就是并未被提交的事务。

（3）ReadView

InnoDB提出了一个ReadView的概念，这个ReadView中主要包含当前系统中还有哪些活跃的读写事务（即还未提交的事务），把它们的事务id放到一个列表中，我们把这个列表命名为为m_ids。这样在访问某条记录时，只需要按照下边的步骤判断记录的某个版本是否可见：

+ 如果被访问版本的trx_id属性值小于m_ids列表中最小的事务id，表明生成该版本的事务在生成ReadView前已经提交，所以该版本可以被当前事务访问。
+ 如果被访问版本的trx_id属性值大于m_ids列表中最大的事务id，表明生成该版本的事务在生成ReadView后才生成，所以该版本不可以被当前事务访问。
+ 如果被访问版本的trx_id属性值在m_ids列表中最大的事务id和最小事务id之间，那就需要判断一下trx_id属性值是不是在m_ids列表中，如果在，说明创建ReadView时生成该版本的事务还是活跃的，该版本不可以被访问；如果不在，说明创建ReadView时生成该版本的事务已经被提交，该版本可以被访问。
+ 如果某个版本的数据对当前事务不可见的话，那就顺着版本链找到下一个版本的数据，继续按照上边的步骤判断可见性，依此类推，直到版本链中的最后一个版本，如果最后一个版本也不可见的话，那么就意味着该条记录对该事务不可见，查询结果就不包含该记录。

![](/images/innodb_trx_1_12.png)

简单来说，MySQL会通过undo日志记录所有操作的，每个时刻的数据都会可追溯的，然后根据所设定的不同事务之间的隔离级别，来决定当前事务能看到哪个版本的数据。

# MySQL数据库隔离级别操作

（1）查看MySQL数据库当前隔离级别

```sql
// 方法一
select @@tx_isolation;

// 方法二
show variables like 'transaction_isolation';

// 方法三
select @@transaction_isolation;
```

备注：MySQL默认的隔离级别是REPEATABLE READ。

（2）设置当前数据库的隔离级别

```sql
SET [GLOBAL|SESSION] TRANSACTION ISOLATION LEVEL level;

# 其中level有4种值：
# level: {
#     READ UNCOMMITTED
#   | READ COMMITTED
#   | REPEATABLE READ
#   | SERIALIZABLE
#}
```

学习资料参考于：
我们都是小青蛙的[《MySQL事务隔离级别和MVCC》](https://mp.weixin.qq.com/s/Jeg8656gGtkPteYWrG5_Nw)
https://developer.aliyun.com/article/743691
