---
title: JAVA虚拟机性能监控与故障处理工具
date: 2018-12-06 00:59:13
tags: JAVA虚拟机
categories: JAVA
---

# jps

jps，全称为JVM Process Status Tool，该命令显示系统内所有的HotSpot虚拟机JVM进程，也即Java进程啦。另外，jps可以通过RMI协议查看开了RMI服务的远程虚拟机进程状态。

命令行参数选项说明如下：

```
-q  #不输出类名、Jar名和传入main方法的参数
-m  #输出传入main方法的参数
-l  #输出main类或Jar的全限名
-v  #输出传入JVM的参数
```

备注：Java程序启动以后，会在`/tmp`目录下生成一个`hsperfdata_${USER}`的文件夹，这个文件夹的文件，就是以Java进程的pid命名。使用jps查看当前进程的时候，其实就是把`/tmp/hsperfdata_${USER}`中的文件名遍历一遍之后输出。如果`/tmp/hsperfdata_${USER}`的文件所有者和文件所属用户组与启动进程的用户不一致的话，在进程启动之后，就没有权限写`/tmp/hsperfdata_${USER}`，所以`/tmp/hsperfdata_${USER}`是一个空文件夹，那么执行jps命令也就没有任何显示。这一点需要注意。

# jstat

jstat，JVM Statistics Monitoring Tool，用于收集HotSpot虚拟机各方面的运行数据。它可以显示本地或远程虚拟机进程中的类装载、内存、垃圾收集、JIT编译等运行数据。

jstat命令格式如下：

```bash
jstat [option] pid interval count
```

备注：option表示需要查看JVM哪方面（主要包括类装载、垃圾收集、运行期编译状况）的运行状态，interval表示多少时间采集一次，count表示一共采集几次。若省略interval，count参数，则只查询一次。

# jinfo

jinfo，Configuration Info for Java，显示虚拟机配置信息。

# jmap

jmap，Memory Map for Java，生成虚拟机的内存转储快照，一般称为heapdump或dump文件。

# jhat

jhat，JVM Heap Dump Browser，与jmap命令配合使用，用于分析jmap生成的heapdump文件，它会建立一个HTTP/HTML服务器，让用户可以在浏览器上查看分析结果。

# jstack

jstack，Stack Trace for Java，显示虚拟机的线程快照。

# JMX与jconsole可视化工具

## JMX简介

JMX是Java Management Extensions的简写，即Java管理扩展。JMX是用来对Java应用程序和JVM进行监控和管理的，它是Java官方提供的一套用于监控Java程序和JVM运行时状态的标准API。通过JMX，我们可以监控的内容有很多，比如：

    服务器中各种资源的使用情况：如CPU、内存等
    JVM内存使用情况
    JVM中的线程情况
    JVM中加载的类
    ......

另外，JMX是J2SE平台的标准组成部分，是从J2SE 5.0引入了JMX功能，意味着我们使用JMX时，不需要引入任何第三方jar包，直接可以进行开发。在我们的JAVA程序中，通过使用JMX机制，当我们的JAVA应用在运行时，就会对外暴露一些程序内部监控信息的获取接口。
如下即为通过使用JMX机制来获取JAVA应用运行时的一些状态：

![](/images/java_jconsole_1_1.png)

## jconsole

jconsole是一个基于JMX的GUI工具，用于连接正在运行的JVM，不过此JVM需要使用可管理的模式启动。所谓可管理的形式，指的是JAVA应用开启JMX端口，供外部工具获取监控信息。在启动JAVA应用时，通过配置如下的虚拟机参数即可：

    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.authenticate=false 
    -Dcom.sun.management.jmxremote.ssl=false
    -Djava.rmi.server.hostname=10.16.20.96
    -Dcom.sun.management.jmxremote.port=8999

即`${JDK_HOME}/bin/java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=10.16.20.96 -Dcom.sun.management.jmxremote.port=8999 -jar my-java-app.jar`

然后我们在windows中cmd中通过jconsole命令，打开jconsole，然后新建连接，如下：

![](/images/java_jconsole_1_2.png)

# VisualVM可视化工具

待补充。
