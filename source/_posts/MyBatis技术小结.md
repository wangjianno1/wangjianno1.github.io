---
title: MyBatis技术小结
date: 2019-03-04 22:43:00
tags:
categories: SSM/SSH
---

# MyBatis简介

MyBatis本是Apache的一个开源项目iBatis，2010年这个项目由Apache Software Foundation迁移到了Google Code，并且改名为MyBatis。iBATIS一词来源于“internet”和“abatis”的组合，是一个基于Java的持久层框架。iBATIS提供的持久层框架包括SQL Maps和Data Access Objects（DAO）。MyBatis是iBatis的升级版，用法有很多的相似之处，但是MyBatis进行了重要的改进。

MyBatis是一款优秀的持久层框架，它支持定制化SQL、存储过程以及高级映射。MyBatis避免了几乎所有的JDBC代码和手动设置参数以及获取结果集。MyBatis可以使用简单的XML或注解来配置和映射原生信息，将接口和Java的POJOs（Plain Old Java Objects，普通的 Java对象）映射成数据库中的记录。

备注：Hibernate比较重，Mybatis比较轻，简单易用。

# MyBatis的架构和原理

MyBatis的架构图如下：

![](/images/java_mybatis_1_1.png)

MyBatis应用程序根据XML配置文件创建SqlSessionFactory，SqlSessionFactory在根据配置，配置来源于两个地方，一处是配置文件，一处是Java代码的注解，获取一个SqlSession。SqlSession包含了执行sql所需要的所有方法，可以通过SqlSession实例直接运行映射的SQL语句，完成对数据的增删改查和事务提交等，用完之后关闭SqlSession。

# Mybatis框架中的一些基础框架

    SqlSessionFactoryBuilder
    SqlSessionFactory
    SqlSession()
    Mapper

学习资料参考于：
http://www.mybatis.org/mybatis-3/zh/index.html
