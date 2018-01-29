---
title: nagios系列（4）_nagios GUI
date: 2018-01-30 01:03:06
tags: nagios
categories: 监控
---

# 监控dashboard上的选项的含义

![](/images/nagios_4_1.png)

其中Status为监控项当前的状态，Last Check为上一次采集的时间，Duration表示目前的服务状态维持了多长的时间，Attempt和max_check_attempts是对应的，分母就是max_check_attempts，分子是当前已经检测了多少次。
