---
title: nagios系列（5）_nagios分布式监控
date: 2018-01-30 01:05:54
tags: nagios
categories: 监控
---

# nagios的分布式监控

![](/images/nagios_5_1.png)

在上图例子中，在每个IDC做了一个中心节点 。在三个机房中的三个节点中，选择一个为主，另两个中心节点的监控数据通过send_nsca和submit_check_result提交数据到主节点 。而监控节点和监控机之间可以用nrpe、check_mk、nslient等等都可以。
