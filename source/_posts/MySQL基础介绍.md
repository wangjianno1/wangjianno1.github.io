---
title: MySQL基础介绍
date: 2018-12-14 14:11:03
tags: MySQL
categories: 数据库
---

# MySQL的发行版本

MySQL是一个开源的小型的关系型数据库，是由瑞典的MySQL AB公司开发，现在已经被Oracle公司收购了。Mysql的发行版本有：

（1）MySQL Community Server社区版本，开源免费，但不提供官方技术支持。

（2）MySQL Enterprise Edition企业版本，需付费，可以试用30天。

（3）MySQL Cluster集群版，开源免费。可将几个MySQL Server封装成一个Server。

（4）MySQL Cluster CGE高级集群版，需付费。

其中，MySQL Community Server是开源免费的，这也是我们通常用的MySQL的版本。

# MySQL体系架构

![](/images/mysql_arch_1_1.png)

从图中可以看出，MySQL将插件式地接入存储引擎。

# MySQL命令执行过程图

![](/images/mysql_arch_1_2.png)

更简洁的一张架构图：

![](/images/mysql_arch_1_3.png)

MySQL主要分为Server层和存储引擎层。

（1）Server层

主要包括连接器、查询缓存、分析器、优化器、执行器等，所有跨存储引擎的功能都在这一层实现，比如存储过程、触发器、视图，函数等，还有一个通用的日志模块binglog日志模块。

连接器，当客户端连接MySQL时，Server层会对其进行身份认证和权限校验。

查询缓存，执行查询语句的时候，会先查询缓存，先校验这个SQL是否执行过，如果有缓存这个SQL，就会直接返回给客户端，如果没有命中，就会执行后续的操作。

分析器，没有命中缓存的话，SQL语句就会经过分析器，主要分为两步，词法分析和语法分析，先看SQL语句要做什么，再检查SQL语句语法是否正确。

优化器，优化器对查询进行优化，包括重写查询、决定表的读写顺序以及选择合适的索引等，生成执行计划。

执行器，首先执行前会校验该用户有没有权限，如果没有权限，就会返回错误信息，如果有权限，就会根据执行计划去调用引擎的接口，返回结果。

（2）存储引擎

主要负责数据的存储和读取。Server层通过API与存储引擎进行通信。
