---
title: nagios系列（2）_nagios安装
date: 2018-01-29 20:21:07
tags: nagios
categories: 监控
---

# naigos及nagios plugins的安装

前提声明，本次nagios的测试安装环境是Red Hat Enterprise Linux Server release 6.8 (Santiago)和nagios-4.2.4，详细Nagios安装步骤如下：

（1）安装Apache httpd服务器

（2）安装Nagios core和Nagios Plugins

按照Nagios Core源码安装指导文档来安装就行了， 包括Nagios Core和Nagios官方Plugins（有50个左右的插件，除了官方提供的插件，还能找到非常多的插件，用户也可以自定义一些插件）

安装步骤说明：https://assets.nagios.com/downloads/nagioscore/docs/Installing_Nagios_Core_From_Source.pdf#_ga=1.238050824.967072329.1490596661或者https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/quickstart.html

备注：安装Nagios-plugins时，一般将安装的目录设置为nagios的安装目录

（3）启动nagios daemon和apache webserver

首先执行/etc/init.d/nagios start启动nagios后台服务，然后执行/etc/init.d/httpd start启动apache服务器。

（4）Nagios的测试

用浏览器打开http://ip:port/nagios即可访问测试。效果如下：

![nagios界面图](/images/nagios_2_1.png)

# nagios安装后的目录结构

nagios安装后的目录结构图如下：

![nagios安装目录结构图](/images/nagios_2_2.png)

（1）bin目录是nagios的主程序和状态统计工具

（2）etc目录是nagios的各种配置文件存放的目录

（3）libexec一般是nagios的插件存放目录，当然插件亦可以安装到其他的目录

（4）sbin存放的是一些cgi脚本，nagios web界面上的数据展示或操作，会通过cgi脚本来执行

（5）share存放的nagios web的一些元素，如php，css等

（6）var是nagios的日志和状态数据的存放的目录，例如status.dat中存放的nagios的采集的最近的监控数据，当nagios停掉后，该文件会被删除。status.dat会被cgi脚本读取分析并展示到nagios WEB页面上。retention.dat存放也是最近的监控数据，当nagios停掉后，该文件继续存在，当nagios启动时，会读取retention.dat中的数据。nagios.log以及archives/nagios-*-*.log是nagios的运行日志，里面有nagios的采集到数据的日志，nagios的历史数据展示就是从nagios.log日志文件中爬出来的。

备注：我们可以看到，单纯的nagios的WEB UI上只会显示最近的一次采集状态，无法看到历史的状态信息，也无法有趋势图展示，尽管nagios有历史报表功能，也是从nagios.log中爬出来的，比较简陋。所以nagios必须结合其他第三方nagios的周边组件，才能构建强大的监控系统，只有nagios是不行的哦。

