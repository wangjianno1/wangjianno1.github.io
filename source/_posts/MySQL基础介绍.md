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
