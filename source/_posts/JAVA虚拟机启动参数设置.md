---
title: JAVA虚拟机启动参数设置
date: 2018-01-31 00:18:03
tags: JAVA基础
categories: JAVA
---

# JVM启动参数的简介

Java JVM启动参数共分为三类：

（1）标准参数（-）

所有的JVM实现都必须实现这些参数的功能，而且向后兼容。

（2）非标准参数（-X）

非标准参数（-X）又称为扩展参数。默认JVM实现这些参数的功能，但是并不保证所有JVM实现都满足，且不保证向后兼容。

（3）非Stable参数（-XX）

此类参数各个JVM实现会有所不同，将来可能会随时取消，需要慎重使用。

# 标准参数（-）

（1）-client

设置JVM使用client模式，特点是启动速度比较快，但运行时性能和内存管理效率不高，通常用于客户端应用程序或者PC应用开发和调试。

（2）-server

设置JVM使server模式，特点是启动速度比较慢，但运行时性能和内存管理效率很高，适用于生产环境。在具有64位能力的JDK环境下将默认启用该模式，而忽略-client参数。

（3）-classpath classpath 或 -cp classpath

告知JVM搜索目录名、jar文档名、zip文档名，之间用冒号(:)分隔；使用-classpath后JVM将不再使用CLASSPATH中的类搜索路径，如果-classpath和CLASSPATH都没有设置，则JVM使用当前路径(.)作为类搜索路径。

JVM搜索类的方式和顺序为：Bootstrap，Extension，User。

- Bootstrap中的路径是JVM自带的jar或zip文件，JVM首先搜索这些包文件，用`System.getProperty("sun.boot.class.path")`可得到搜索路径。
- Extension是位于`%{JRE_HOME}/lib/ext`目录下的jar文件，JVM在搜索完Bootstrap后就搜索该目录下的jar文件，用`System.getProperty("java.ext.dirs")`可得到搜索路径。
- User搜索顺序为当前路径.、CLASSPATH、-classpath，JVM最后搜索这些目录，用`System.getProperty("java.class.path")`可得到搜索路径。

（4）-Dproperty=value

设置系统属性名/值对，运行在此JVM之上的应用程序可用`System.getProperty("property")`得到value的值。如果value中有空格，则需要用双引号将该值括起来，如`-Dname="space string"`。该参数通常用于设置系统级全局变量值，如配置文件路径，以便该属性在程序中任何地方都可访问。

（5）-jar

指定以jar包的形式执行一个应用程序。要这样执行一个应用程序，必须让jar包的manifest文件中声明初始加载的Main-class，当然那Main-class必须有`public static void main(String[] args)`方法。

（6）-version

输出java的版本信息，比如jdk版本、vendor、model。

（7）-showversion

输出java版本信息（与-version相同）之后，继续输出java的标准参数列表及其描述。

# 非标准参数（-X）

（1）`-Xms<x>`

设置JVM初始堆内存为xMB ，例如-Xms256M

（2）`-Xmx<x>`

设置JVM最大可用堆内存为xMB ，例如-Xmx1G

（3）`-Xss<x>`

设置单个线程栈的大小，一般默认为512k。

备注：一般而言，-Xms和-Xmx配置的一样大，避免JVM动态分配内存。

# 非Stable参数（-XX）

用-XX作为前缀的参数列表在JVM中可能是不健壮的，SUN也不推荐使用，后续可能会在没有通知的情况下就直接取消了。但是由于这些参数中的确有很多是对我们很有用的，比如我们经常会见到的-XX:PermSize、-XX:MaxPermSize等等。我们将Java HotSpot VM中-XX:的可配置参数列表分成三类：

- 行为参数（Behavioral Options）：用于改变JVM的一些基础行为
- 性能调优（Performance Tuning）：用于JVM的性能调优
- 调试参数（Debugging Options）：一般用于打开跟踪、打印、输出等JVM参数，用于显示JVM更加详细的信息

（1）行为参数举例

![](/images/java_jvm_1_1.png)

备注：上面表格中黑体的三个参数代表着JVM中GC执行的三种方式，即 串行、并行、并发。串行 （SerialGC）是JVM的默认GC方式，一般适用于小型应用和单处理器，算法比较简单，GC效率也较高，但可能会给应用带来停顿； 并行 （ParallelGC）是指GC运行时，对应用程序运行没有影响，GC和app两者的线程在并发执行，这样可以最大限度不影响app的运行； 并发 （ConcMarkSweepGC）是指多个线程并发执行GC，一般适用于多处理器系统中，可以提高GC的效率，但算法复杂，系统消耗较大。

（2）性能调优参数举例

![](/images/java_jvm_1_2.png)

（3）调试参数举例

![](/images/java_jvm_1_3.png)

# 一个例子

如下为启动一个ElasticSearch java进程的虚拟机启动参数：

```
/home/work/jdk1.8.0_112/bin/java -Xms2g -Xmx2g -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -server -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Dlog4j.skipJansi=true -XX:+HeapDumpOnOutOfMemoryError -Des.path.home=/home/work/elasticsearch -cp /home/work/elasticsearch/lib/elasticsearch-5.3.0.jar:/home/work/elasticsearch/lib/* org.elasticsearch.bootstrap.Elasticsearch -d
```

学习资料参考于：
https://my.oschina.net/dodojava/blog/23640