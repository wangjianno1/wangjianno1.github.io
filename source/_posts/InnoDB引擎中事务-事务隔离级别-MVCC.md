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

（2）直接用SET来改变MySQL的自动提交模式（隐式事务）

在MySQL命令行的默认设置下，事务都是自动提交的，即执行SQL语句后就会马上执行COMMIT操作。

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

# 事务提交的类型

## 显式提交

所有的数据操纵语句都是要显式提交的，所谓显式提交就是要执行commit/rollback。数据操纵语句执行完后，处理的数据都会放在回滚段中，等待用户进行提交或者回滚，当用户执行commit/rollback后，放在回滚段中的数据就会被删除。显式提交是由你决定是否提交，这种事务允许你自己决定哪批工作必须成功完成，否则所有部分都不能完成。

## 隐式提交

MySQL数据库隐式提交的三种情况：

    正常执行完数据定义语言（DDL）包括create，alter，drop，truncate，rename
    正常执行完数据控制语言（DCL）包括grant，revoke
    正常退出MySQL客户端，没有明确发出commit/rollback

隐式事务又称自动提交事务，在遇到上面的各种操作之前，由系统自动帮你完成事务的提交。

## 自动提交

若把AUTOCOMMIT设置为ON，在插入、修改、删除语句（即部分的DML）执行后，系统将自动进行提交。显式提交转变为隐式提交的过程称为自动提交。

# 事务的四种隔离级别

简单来说，所以事务的隔离级别，是事务与事务间的冲突处理机制。

## 未提交读（READ UNCOMMITTED）

如果事务A已经开始写数据，则事务B不允许同时对该数据进行写操作，但允许事务B读取此行数据，该隔离级别可以通过“排他写锁”（但是不排斥读线程）来实现。这样就避免了更新丢失，却可能出现脏读，也就是说事务B读取到了事务A未提交的数据。

这样一来，一个事务读到了另一个未提交事务修改过的数据，那么这种隔离级别就称之为未提交读。

![](/images/innodb_trx_1_1.png)

总结，READ UNCOMMITTED解决了更新丢失，但可能会出现脏读。

## 已提交读（READ COMMITTED）

如果事务A仅做读操作，则允许事务B同时进行读写操作，如果事务A进行写操作，则会禁止事务B读写该行数据。该隔离级别避免了脏读，但是可能出现不可重复读。事务A事先读取了数据，事务B紧接着更新了数据，并提交了事务，而事务A再次读取该数据时，数据已经发生了改变。

![](/images/innodb_trx_1_2.png)

总结，解决了更新丢失和脏读问题，但是会出现不可重复读。

## 可重复读（REPEATABLE READ）

可重复读取是指在事务A内，多次读同一个数据，在事务A还没结束时，事务B不能访问该数据（包括了读写），这样就可以在同一个事务内两次读到的数据是一样的，因此称为是可重复读隔离级别，仅为读取数据的事务将会禁止写事务（但允许读事务），写事务则禁止任何其他事务（包括了读写），这样避免了不可重复读和脏读，但是有时可能会出现幻读。（读取数据的事务）可以通过“共享读镜”和“排他写锁”实现。

![](/images/innodb_trx_1_3.png)

总结，解决了更新丢失、脏读、不可重复读、但是还会出现幻读。

## 串行化（SERIALIZABLE）

以上3种隔离级别都允许对同一条记录进行读-读、读-写、写-读的并发操作，如果我们不允许读-写、写-读的并发操作，可以使用SERIALIZABLE隔离级别。提供严格的事务隔离，它要求事务序列化执行，事务只能一个接着一个地执行，但不能并发执行，如果仅仅通过“行级锁”是无法实现序列化的，必须通过其他机制保证新插入的数据不会被执行查询操作的事务访问到。序列化是最高的事务隔离级别，同时代价也是最高的，性能很低，一般很少使用，在该级别下，事务顺序执行，不仅可以避免脏读、不可重复读，还避免了幻读。

![](/images/innodb_trx_1_4.png)

总结，解决了更新丢失、脏读、不可重复读、幻读（虚读）。

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

学习资料参考于：
我们都是小青蛙的[《MySQL事务隔离级别和MVCC》](https://mp.weixin.qq.com/s/Jeg8656gGtkPteYWrG5_Nw)
