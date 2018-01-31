---
title: Kafka集群运维工具
date: 2018-01-31 17:00:43
tags: Kafka
categories: ELKStack
---

# Kafka集群的web管理工具

Kafka集群的web管理工具有很多，例如：

（1）Kafka Web Conslole

（2）Kafka Manager

（3）KafkaOffsetMonitor

具体参见http://kaimingwan.com/post/kafka/kafka-managershi-yong-jiao-cheng

（4）Kafka-monitor

具体参见项目地址：https://github.com/linkedin/kafka-monitor

（5）Kafka Eagle

# Kafka Manager

（1）Kafka Manager简介

Kafka Manager是Yahoo开源的Kafka集群管理工具，Kafka Manager主要支持以下几个功能：

	管理几个不同的集群
	很容易地检查集群的状态(topics, brokers, 副本的分布, 分区的分布)
	选择副本
	产生分区分配(Generate partition assignments)基于集群的当前状态
	重新分配分区。
	。。。

（2）Kafka Manager的配置与安装

Kafka Manager的配置与安装步骤如下：

A）下载并安装构建工具sbt

```bash
yum install java-1.8.0-devel
rpm -ivh sbt-0.13.15.rpm
```

备注：sbt的安装依赖java1.8开发包

B）下载kafka-manager源文件，并解压

在Github地址：https://github.com/yahoo/kafka-manager上下载项目源码，假设为kafka-manager-master.zip，解压缩并将目录重命名为kafka-manager。

C）使用sbt构建kafka-manager源文件

执行`cd kafka-manager && sbt clean dist`命令，命令执行完成后会在kafka-manager\target\universal目录下生成一个zip部署包。

备注：这个过程需要连接网络，可能执行的时间会比较长。

D）部署kafka-manager

将（3）中产生的部署包，分发到任意一台机器，并解压，修改配置文件kafka-manager/conf/application.conf，为kafka manager配置一个zookeeper实例，用来管理kafka manager自身的一些状态和配置信息（不是kafka集群连接的zookeeper哦，当然，这里可以复用kafka集群的zk哦 ），例如：

	kafka-manager.zkhosts="10.26.30.92:2181,10.26.30.94:2181,10.26.30.96:2181"

备注：部署机上不依赖sbt工具，所以我们可以在Windows上安装sbt，然后构建kafka-manager，最后将生成的部署包部署到linux服务器上也是可以的。

E）启动kafka-manager

```bash
./bin/kafka-manager   #默认监听9000端口
./bin/kafka-manager -Dconfig.file=/path/to/application.conf -Dhttp.port=8080 #启动时，为kafka-manager指定配置文件和端口
```

F）测试

使用浏览器打开http://hostname:9000

G）在Kafka-manager界面上添加集群，包括自定义Kafka集群的名称，Kafka集群使用到的zk集群，Kafka的版本等信息。

![](/images/kafka_2_1.png)

备注：一个kafka-manager可以管理多个kafka集群

（3）开启kafka的JMX，让kafka-manager获取更细粒度的监控信息

A）修改`${KAFKA_HOME}/bin/kafka-run-class.sh`, 为KAFKA_JMX_OPTS变量增加java.rmi.server.hostname参数，这样避免远程连接JMX端口失败的问题，形式如下：

	KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=10.26.30.96"

B）修改`${KAFKA_HOME}/bin/kafka-server-start.sh`中增加JMX_PORT环境变量，形式如下：

```bash
if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
    export JMX_PORT="8999"
fi
```

C）在kafka-manager中打开集群的JMX选项

![](/images/kafka_2_2.png)

备注：我们也可以直接在Windows上使用jsconsole来连接JMX（hostname:port）来查看一个监控参数，界面如下：

![](/images/kafka_2_3.png)