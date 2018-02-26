---
title: JAVA基础（16）_JAVA虚拟机启动参数设置
date: 2018-01-31 00:18:03
tags: JAVA基础
categories: JAVA
---

# JAVA虚拟机启动参数常见设置

```
-Xms<x>  #设置JVM初始堆内存为xMB ，例如-Xms256M
-Xmx<x>  #设置JVM最大可用堆内存为xMB ，例如-Xmx1G
-D<name>=<value>  #设置一个系统属性，例如-Dcom.sun.management.jmxremote.port=8999
```

备注：一般而言，-Xms和-Xmx配置的一样大，避免JVM动态分配内存。

# 一个例子

如下为启动一个ElasticSearch java进程的虚拟机启动参数：

```
/opt/itc/jdk1.8.0_112/bin/java -Xms2g -Xmx2g -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -server -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Dlog4j.skipJansi=true -XX:+HeapDumpOnOutOfMemoryError -Des.path.home=/opt/itc/elasticsearch -cp /opt/itc/elasticsearch/lib/elasticsearch-5.3.0.jar:/opt/itc/elasticsearch/lib/* org.elasticsearch.bootstrap.Elasticsearch -d
```
