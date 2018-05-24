---
title: JAVA中反射机制
date: 2018-05-24 15:09:08
tags: JAVA基础
categories: JAVA
---

# Java的反射机制

JAVA反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法；这种动态获取的信息以及动态调用对象的方法的功能称为java语言的反射机制。　

JAVA中关于反射相关的类在`java.lang.reflect`包中。

# 获取Class对象

Java中，每个类被加载之后，JVM就会为该类生成一个对应的Class对象，通过该Class对象就可以访问到JVM中的这个类。在Java中获取某个类的Class对象通常有如下三种方式：

（1）Class.forName(String clazzName)

```java
Class cls = Class.forName("com.sohu.testmaven.Test");
System.out.println(cls.getName());
```

（2）任何类的class属性，如Person.class将会返回Person类对应的Class对象

```java
Class cls = Test.class;
System.out.println(cls1.getName());
```

（3）调用某个对象的getClass()方法，该方法是java.lang.Object类中的一个方法，该方法将返回该对象所属类对应的Class对象

```java
Test test = new Test();
Class cls2 = test.getClass();
System.out.println(cls2.getName());
```

备注：直白来说，获取到一个类的Class对象是使用反射机制的前提条件。

# 通过Class对象进行各种操作

如下通过获取到Test类的Class对象之后，就可以进行很多反射相关的操作了。具体如下：

![](/images/java_reflect_1_1.png)
