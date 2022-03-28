---
title: MySQL性能优化工具之执行计划Explain
date: 2022-03-28 10:35:42
tags:
categories: 数据库
---

# Explian简介

MySQL提供了一个EXPLAIN命令, 它可以对SELECT语句进行分析, 并输出SELECT执行的详细信息, 以供开发人员针对性优化。Explain模拟SQL优化器执行SQL查询语句，并不会去真正的执行这条SQL，从而知道MySQL是如何处理你的SQL语句的。可用来分析你的查询语句或是表结构的性能瓶颈。通过Explain的执行计划可以得到如下的一些信息：

    表的读取顺序
    数据读取操作的操作类型
    哪些索引可以使用
    哪些索引被实际使用
    表之间的引用
    每张表有多少行被优化器查询

# Explain使用

执行执行`explain + Select语句`即可。输出结果大概如下：

![](/images/mysql_explain_1_1.png)

（1）id




// todo 待补充。。。

学习资料参考于：
https://blog.csdn.net/qq_43332570/article/details/106860200

