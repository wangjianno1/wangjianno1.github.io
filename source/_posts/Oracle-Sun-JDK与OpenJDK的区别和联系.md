---
title: Oracle/Sun JDK与OpenJDK的区别和联系
date: 2018-12-04 23:19:43
tags: JAVA基础
categories: JAVA
---

# Oracle/Sun JDK与OpenJDK的区别和联系

OpenJDK原是Sun Microsystems公司为Java平台构建的Java开发环境（JDK）的开源版本，完全自由，开放源码。Sun Microsystems公司在2006年的JavaOne大会上称将对Java开放源代码，于2009年4月15日正式发布OpenJDK。甲骨文在2010年收购Sun Microsystem之后接管了这个项目。

Oracle/Sun JDK里面包含的JVM是HotSpotVM，HotSpot VM只有非常非常少量的功能没有在OpenJDK里，那部分在Oracle内部的代码库里。这些私有部分都不涉及JVM的核心功能。所以说，Oracle/Sun JDK与OpenJDK其实使用的是同一个代码库。

从一个Oracle内部员工的角度来看，当他要构建OracleJDK时，他同样需要先从`http://hg.openjdk.java.net`签出OpenJDK，然后从Oracle内部的代码库签出私有的部分，放在OpenJDK代码下的一个特定目录里，然后构建。

值得注意的是，Oracle JDK只发布二进制安装包，而OpenJDK只发布源码。

学习资料参考于：
http://www.zhihu.com/question/19882320
https://zh.wikipedia.org/wiki/OpenJDK
