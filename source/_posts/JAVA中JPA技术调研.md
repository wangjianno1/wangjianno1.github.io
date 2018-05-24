---
title: JAVA中JPA技术调研
date: 2018-01-31 00:11:57
tags: JAVA基础
categories: JAVA
---

# JPA简介

JPA，英文全称为Java Persistence API，它定义了一系列对象持久化的标准，目前实现这一规范的产品有Hibernat、TopLink以及Mybatis等等。

# JAVA JPA技术整体组织结构

JAVA JPA技术整体组织结构如下：

![](/images/java_syntax_15_1.png)

# JPA中EntityManager简介

JPA中要对数据库进行操作前，必须先取得EntityManager对象，这有点类似JDBC在对数据库操作之前，必须先取得Connection对象，EntityManager是JPA操作的基础，但它不是线程安全的。

EntityManager主要用来管理Entity对象生命周期，通过EntityManager可以对Entity对象进行操作，也就对应到对数据库进行增删改查等操作。

# EntityManager的获取方式

（1）通过静态方法`EntityManagerFactory.createEntityManager()`来取得。

（2）若使用容器管理，则可以使用@PersistenceContext注入EntityManger。

（3）可以使用@PersistenceUnit注入EntityManagerFactory，再用它来建立EntityManager。

# 使用EntityManager操作数据库的示例

如下是一些操作示例：

（1）要新增记录，可以使用EntityManager的persist()方法，这也会让Entity实例处于Managed状态，例如：

```java
User user = new User();
// 设定user相关属性
entityManager.persist(user);
```

（2）若要查找数据库中的记录，使用EntityManager的find()方法，指定主键和Entiry Class实例来取得对应的Entiry对象，查找回的记录会处于Managed的状态，例如：

```java
User user = entityManager.find(User.class, id);
```

（3）若要修改数据库中已有的记录，可按如下的方式

若记录是在Managed状态，例如查找记录之后，直接更新记录，在提交确认之后，记录的更新就会反应至数据库之中：

```java
User user = entityManager.find(User.class, id);
user.setName("Justin Lin");
```

（4）若要删除数库表中的记录，则记录必须是在Managed的状态，例如用EntityManager的find()方法查找记录，以查找到的记录配合remove()方法来移除，或是使用merge(()方法将Entity处于Managed状态再用remove()移除，代码示例如下：

```java
User user = entityManager.find(User.class, id);
entityManager.remove(user);
```


学习资料参考于：
https://openhome.cc/Gossip/EJB3Gossip/EntityManager.html
