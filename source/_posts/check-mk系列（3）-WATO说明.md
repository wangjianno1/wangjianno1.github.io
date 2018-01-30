---
title: check_mk系列（3）_WATO说明
date: 2018-01-30 15:34:40
tags: check_mk
categories: 监控
---

# WATO提供的配置模块

原则上来说，我们可以修改/omd/sites/sgwlog/etc/check_mk目录下文件，来配置check_mk（比如增加host/service等等），但是这种方式非常不友好。其实check_mk的GUI页面上有WATO面板，可以通过它进行可视化地配置check_mk。

WATO提供的配置模块有：

![](/images/check_mk_3_1.png)

（1）Hosts模块

在WATO的host面板中，New host表示在当前目录中新增一台host。New folder表示在当前目录中新增一个目录。New cluster表示在当前目录中新增一个集群。

（2）Host & Service Parameters

rule的配置，很重要哦。

（3）Global Settings

（4）Monitoring Agents

# 在check_mk增加host以及为host配置服务service监控

（1）添加host

在左侧WATO Configuration面板中，点击Hosts条目后，点击右侧Create new host，然后按照如下配置host信息：

![](/images/check_mk_3_2.png)

（2）保存host信息并为host添加service监控

点击host信息下方的Save & go to Services按钮，即可进入该host对应的services监控配置页面，效果如如下：

![](/images/check_mk_3_3.png)

上图中Check_MK默认列出该host的所有服务，例如CPU负载、内存使用情况、磁盘可用空间等等，我们可以自主地选择一些服务，然后点击面板上方的Save manual check configuration按钮。

（3）让配置变更生效

点击Changes按钮，然后点击Activate Changes!按钮，即可生效check_mk中的所有变更。界面操作如下：

![](/images/check_mk_3_4.png)

![](/images/check_mk_3_5.png)

备注：在Check_mk中做任何配置变更，都需要经过这两个步骤，监控才能生效哦。

# WATO的Activate Changes!

在check_mk的WATO面板中修改任何配置，都需要点击Activate Changes!按钮，配置才会真正生效。如下图，Activate Changes!会生成新的配置，并让check_mk加载新的配置，从而生效监控变更。

![](/images/check_mk_3_6.png)

# WATO的快照snapshot

在WATO中每次点击Activate Changes!按钮时，check_mk都会对配置生成一个快照，我们可以借助于这些历史的快照来回滚对check_mk的配置。界面效果如下：

![](/images/check_mk_3_7.png)

# check_mk的host管理

check_mk的host管理有如下几个特点：

（1）通过目录层级的方式来管理host

![](/images/check_mk_3_8.png)

（2）可以给host打tag标记

（3）check_mk为host自动检查可以监控的服务

# check_mk的服务自动发现auto discovery机制

给定一个host，check_mk的auto discovery机制能自动检查出，该host上有哪些可以被监控的服务。其实原理很简单，个人理解主要有两点：

（1）check_mk-agent每次都会将采集到的所有信息返回给check_mk服务端，这样check_mk的服务端就可以知道host上有哪些服务了

（2）check_mk有一些检查插件，可以远程探测目标host的

也就是说，通过上面的两方面，check_mk就知道主机上有哪些服务了。我们可以通过./bin/check_mk -L来查看check_mk可以探测出哪些服务。

# rule set

rule set在WATO配置中是一个非常重要的概念，例如WATO中我们可以add host，add hostgroup，而某一个hostgroup包含哪些host，是由rule来控制的，比如我们让某个目录下的有指定tag的机器，组成一个hostgroup。那么后面我们有机器变更，由于rule的存在，就会自动会维护这个hostgroup信息。rule可以配置很多东西，比如什么服务的告警的接收人等等。rule的配置是通过WATO的Host & Service Parameters来配置的。

我们通过Host & Service Parameters的Used Rulesets来查看已经制定了哪些rule。


参考资料来源于：
http://ithelp.ithome.com.tw/articles/10136521
