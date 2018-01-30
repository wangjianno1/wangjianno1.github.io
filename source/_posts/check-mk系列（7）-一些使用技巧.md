---
title: check_mk系列（7）_一些使用技巧
date: 2018-01-30 16:28:30
tags: check_mk
categories: 监控
---

# check_mk的PNP4Nagios面板的小功能

![](/images/check_mk_7_1.png)

功能1：可以查看对应时间段该host/service的所有告警信息，是超链接到nagios的历史告警报告页面上。
功能2：可以查看对应时间段该host/service的所有可用性数据，是超链接到nagios的Availablility报告页面上。
功能3：收藏视图到check_mk GUI的个人收藏夹中。
功能4：将pnp4nagios绘制的趋势图在单独的页面中显示，且可以灵活地调整时间范围，如下：

![](/images/check_mk_7_2.png)

# check
在check_mk的面板中，有很多功能需要关注下，如下：

![](/images/check_mk_7_3.png)

比如说，点击图标功能，可以在指定的对象，例如host、service等，执行特殊的操作。一个使用场景是，我们模拟各个采集项的结果，并触发报警。如下所示：

![](/images/check_mk_7_4.png)


