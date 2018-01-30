---
title: check_mk系列（2）_check_mk-agent
date: 2018-01-30 15:27:55
tags: check_mk
categories: 监控
---

# check_mk agent简介

使用check_mk，需要在被监控主机上安装一个check_mk-agent rpm包。check_mk-agent rpm包会在主机上安装如下文件：

![](/images/check_mk_2_1.png)

下面分别说明几个主要文件的用途：

（1）/usr/bin/check_mk_agent是check_mk agent的主程序，它是一个shell脚本。用来收集监控信息，将信息事先提取后，等待check_mk端来获取数据。

（2）/etc/xinetd.d/check_mk为xinetd下的服务配置文件，用于守护check_mk_agent进程，并使agent监听tcp 6556端口，用来和check_mk服务端建立TCP连接。

（3）/usr/bin/waitmax会被check_mk_agent shell脚本调用，waitmax主要用于容错处理，当agent执行一些命令或脚本采集数据时陷入僵死或长时间等待时，waitmax可以在超过一定的时间后强行终止程序。

（4）/usr/lib/check_mk_agent/plugins目录用于存放用户自定义的采集脚本。

备注：

（1）在被监控主机上，直接执行/usr/bin/check_mk_agent脚本，即可输出各种采集数据。我们可以读取/usr/bin/check_mk_agent脚本来了解每个采集项的获取方式，一般来说是读取/proc内存中的数值。

（2）可以使用telnet HOSTNAME 6556命令，连接任何一台安装有check_mk agent的机器，即可获取到check_mk agent的采集数据。


学习资料参考于：
http://www.361way.com/check_mk-cs-data-interaction/4255.html
