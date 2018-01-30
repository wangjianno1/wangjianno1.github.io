---
title: check_mk系列（1）_介绍及基本原理
date: 2018-01-30 14:24:30
tags: check_mk
categories: 监控
---

# check_mk简介

check_mk是一款通用的Nagios/Icinga数据采集插件，它采用了新的方法从操作系统和网络组件中收集数据，表现得比NRPE、check_by_ssh、NSClient和check_snmp更加优秀。

![](/images/check_mk_1_1.png)

具体的工作控制流程如下：

（1）nagios每一次对所监控的主机每进行一次检查的时间间隔触发一个活动检查。这种主动检查将会触发check_mk插件

（2）check_mk通过TCP连接到目标主机。目标主机上的check_mk_agent检索有关该主机的所有相关数据，并将其以ASCII文本形式返回给服务器端(类似于zabbix的架构)

（3）check_mk提取performance数据直接返回给RRD

（4）check_mk提取相关数据，比较所设置的warning/critical阀值，然后返回这台主机通过Nagios的被动的服务检查的检查结果。

简单来说，使用check_mk作为监控基础实施的话，一般至少需要nagios、check_mk-server、check_mk-agent这三个组件。更简单来说，check_mk是nagios的一个被动检查的插件而已。我们在check_mk的GUI上配置一些监控策略，check_mk会自动生成nagios的配置。

如下为基于Nagios/check_mk的监控解决方案架构原理图：

![](/images/check_mk_1_2.png)

![](/images/check_mk_1_3.png)

# check_mk的版本

check_mk有两种版本，一个是Raw Edition，另一个是Enterprise Edition。其中Raw Edition版本是开源且免费的，Enterprise Edition版本有更多的组件及技术支持，是收费的。

check_mk包含的组件有：

（1）Configuration & Check Engine

check_mk的数据采集等。

（2）Livestatus

一个nagios NEB模块，用户对外提供nagios内部状态信息。

（3）Multisite

check_mk的GUI界面，数据来源于Livestatus。我们通过check_mk Multisite去配置一些监控策略，会生成check_mk自身的一些本地配置。同时，check_mk会自动生成nagios的配置，然后由nagios来调度整个监控系统的运转。

（4）WATO

check_mk的配置面板，可以生成check_mk/nagios的配置。

（5）Notify

在nagios系统中，当报警发生时，nagios会调用用户自定义的报警插件来发出告警。然后在nagios + check_mk监控系统中，当报警发生时，nagios仅仅需要调用./bin/check_mk --notify命令以及附带一些命令参数即可。然后./bin/check_mk --notify会读取check_mk配置中的contact/contactgroup，并决定用什么方式来发出报警。详细内容参见http://mathias-kettner.com/checkmk_flexible_notifications.html，也就是说check_mk接管了Nagios的报警机制，当有告警事件发生时，nagios直接通知check_mk，然后具体的告警策略由check_mk来控制。

备注：简单来说，在nagios+check_mk监控系统中，所有告警也是由nagios主动发起的，只是说具体的报警策略由check_mk接管了。

（6）Business Intelligence

check_mk提供的BI统计报表系统。

（7）Mobile

check_mk的移动版，直接在浏览器中访问check_mk的网址，会自动切换到check_mk mobile版本。

（8）Event Console

Event Console是由mkeventd后台进程来控制的。

# check_mk的官网DEMO体验

	网址：http://demo.mathias-kettner.de/demo/check_mk/
	用户名：demo823或demo700
	密码：demo

4.check_mk与远程主机交互方式

![](/images/check_mk_1_4.png)

5.nagios与check_mk的结合

check_mk生成nagios配置时，会为每台host配置一个Check_MK服务，该服务会执行如下的check-mk command，该command会执行每台机器的预编译脚本（Check_MK是nagios的一个主动检查服务）。预编译脚本会与check_mk-agent通信，获取agent采集结果，check_mk拿到agent的采集结果后，会将结果回写给nagios的各个被动检查服务。

![](/images/check_mk_1_5.png)


学习资料参考于：
http://grass51.blog.51cto.com/4356355/994819
