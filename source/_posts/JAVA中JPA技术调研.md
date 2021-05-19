---
title: JAVA中JPA技术调研
date: 2018-01-31 00:11:57
tags: JAVA基础
categories: SSM/SSH
---

# JPA简介

JPA（Java Persistence API）是Sun官方提出的Java持久化规范。它为Java开发人员提供了一种对象/关联映射工具来管理Java应用中的关系数据。它的出现主要是为了简化现有的持久化开发工作和整合ORM技术，结束现在Hibernate，TopLink，JDO等ORM框架各自为营的局面。值得注意的是，JPA是在充分吸收了现有Hibernate，TopLink，JDO等ORM框架的基础上发展而来的，具有易于使用，伸缩性强等优点。JPA的总体思想和现有Hibernate，TopLink，JDO等ORM框架大体一致。

需要注意的是，虽然JPA最初打算用于关系/SQL型数据库，但是一些JPA实现已经扩展用于NoSQL数据存储，但JPA还主要是用于关系型数据库的场景。

总的来说，JPA包括以下3方面的技术：

（1）ORM映射元数据

JPA支持XML和JDK5.0注解两种元数据的形式，元数据描述对象和表之间的映射关系，框架据此将实体对象持久化到数据库表中。

（2）Java持久化API

用来操作实体对象，执行CRUD操作，框架在后台替我们完成所有的事情，开发者可以从繁琐的JDBC和SQL代码中解脱出来。

（3）查询语言（JPQL）

这是持久化操作中很重要的一个方面，通过面向对象而非面向数据库的查询语言查询数据，避免程序的SQL语句紧密耦合。

**简单地说，JPA是Sun定义的一套规范，不是一套产品，而像Hibernate，TopLink以及JDO等才是遵循了JPA规范的产品**。其实JPA规范的主要定义者是来自于Hibernate团队。JPA是一种规范不是产品，而Hibernate是一种ORM技术的产品。JPA有点像JDBC，为各种不同的ORM技术提供一个统一的接口，方便把应用移植到不同的ORM技术上。

另外，JPA定义了一系列的接口、注解等，它们在J2EE的javax.persistence包下，常用的举例来说有：

    javax.persistence.Entity
    javax.persistence.Table
    javax.persistence.Column
    javax.persistence.Id
    javax.persistence.GeneratedValue
    javax.persistence.OneToOne
    javax.persistence.ManyToOne
    javax.persistence.OneToMany
    javax.persistence.ManyToMany
    javax.persistence.JoinColumn
    javax.persistence.CascadeType
    javax.persistence.FetchType
    javax.persistence.Transient

说白了，JPA是对象关系映射ORM框架的一套标准，所有的具体的ORM框架都要遵循这套标准去实现。

# JAVA JPA技术整体组织结构

JAVA JPA技术整体组织结构如下：

![](/images/java_syntax_15_1.png)

# JPA的简单使用举例

假设我们使用JPA产品Hibernate作为项目的持久层框架，一般来说我们会首先使用JAVA JPA规范的注解来定义实体类，举例如下：

```java
//定义Student实例类
@Entity
@Table(name="t_student")
public class Student {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    private String name;

    @Column(name = "age")
    private Integer age;
   
    @ManyToOne(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
    @JoinColumn(name = "class_id")
    private ClassRoom classRoom;

    //省略getter和setter方法
}

//定义ClassRoom实体类
@Entity
@Table(name="t_classroom")
public class ClassRoom implements Serializable {
    private static final long serialVersionUID = 1L;
   
    @Id
    @GeneratedValue
    @Column(name = "id")
    private int id;
   
    @Column(name = "class_name")
    private String className;
   
    @OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
    @JoinColumn(name = "class_id")
    private List<Student> student;

    // 省略getter和setter方法
}
```

备注：一定要注意，这里面的注解使用的是javax.persistence包下注解，像Hibernate框架中也提供了这些注解。为了在ORM框架的移植性，我们一定是要javax.persistence包下注解。

定义了实体类后，我们要使用JPA实现框架的工具去初始化数据，然后使用JPA框架的接口实现数据库的增删改查等操作。

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
