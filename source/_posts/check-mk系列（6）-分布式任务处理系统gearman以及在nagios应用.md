---
title: check_mk系列（6）_分布式任务处理系统gearman以及在nagios应用
date: 2018-01-30 16:17:33
tags: check_mk
categories: 监控
---

# gearman简介

gearman是一个分布式任务处理系统，我们可以将一个任务拆解成很多的子任务(worker)来处理。gearman技术栈架构如下：

![](/images/check_mk_6_1.png)

备注：黄色部分为Geaman提供，蓝色部分为用户自定义的应用程序，包括client和worker。

# gearman组成部分

一个gearman请求的处理过程涉及三个角色，如下：

（1）gearman client

提供gearman client API给应用程序调用。API可以使用C,PHP,PERL,MYSQL UDF等待呢个语言，它是请求的发起者。

（2）gearman job server

将客户端的请求分发到各个gearman worker的调度者，相当于中央控制器，但它不处理具体业务逻辑。gearmand一般监听的是4730端口（当然端口也可以指定为其他的）。

（3）gearman worker
提供gearman worker API给应用程序调用，具体负责客户端的请求，并将处理结果返回给客户端。

因为Client，Worker并不限制用一样的语言，所以有利于多语言多系统之间的集成。 甚至我们通过增加更多的Worker，可以很方便的实现应用程序的分布式负载均衡架构。

# gearman的高可用HA架构

![](/images/check_mk_6_2.png)

如上图架构中所示，client/job server/worker均可以进行扩展。

# gearman在nagios/omd监控平台中的应用

![](/images/check_mk_6_3.png)

有了mod_gearman后，omd的工作过程为：

（1）nagios发起一轮的host/service检查

（2）mod_gearman NEB模块（会在nagios.cfg中配置broker_module）拦截检查请求

（3）mod_gearman将检查请求任务提交到gearmand的任务队列中

（4）mod_gearman_worker服务从gearmand的任务队列中获取任务，执行检查，并将检查结果写入到Check Results中

（5）mod_gearman从Check Results中获取检查结果，并将结果放入到nagios的队列中

（6）nagios读取队列的检查结果，并更新nagios状态

# nagios中配置使用gearmand

需要在nagios.cfg中配置NEB代理，如下：

```
broker_module=/omd/sites/mm/lib/mod_gearman/mod_gearman.o config=/omd/sites/mm/etc/mod-gearman/server.cfg
```

这样后，nagios会将检查任务的执行直接交给了mod_gearman来处理。


学习资料参考于：
http://gearman.org/
https://labs.consol.de/nagios/mod-gearman/
