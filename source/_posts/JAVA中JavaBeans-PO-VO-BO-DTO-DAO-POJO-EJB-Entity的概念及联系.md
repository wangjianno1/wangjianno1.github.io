---
title: JAVA中JavaBeans|PO|VO|BO|DTO|DAO|POJO|EJB|Entity的概念及联系
date: 2019-03-04 18:06:46
tags:
categories: JAVA
---

# JAVA中JavaBeans|PO|VO|BO|DTO|DAO|POJO|EJB|Entity简介

![](/images/java_obj_1_1.png)

# JavaBeans

JavaBeans是Java中一种特殊的类，可以将多个对象封装到一个对象（bean）中。特点是可序列化，提供无参构造器，提供getter方法和setter方法访问对象的属性。名称中的“Bean”是用于Java的可重用软件组件的惯用叫法。

要成为JavaBean类，则必须遵循关于命名、构造器、方法的特定规范。有了这些规范，才能有可以使用、复用、替代和连接JavaBeans的工具。具体规范如下：

    有一个public的无参数建构子
    属性可以通过get、set、is（可以替代get，用在布尔型属性上）方法或遵循特定命名规范的其他方法访问
    可序列化

# POJO

POJO，英文全称为Plain Ordinary Java Object，POJO代表的是一个简单的Java类，这个类没有实现/继承任何特殊的java接口或者类，不遵循任何主要Java模型，约定或者框架的java对象。而且，在理想情况下，POJO不应该有注解。使用POJO名称是为了避免和EJB混淆起来。

# EJB
EJB，全称为Enterprise JavaBean，中文为企业级JavaBean，是一个用来构筑企业级应用的服务器端可被管理组件。EJB就比较复杂，包含一定的业务逻辑。

相关学习资料：
https://blog.csdn.net/qq_35246620/article/details/77247427
