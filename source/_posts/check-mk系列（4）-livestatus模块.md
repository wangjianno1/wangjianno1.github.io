---
title: check_mk系列（4）_livestatus模块
date: 2018-01-30 15:50:22
tags: check_mk
categories: 监控
---

# check_mk livestatus简介

livestatus也是由mathias-kettner编写，livestatus是一个Nagios NEB模块，nagios daemon启动时，会将livestatus加载到nagios daemon进程中。简单来说，livestatus为用户提供了一个UNIX Socket，通过它，用户可以直接查询运行中的Nagios守护进程的状态信息。用户通过简单的查询语言，就可以得到即时的结果，该结果正是来自nagios进程所使用的内存中的数据结构区域。因为这种方式没有复制nagios的状态信息，也没有查询外部数据库，所以带来的开销非常小，而且这种方式没有任何延迟和数据过期的风险，所以不会带来阻塞nagios进程的风险。另外，通过livestatus，还可以获取到nagios的历史状态信息哦。

# 使用livestatus作为数据来源的系统

使用livestatus作为数据来源的系统有：

（1）Check_MK Multisite

（2）NagVis

（3）NagiosBP

（4）Thruk

（5）CoffeeSaint

（6）RealOpInsight

（7）......

# livestatus的配置和使用

（1）livestatus的配置

首先需要在nagios.cfg中配置livestatus的NEB，如下：

```
broker_module=/omd/sites/XXXX/lib/mk-livestatus/livestatus.o num_client_threads=20 pnp_path=/omd/sites/XXXX/var/pnp4nagios/perfdata /omd/sites/XXXX/tmp/run/live
```

其中/omd/sites/XXXX/tmp/run/live，即是livestatus提供的unix socket文件，通过该socket既可通过livestatus，获取到nagios的当前状态和历史状态信息。

（2）livestatus的使用

可以有很多方式与livestatus通信，其中使用shell命令最简单，这里以shell为例说明如何通过livestatus获取到nagios的status信息。

```bash
echo 'GET hosts' | nc -U /omd/sites/XXXX/tmp/run/live     #获取nagios中hosts信息
echo 'GET services' | nc -U /omd/sites/XXXX/tmp/run/live  #获取nagios中services信息
echo 'GET  contacts' | nc -U /omd/sites/XXXX/tmp/run/live #获取nagios中contacts信息
......
```


学习资料参考于：
http://mathias-kettner.com/checkmk_livestatus.html
