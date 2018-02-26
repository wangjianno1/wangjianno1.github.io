---
title: JAVA基础（17）_类加载机制
date: 2018-01-31 00:20:02
tags: JAVA基础
categories: JAVA
---

# 类加载器ClassLoader

ClassLoader，称为类加载器，类加载器的基本职责就是根据一个指定的类的名称，找到或者生成其对应的字节代码，返回一个java.lang.Class类的实例。这个实例就代表了该类。Java中的类加载器大致可以分成两类，一类是系统提供的，另外一类则是由Java应用开发人员编写的。所以JAVA平台中的类加载器有如下几种：

（1）引导类加载器（bootstrap class loader）

它用来加载 Java 的核心库，是用原生代码来实现的，并不继承自 java.lang.ClassLoader。

（2）扩展类加载器（extensions class loader）

它用来加载 Java 的扩展库。Java 虚拟机的实现会提供一个扩展库目录。该类加载器在此目录里面查找并加载 Java 类。

（3）系统类加载器（system class loader）

它根据Java应用的类路径（CLASSPATH）来加载Java类。一般来说，Java应用的类都是由它来完成加载的。可以通过ClassLoader.getSystemClassLoader()来获取它。

（4）用户自定义的加载类

如下为各种类加载器的树状组织架构图：

![](/images/java_syntax_17_1.png)

备注：类的加载器也是一个类，真正去加载其他类的是加载器ClassLoader的对象。

# java.lang.Class

JAVA中的类被ClassLoader加载后，生成一个java.lang.Class类的对象，然后通过Class类的newInstance()方法，返回我们定义的类的对象。

说白了，我们定义的类被类加载器加载后，就是java.lang.Class类的一个对象。然后由这个对象再来new出我们自定义类的对象（有点绕~~）。

备注：java.lang.Object是所有类的父类，注意与java.lang.Class的区别哦。java.lang.Class的父类也是java.lang.Object哦。

# 类加载器的代理模式

类加载器在尝试自己去查找某个类的字节代码并定义它时，会先代理给其父类加载器，由父类加载器先去尝试加载这个类，依次类推。需要注意的是，Java虚拟机是如何判定两个Java类是相同的。Java 虚拟机不仅要看类的全名是否相同，还要看加载此类的类加载器是否一样。只有两者都相同的情况，才认为两个类是相同的。即便是同样的字节代码，被不同的类加载器加载之后所得到的类，也是不同的。比如一个 Java 类 com.example.Sample，编译之后生成了字节代码文件 Sample.class。两个不同的类加载器ClassLoaderA和 ClassLoaderB分别读取了这个Sample.class文件，并定义出两个 java.lang.Class类的实例来表示这个类。这两个实例是不相同的。对于Java 虚拟机来说，它们是不同的类。试图对这两个类的对象进行相互赋值，会抛出运行时异常ClassCastException。

# 类的加载过程

由前面的类加载器的代理模式可以知道，类加载器会首先代理给其它类加载器来尝试加载某个类。这就意味着真正完成类的加载工作的类加载器和启动这个加载过程的类加载器，有可能不是同一个。真正完成类的加载工作是通过调用defineClass来实现的；而启动“类的加载过程”是通过调用loadClass来实现的。前者称为一个类的“定义加载器（defining loader）”，后者称为“初始加载器（initiating loader）”。在Java虚拟机判断两个类是否相同的时候，使用的是类的定义加载器。也就是说，哪个类加载器启动类的加载过程并不重要，重要的是最终定义这个类的加载器。如类com.example.Outer引用了类com.example.Inner，则由类com.example.Outer的定义加载器负责启动类com.example.Inner的加载过程。

类加载器在成功加载某个类之后，会把得到的java.lang.Class类的实例缓存起来。下次再请求加载该类的时候，类加载器会直接使用缓存的类的实例，而不会尝试再次加载。也就是说，对于一个类加载器实例来说，相同全名的类只加载一次，即loadClass方法不会被重复调用。

备注：方法loadClass()抛出的是java.lang.ClassNotFoundException异常；方法defineClass()抛出的是java.lang.NoClassDefFoundError异常。



学习资料参考于：
https://www.ibm.com/developerworks/cn/java/j-lo-classloader/index.html





