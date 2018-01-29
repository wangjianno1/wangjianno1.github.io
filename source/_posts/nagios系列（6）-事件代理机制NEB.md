---
title: nagios系列（6）_事件代理机制NEB
date: 2018-01-30 01:08:34
tags: nagios
categories: 监控
---

# NEB简介

NEB，中文名为Nagios Event Broker，全称为Nagios事件代理。Nagios NEB提供了NEB API，供用户编写NEB模块。NEB绝对是Nagios最强大的接口，我们能够通过编写很多的事件代理模块，来对Nagios的功能进行扩展。NEB提供了很多的事件类型，这些事件类型涵盖了在Nagios中发生的每一种事件类型。用户编写的NEB模块都可以注册某个或所有事件类型。当NEB对所有NEB模块完成初始化后，会等待匹配模块订阅类型的事件发生，当接收到一个匹配事件后，NEB将会向NEB模块提供该事件的信息。比如，如果某个NEB模块注册了EXTERNAL_COMMAND_DATA，每当有外部命令插入到命令文件的时候，NEB就会通知该NEB模块。

![](/images/nagios_6_1.png)

# 用户自定义NEB模块的过程和工作原理

（1）nagios用户可以基于NEB API编写自己的NEB模块（一般用C语言编写），NEB模块需要向NEB注册要关注的事件类型以及事件发生后的回调函数。

（2）用户用C语言编写NEB模块完成后，需要编译链接成共享库so文件，然后在nagios.cfg中配置broker_moudle=xxx.so。

（3）nagios daemon进程在启动后，会将NEB模块加载到nagios进程中

（4）当nagios中发生了特定的事件，nagios的NEB会将事件通知给关注它的NEB模块，最终调用NEB模块所注册的回调函数。

# nagios中NEB的使用例子

（1）check-mk livestatus NEB模块

```
broker_module=/omd/sites/XXX/lib/mk-livestatus/livestatus.o num_client_threads=20 pnp_path=/omd/sites/XXX/var/pnp4nagios/perfdata /omd/sites/XXXX/tmp/run/live
```

（2）mod_gearman NEB模块

```
broker_module=/omd/sites/XXX/lib/mod_gearman/mod_gearman.o config=/omd/sites/XXX/etc/mod-gearman/server.cfg
```

（3）npcd NEB模块

```
broker_module=/omd/sites/XXX/lib/npcdmod.o config_file=/omd/sites/XXX/etc/pnp4nagios/npcd.cfg
```
