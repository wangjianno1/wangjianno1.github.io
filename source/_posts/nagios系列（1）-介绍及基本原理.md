---
title: nagios系列（1）_介绍及基本原理
date: 2018-01-29 19:57:08
tags: nagios
categories: 监控
---

# Nagios简介

Nagios全名为（Nagios Ain’t Goona Insist on Saintood），最初项目名字是 NetSaint。它是一款免费的开源IT基础设施监控系统，其功能强大，灵活性强，能有效监控 Windows 、Linux、VMware 和 Unix 主机状态，交换机、路由器等网络设置等。一旦主机或服务状态出现异常时，会发出邮件或短信报警第一时间通知IT运营人员，在状态恢复后发出正常的邮件或短信通知。Nagios结构简单，可维护性强，越来越受中小企业青睐，以及运维和管理人员的使用。同时提供一个可选的基于浏览器的Web界面，方便管理人员查看系统的运行状态，网络状态、服务状态、日志信息，以及其他异常现象。

其实，nagios仅仅是一个调度和通知的框架，它必须借助一些插件或各种衍生品才能构建一个完整的IT监控系统。

# Nagios的架构

Nagios结构上来说， 可分为核心core和插件Plugins两个部分。

（1）Nagios core

Nagios的核心部分提供监控的处理、任务调度、下发指令等功能，也提供了很少的监控功能。

（2）Nagios Plugins

Nagios Core只是一个监控的框架，自身其实没有监控的能力。Nagios插件是Nagios Core的独立扩展，可以用来监视我们需要监控的对象。Nagios插件接收命令行参数，执行特定检查，然后将结果返回到Nagios Core。Nagios插件可以是二进制执行文件（用C，C ++等编写），也可以是一些执行脚本（shell，Perl，PHP等）。目前根据Nagios的插件的来源，分为两类：

A）Nagios官方Plugins

Nagios官方Plugins有大约50个插件，例如check_dig，check_log，check_tcp，check_load等等。官方Nagios插件是由官方Nagios团队开发和维护。

B）Nagios社区Plugins

Nagios社区中有数千个插件可以使用，可以监控的对象非常全面。另外，Nagios用户也可以自己开发插件。

# Nagios的不足

（1）只提供监控界面展示，提供很少的界面配置功能

（2）无后台管理功能，多条数据需要通过脚本添加

（3）权限管理功能很简单，不能满足多数业务的需要

（4）没有内置的报表的功能，需要其他的附件的支持

（5）不支持数据库，数据以file方式存储，数据不易维护，易丢失

（6）监控目标的添加，需要通过手工或Shell脚本支持

# Nagios的部署架构图

Nagios的部署架构图如下：

![nagios部署架构图](/images/nagios_1_1.png)

监控中心服务器需要部署nagios core进程以及httpd。被监控主机根据需要部署特定的Agent即可，也可以不部署Agent，通过check_by_ssh这样的插件直接登录目标主机上采集数据。

如下为nagios的内部原理架构图：

![nagios内部原理架构图](/images/nagios_1_2.png)

备注：有上图中可以看出nagios在被动检查中，像nsca这样的插件会将结果是直接提交给nagios daemon，然后由nagios daemon写入到status.dat，然后再是nagios GUI分析status.dat进行展示的。

# nagios监控远程主机的方式

（1）使用check_by_ssh插件

使用check_by_ssh插件登录远程服务器并执行采集插件，获取采集结果。但是如果我们要监控数百或数千台服务器，则可能会导致监控服务器自身的负载比较高，因为建立或释放SSH链接都会增加一定的系统的开销。

（2）使用NRPE插件

NRPE允许您在远程Linux/Unix主机上执行插件。如果我们需要监视远程主机上的本地资源/属性，如磁盘使用情况，CPU负载，内存使用情况等，这将非常有用。使用NRPE的插件的监控采集架构图如下：

![NRPE数据采集架构图](/images/nagios_1_3.png)

（3）check_mk

参见OMD及check_mk部分。

# nagios的数据采集的主动模式和被动模式

nagios在获取监控采集数据时，有主动和被动两种模式：

（1）主动模式（active check）

![主动采集模式](/images/nagios_1_4.png)

在上图中，check_nrpe是一个二进制程序，NRPE是一个后台daemon，它们之间通过SSL连接。check_nrpe发给NRPE一个命令，比如check_disk，NRPE就执行这条命令对应的真实代码，这个真实代码在nrpe.cfg配置文件中定义。

（2）被动模式（passive check）

![被动采集模式](/images/nagios_1_5.png)

被动模式则是在被监控机上面通过插件或脚本获取监控数据，然后将数据通过send_nsca发往监控机，最后监控机通过NSCA接收并解析数据，并传递给Nagios。这样做的一个很大的优势避免了被监控机的数量比较多时，一次轮询时间过长而导致监控反应延迟，这也是被动模式能承担更大监控量的关键。nagios的被动检查的详细过程如下：

	外部程序采集host或service的状态值
	外部程序将采集值写入到nagios的external command file（也即是/omd/sites/XXX/tmp/run/nagios.cmd）
	nagios daemon读取external command file中的状态值，并将其写入nagios的处理队列Queue中
	nagios周期性从Queue中读取信息（nagios此处是分不清是主动检查或被动检查结果，一视同仁，一样的处理方式），并处理（写入status.dat或报警）。

![](/images/nagios_1_6.png)

开启nagios的被动检查方式如下：

通过nagios.cfg的中accept_passive_service_checks/accept_passive_host_checks来开启被动检查，然后在host或service中指明passive_checks_enabled=1即可。


学习资料参考于：
https://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/index.html
https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/toc.html (nagios core官方文档)
