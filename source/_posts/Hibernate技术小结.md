---
title: Hibernate技术小结
date: 2019-03-04 22:37:29
tags:
categories: SSM/SSH
---

# Hibernate简介

Hibernate是一个符合JPA规范的对象关系映射ORM框架。

# Hibernate的使用

（1）编写实体类

如Person类。

（2）编写实体类和数据库表的映射文件

如Person.hbm.xml。

（3）编写Hibernate的主配置文件hibernate.cfg.xml

hibernate.cfg.xml中配置数据库的地址、用户名、密码等基本信息，同时将第（2）步中的定义的对象关系映射文件配置到hibernate.cfg.xml中。

（4）使用Hibernate提供工具加载hibernate.cfg.xml，并获取到SessionFactory对象，SessionFactory对象可以打开与数据库连接会话，通过会话我们就可以操作数据库了。伪代码示例如下：

```java
Configuration cfg = new Configuration().configure();  //Hibernate会在类路径的根路径下自动寻找名为hibernate.cfg.xml的配置文件并加载
sessionFactory = cfg.buildSessionFactory();
Session session = sessionFactory.openSession();
Query query = session.createQuery("from Course")
```

备注：这个是Hibernate的最传统的使用方式，Hibernate支持通过注解来提高开发效率哦。

# Hibernate与Mybatis的区别

Hibernate和MyBatis同为实现了JPA规范的ORM框架，它们有很多的区别。

ORM框架的本质是简化编程中与数据库相关的交互，发展到现在基本上就剩两家了，一个是宣称可以不用写一句SQL的Hibernate，一个是可以灵活调试动态SQL的MyBatis，两者各有特点，在企业级系统开发中可以根据需求灵活使用。Hibernate特点就是所有的SQL都用Java代码来生成，不用跳出程序去写（看）SQL，有着编程的完整性，发展到最顶端就是Spring Data JPA这种模式了，基本上根据方法名就可以生成对应的SQL了。MyBatis初期使用比较麻烦，需要各种配置文件、实体类、dao层映射关联、还有一大推其它配置。当然MyBatis也发现了这种弊端，初期开发了generator可以根据表结果自动生产实体类、配置文件和dao层代码，可以减轻一部分开发量，后期也进行了大量的优化可以使用注解了，自动管理DAO层和配置文件等。目前MyBatis已经可以和SpringBoot进行整合集成，即在SpringBoot项目中使用mybatis-spring-boot-starter依赖，可以通过注解的方式将Mybatis和SpringBoot进行整合。

Hibernate是一个开放源代码的对象关系映射框架，它对JDBC进行了非常轻量级的对象封装，使得Java程序员可以随心所欲的使用对象编程思维来操纵数据库。属于全自动的ORM框架，着力点在于POJO和数据库表之间的映射，完成映射即可自动生成和执行SQL。

而MyBatis本是Apache的一个开源项目iBatis，2010年这个项目由Apache Software Foundation迁移到了Google Code，并且改名为MyBatis 。属于半自动的ORM框架，着力点在于POJO和SQL之间的映射，自己编写SQL语句，然后通过配置文件将所需的参数和返回的字段映射到POJO。
