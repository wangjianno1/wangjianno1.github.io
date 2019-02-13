---
title: MySQL存储引擎
date: 2019-02-13 15:35:59
tags: MySQL
categories: 数据库
---

# 存储引擎介绍

MySQL中的数据用各种不同的技术存储在文件（或者内存）中。这些技术中的每一种技术都使用不同的存储机制、索引技巧、锁定水平并且最终提供广泛的不同的功能和能力。通过选择不同的技术，你能够获得额外的速度或者功能，从而改善你的应用的整体功能。 简单来说，存储引擎就是如何存储数据、如何为存储的数据建立索引和如何更新、查询数据等技术的实现方法。

在MySQL中，不需要在整个服务器中使用同一种存储引擎，针对具体的要求，可以对每一个表使用不同的存储引擎。

# MySQL的存储引擎

MySQL常见的存储引擎有：

（1）MyISAM

MyISAM是MySQL提供的最早的存储引擎。MyISAM表是独立于操作系统的，这说明可以轻松地将其从Windows服务器移植到Linux服务器。每当我们建立一个MyISAM引擎的表时，就会在本地磁盘上建立三个文件，文件名就是表名。例如，我建立了一个MyISAM引擎的tb_Demo表，那么就会生成以下三个文件：

    tb_demo.frm，存储表定义
    tb_demo.MYD，存储数据
    tb_demo.MYI，存储索引

MyISAM表无法处理事务，这就意味着有事务处理需求的表，不能使用MyISAM存储引擎。

（2）InnoDB（默认的存储引擎）

InnoDB是一个健壮的事务型存储引擎，这种存储引擎已经被很多互联网公司使用，为用户操作非常大的数据存储提供了一个强大的解决方案。InnoDB是目前使用最多的存储引擎，支持“行级锁”，而其他的存储引擎一般只有“表级锁”。行级锁的意思是当要修改某一条记录时，MySQL只对该行加锁，而该表的其他行仍可以由其他的client来执行修改。

（3）Memery

将MySQL的数据存放到内存上。当主机宕掉，那么该机上的数据也将丢失。

（4）NDB

NDB引擎可以实现MySQL Cluster，分布式MySQL集群。

（5）Archive

（6）Federated

（7）Maria

（8）......

目前在实际应用中，我们主要使用MyISAM和InnoDB两种存储引擎。不同存储引起都有各自的特点，为适应不同的需求，需要选择不同的存储引擎，所以首先考虑这些存储引擎各自的功能和兼容。

| 特性 | InnoDB | MyISAM | MEMORY | ARCHIVE |
| ---- | ----- | ------- | ------ | ------- |
| 存储限制(Storage limits) | 64TB | No | YES | No |
| 支持事物(Transactions) | Yes | No | No | No |
| 锁机制(Locking granularity) | 行锁 | 表锁 | 表锁 | 行锁 |
| B树索引(B-tree indexes) | Yes | Yes | Yes | No |
| T树索引(T-tree indexes) | No | No | No | No |
| 哈希索引(Hash indexes) | Yes | No | Yes | No |
| 全文索引(Full-text indexes) | Yes | Yes | No | No |
| 集群索引(Clustered indexes) | Yes | No | No | No |
| 数据缓存(Data caches) | Yes | No | N/A | No |
| 索引缓存(Index caches) | Yes | Yes | N/A | No |
| 数据可压缩(Compressed data) | Yes | Yes | No | Yes |
| 加密传输(Encrypted data<sup>[1]</sup>) | Yes | Yes | Yes | Yes |
| 集群数据库支持(Cluster databases support) | No | No | No | No |
| 复制支持(Replication support<sup>[2]</sup>) | Yes | No | No | Yes |
| 外键支持(Foreign key support) | Yes | No | No | No |
| 存储空间消耗(Storage Cost) | 高 | 低 | N/A | 非常低 |
| 内存消耗(Memory Cost) | 高 | 低 | N/A | 低 |
| 数据字典更新(Update statistics for data dictionary) | Yes | Yes | Yes | Yes |
| 备份/时间点恢复(backup/point-in-time recovery<sup>[3]</sup>) | Yes | Yes | Yes | Yes |
| 多版本并发控制(Multi-Version Concurrency Control/MVCC) | Yes | No | No | No |
| 批量数据写入效率(Bulk insert speed) | 慢 | 快 | 快 | 非常快 |
| 地理信息数据类型(Geospatial datatype support) | Yes | Yes | No | Yes |
| 地理信息索引(Geospatial indexing support<sup>[4]</sup>) | Yes | Yes | No | Yes |

# 关于MySQL存储引擎的一些命令操作

```sql
show engines;                /*查看MySQL支持的存储引擎*/
show create table websites;  /*可以查看某张表的使用的存储引擎*/
show table status from 数据库名名称 where name='表名称';   /*可以查看某张表的使用的存储引擎*/
```

学习资料参考于：
https://github.com/jaywcjlove/mysql-tutorial/blob/master/chapter3/3.5.md