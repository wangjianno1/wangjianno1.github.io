---
title: JAVA语言简介及技能图谱
date: 2018-01-30 18:44:37
tags: JAVA基础
categories: JAVA
---

# JAVA语言简介

Java是由Sun Microsystems公司于1995年5月推出的Java面向对象程序设计语言和Java平台的总称。由James Gosling和同事们共同研发，并在1995年正式推出。Java分为三个体系：

（1）JavaSE（J2SE）（Java2 Platform Standard Edition，java平台标准版）

（2）JavaEE（J2EE）（Java2 Platform Enterprise Edition，java平台企业版）

（3）JavaME（J2ME）(Java2 Platform Micro Edition，java平台微型版）

2005年6月，JavaOne大会召开，SUN公司公开Java SE 6。此时，Java的各种版本已经更名以取消其中的数字"2"，J2EE更名为Java EE, J2SE更名为Java SE，J2ME更名为Java ME。

# JAVA版本选择

从大概2019年01月份开始，Oracle JDK开始对Java SE 8之后的版本开始进行商用收费，确切的说是8u201/202之后的版本。如果你用Java开发的功能如果是用作商业用途的，如果还不想花钱购买的话，能免费使用的最新版本是8u201/202。当然如果是个人客户端或者个人开发者可以免费试用Oracle JDK所有的版本。

在JDK 9发布之前，Oracle的发版策略是以特性驱动的，只有重大的特性改变才会发布大版本，比如JDK 7到JDK 8，中间会发多个更新版本。而从JDK 9开始变为以时间驱动的方式。发布周期为6个月一个大版本，比如JDK 9到JDK 10，3个月一次补丁版，3年一个LTS（长期支持版本）。

![](/images/java_syntax_1_3.png)

备注：目前，开发者中还是大部分在使用JDK 8哦，主要原因是JDK 8是LTS，稳定可靠，另外JDK 8之后的版本用于商业用途是要收费的。

JDK 8的新特性主要有：

（1）Lambda表达式

Lambda允许把函数作为一个方法的参数（函数作为参数传递到方法中）。

（2）方法引用

方法引用提供了非常有用的语法，可以直接引用已有Java类或对象（实例）的方法或构造器。与 lambda 联合使用，方法引用可以使语言的构造更紧凑简洁，减少冗余代码。

（3）默认方法

默认方法就是一个在接口里面有了一个实现的方法。

（4）新工具

新的编译工具，如：Nashorn引擎jjs、 类依赖分析器jdeps。

（5）Stream API

新添加的Stream API（java.util.stream） 把真正的函数式编程风格引入到Java中。

（6）Date Time API

加强对日期与时间的处理。

（7）Optional类

Optional类已经成为Java 8类库的一部分，用来解决空指针异常。

# JAVA技术体系

JAVA技术体系包括如下几个部分：

（1）JAVA程序设计语言

（2）JAVA虚拟机JVM

（3）JAVA API类库

（4）来自商业机构或开源社区的第三方JAVA类库

# JAVA语言的完整概念图

![](/images/java_syntax_1_1.png)

图片来源于：https://docs.oracle.com/javase/8/docs/

备注：可见JDK是JRE的超集。

# JDK与JRE区别

JRE，Java Runtime Environment，是Java运行时环境，包含了Java虚拟机以及Java基础类库等，是使用Java语言编写的程序运行所需要的软件环境，是提供给想运行Java程序的用户使用的。

JDK，Java Development Kit，是Java开发工具包，是程序员使用Java语言编写Java程序所需的开发工具包，是提供给程序员使用的。JDK包含了JRE，同时还包含了编译Java源码的编译器javac，还包含了很多Java程序调试和分析的工具，如jconsole，jvisualvm等工具软件，另外，还包含了Java程序编写所需文档和demo例子程序。

如果你需要运行Java程序，只需安装JRE就可以了。如果你需要编写Java程序，需要安装JDK。

# JAVA技术栈的技能图谱

![](/images/java_syntax_1_2.png)

# JAVA世界中的一些新闻

（1）2017年，Oracle向Eclipse基金会捐赠Java EE规范，Java EE将被改名为Jakarta EE，在Java EE 8版本之后就是Jakarta EE 9，包名的命名空间从`javax.*`也改成了`jakarta.*`。

