---
title: nagios系列（7）_周边产品生态
date: 2018-01-30 01:12:04
tags: nagios
categories: 监控
---

nagios不仅仅是一个监控软件，其实更多像一个监控的框架，形成了一个生态圈，以nagios为核心，衍生了很多围绕其开发的优秀的程序。Nagios通常由一个主程序(Nagios Core)、很多插件程序(Nagios-plugins)和四个可选的附件(NRPE、NSCA、 NSClient++和NDOUtils)组成。Nagios的监控工作都是通过插件实现的，因此，Nagios和Nagios-plugins是服务器端工作所必须的组件。四个可选的附件分别说明如下：

（1）NRPE

用来在监控的远程Linux/Unix主机上执行脚本插件以实现对这些主机资源的监控。check_nrpe插件：运行在监控主机上 ，NRPE daemon：运行在远程的linux主机上(通常就是被监控机) 。

（2）NSCA

用来让被监控的远程Linux/Unix主机主动将监控信息发送给Nagios服务器(这在冗余监控模式中特别要用到) 。

（3）NSClient++

用来监控 Windows主机时安装在Windows主机上的组件。

（4）NDOUtils

则用来将Nagios的配置信息和各event产生的数据存入数据库，以实现这些数据的快速检索和处理。这种方式比我们直接开发脚本，解析Nagios本地监控数据要高效得多。

这四个ADDON(附件)中，NRPE和NSClient++工作于客户端，NDOUtils工作于服务器端，而NSCA则需要同时安装在服务器端和客户端。

除了上述一些nagios附件，还有许多Nagios的周边衍生产品，如下：

（1）ICINGA

ICINGA，就是一个Nagios开发者独立出去成立的项目，新的开源项目完全兼容以前的Nagios应用程序及扩展功能。在ICINGA网站上，定义ICINGA是一个介于Nagios社区版和企业版间的产品，特别将致力于解决Nagios项目现在的问题。 

ICINGA的web界面做的不错，很多配置都和Nagios类似。 所以准确的说，这个是nagios的一个衍生品，和nagios并列的一个东西，并不完全是围绕nagios的一个产品。

（2）Centreon

Centreon作为nagios的分布式监控管理平台，其功能之强大，打造了Centreon在IT监控方面强势地位，它的底层使用Nagios监控软件，Nagios通过ndoutil模块将监控数据写入数据库，Centreon读取该数据并即时的展现监控信息，通过centreon可以简单地管理和配置所有Nagios，因此，完全可以使用centreon轻易的搭建企业级分布式IT基础运维监控系统。 可以简单理解，Centreon就是一个基于Nagios的Dashboard，有很多操作可以在web端完成。

（3）PNP4Nagios

PNP4Nagios是nagios的一个插件，增强Nagios的图表功能。PNP4Nagios同时也支持ICINGA。自从有了pnp4nagios，nagios与cacti在绘图展示上对比，也显得更加自信。说白了，PNP4Nagios是nagios与RRDtool粘合层或中间件，类似于NagiosGraph。

（4）Check_MK

Check_MK德国人写的，貌似德国制造都很精品。Check_MK也和Centreon有点类似，但是它有个更强大的地方是Check_MK有自己单独的数据采集客户端工具，配置也比较简单，当然同时也支持SNMP。Check_MK是开源的。

（5）Nconf

Nconf是一个Nagios web管理工具，可以实现web进行操作。不过有了check_mk的WATO ，估计这个也快要下岗了。


学习资料参考于：
http://www.361way.com/nagios-framework/2884.html
http://www.361way.com/distributed-monitoring-livestatus-multisite/2904.html
