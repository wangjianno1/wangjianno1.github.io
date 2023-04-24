---
title: Spring家族说明
date: 2019-03-04 18:10:47
tags:
categories: SSM/SSH
---

# Spring家族

通常来说，我们说的Spring指的是Spring Framework，其实它只是Spring家族中一个产品，Spring家族还有很多产品，开发者可以根据自己的需要，选择Spring家族中的某些产品来使用。Spring家族的产品主要有：

（1）Spring Framework

它是Spring家族中核心子项目。包括了IoC，AOP，DAO/JDBC，Spring MVC，i18n等。

（2）Spring Data

Spring Data是Spring平台中一个功能模块，主要用来和数据访问层相关的框架功能。如关系型数据库、Map-Reduce分布式存储以及云存储环境等。

（3）Spring Security

它是被广泛使用的基于Spring的认证和安全工具，其目标是为Spring应用提供一个安全服务，比如认证、授权等等。

（4）Spring Boot

（5）Spring Cloud

（6）Spring Cloud Data Flow

（7）Spring Batch

（8）Spring AMQP

（9）Spring Mobile

（10）Spring For Android

（11）Spring Web Services

（12）Spring Web Flow

（13）Spring Session

（14）Spring Shell

（15）Spring Kafka

（16）.....

备注：Spring家族提供了很多的模块，开发项目时，我们可以根据需要来选择部分的模块来使用。具体参见`https://spring.io/projects`页面各模块的说明。

# Spring全家桶的包结构

（1）Spring Framework

    org.springframework.core
    org.springframework.beans
    org.springframework.aop
    org.springframework.web  // Spring MVC/Spring Web
    org.springframework.cache
    org.springframework.cglib
    org.springframework.context
    org.springframework.jdbc
    org.springframework.jms
    org.springframework.scheduling
    org.springframework.messaging
    ....

（2）Sping Data

    org.springframework.data.jpa
    org.springframework.data.mongodb
    org.springframework.data.jdbc
    org.springframework.data.redis
    ....

（3）Spring Boot

    org.springframework.boot

（4）Spring Security

    org.springframework.security

（5）….

# Spring Framework + SpringBoot + SpringCloud学习路线图

![](/images/spring_1_1.png) 

