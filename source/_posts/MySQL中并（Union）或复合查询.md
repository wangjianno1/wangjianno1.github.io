---
title: MySQL中并（Union）或复合查询
date: 2018-02-02 14:35:32
tags: MySQL
categories: 数据库
---

# 并（Union）或复合查询

在大多数开发中，使用一条select查询就会返回一个结果集。如果，我们想一次性查询多条SQL语句，并将每一条select查询的结果合并成一个结果集返回。就需要用到Union操作符，将多个select语句组合起来，这种查询被称为并（Union）或者复合查询。

2.举例来说

假设现在两张表，分别是websites和apps，内容如下：

![](/images/mysqlunion_1_1.png)

如下是使用union和union all来查询的效果图。union默认会将多个select结果中重复的记录只保留一条，而union all会保留重复的记录：

![](/images/mysqlunion_1_2.png)

在使用union或union all时，每个select查询子句必须包含相同的列、表达式或者聚合函数 ，但列名称可以不一样。union查询在遇到不一致的字段名称时，会使用第一条select的查询字段名称，或者可以使用别名来改变查询字段名称，如下：

![](/images/mysqlunion_1_3.png)

学习资料参考于：
https://segmentfault.com/a/1190000007926959
http://www.runoob.com/mysql/mysql-union-operation.html

