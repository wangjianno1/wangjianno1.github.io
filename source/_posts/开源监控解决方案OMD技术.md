---
title: 开源监控解决方案OMD技术
date: 2018-01-30 16:47:21
tags: OMD
categories: 监控
---

# OMD简介

OMD，英文全称是The Open Monitoring Distribution，OMD支持当前Centos的主流版本，同时也兼容RHEL的版本。 OMD是一套开源的监控套件，包含了多种开源的工具。简单概括如下：

（1）以Nagios为核心，用于任务的调度。

（2）Check_MK是基于Nagios的一个强力的扩展程序，接替Nagios负责数据采集和web管理（Nagios只做任务调度），集成了众多的监控插件/模板并支持目前主流的操作系统（Windows、Centos、Debian、FreeBSD等）

（3）通过pnp4nagios和RDDtool进行监控项目的绘图

（4）通过Nagvis和Thruk进行设备和网络拓扑的展示

# omd的版本及包含的组件

omd有两个版本，分别是Check_MK Raw Edition和OMD Labs-Edition。Check_MK Raw Edition版本其实就是Check_MK，下载地址会链接到Check_MK的官网。而OMD Labs-Edition包含了非常多的组件，如下：

![](/images/omd_1_1.png)

一般来说，我们使用Check_MK Raw Edition就好了。安装演示里面的OMD也是Check_MK Raw Edition。

备注：thruk仅仅是GUI，比nagios原生的GUI要好用一些，尤其在thruk做批量报警屏蔽灰常好用。

# omd的安装与配置

前提，这里安装测试的环境是RedHat Linux 6.8 + omd-1.20.rhel6.x86_64 + check_mk-agent-1.2.4p5-1

（1）下载omd rpm包并在服务端安装

在http://files.omdistro.org/releases/centos_rhel/上下载omd的安装，然后执行rpm -ivh omd-*.rpm。之后会提示一些依赖包需要安装，直接执行命令yum install XXX即可（应该会提示安装httpd，直接yum install httpd即可）。

omd默认安装到/opt/omd目录中，其生成的目录结构为：

![](/images/omd_1_2.png)

并且创建一个软链/omd，目标链接到/opt/omd.

其中apache目录只存放一个apache虚机host的配置文件；versions目录存放的是OMD的bin/lib/man文档等等；sites是使用omd create命令创建出来的site，里面会有该site的bin/conf/lib等等（bin是直接软链到versions目录下的bin）。

（2）使用omd命令生成站点并启动站点

使用omd create xxx命令来创建一个站点site，会生成/omd/sites/xxx站点：

![](/images/omd_1_3.png)

使用omd start用来启动站点所有服务，包括apache，nagios等。

（3）下载check_mk agent rpm包并在客户端安装，修改配置并启动

在Check_MK的WATO配置中，找到Monitoring Agents，然后在面板中可以直接下载Check_mk agent。而对于老版本的Check_MK（例如1.2.4p5），在WATO界面中找不到Monitoring Agents选项，可以使用链接http://mathias-kettner.de/download/check_mk-agent-1.2.4p5-1.noarch.rpm下载check_mk-agent，并安装。check_mk agent是以xinitd的进程存在，agent监听的端口是6556。

（4）Web-GUI界面登录

访问地址http://HOSTNAME/my-omdsite-name/omd/即可访问，其中check_mk的缺省账号和密码分别为omdadmin和omd。

（5）在omd的check_mk界面WATO中添加主机和服务，并刷新WATO配置

若check_mk agent没有部署，那么为host添加service监控时，会报如下错误：

![](/images/omd_1_4.png)

# omd的服务进程

默认情况下，执行omd start命令后，会启动如下的服务：

![](/images/omd_1_5.png)

下面分别简单说明下：

（1）npcd，全称为Nagios-Perfdata-C-Daemon，是专门用来处理性能数据的。

（2）nagios

（3）rrdcached

rrdcached是一个常驻内存的进程，用来接收更新RRD数据的请求，如果请求积累到一定数据或超过一定的时间，rrdcached才会一次性的去更新RRD文件，这种方式主要是来缓存磁盘的IO压力。

（4）apache

（5）mkeventd

Event Console是由mkeventd后台进程来控制的。

# omd及check_mk的一些常用操作命令

omd可以使用的命令有：

```bash
omd version   #查看omd的版本
omd sites     #查看本机上所有omd创建的站点
omd status    #查看omd管理服务的状态
omd restart   #重启omd管理的服务
omd create sitename  #创建一个名称为sitename的omd站点
omd start sitename    #启动名称为sitename的omd站点，该命令会启动一系列命令，包括httpd、nagios、check_mk等等
```

su - OMD-user && cd /omd/sites/XXX，然后可以执行很多check_mk的命令，举例来说：

```bash
./bin/check_mk -l    #查看check_mk中配置的所有主机host列表
./bin/check_mk -L    #可以查看check_mk支持的所有采集项
./bin/check_mk -d HOSTNAME|IPADDRESS        #输出指定check-mk agent的原始输出，每一项以<<<XXX>>>开头
./bin/check_mk --checks=mem.used -I s1531   #从check-mk agent s1531中获取filecount.temp采集项的值，并存储到check_mk服务端，注意并会将采集值打印到终端屏幕上
./bin/check_mk -nv s1531   #查看指定agent的所有hosts/services最新的监控状态，会将结果打印到终端屏幕上
./bin/check_mk -p -v --checks=mem.used -I s1531  #采集指定项目，并存储到check_mk服务端
```

6.omd中一些重要的目录备注

```
/omd/sites/XXX/local/share/check_mk/checks  #服务端用来解析客户端采集的数据
/usr/lib/check_mk_agent/plugins             #check_mk agent端采集检测脚本
/omd/sites/XXX/var/check_mk/precompiled     #这里面是预编译的脚本，check_mk向check_mk agent采集数据就是通过该目录下面的脚本来完成的。每一个host对应一个python脚本和二进制文件，当我们修改某个host的监控配置时，会自动重新编译该脚本。另外，若手动删除了某个host的脚本，那么将采集不到对应host的监控值，参见下图
/omd/sites/XXX/lib/nagios/plugins           #是nagios各种插件的安装位置
/omd/sites/XXX/etc/check_mk/conf.d/wato     #使用check_mk的WATO生成的配置所在的目录
/omd/sites/XXX/var/pnp4nagios/perfdata/     #perf性能的rrd文件的存储路径
/omd/sites/XXX/var/                         #各种监控数据存放的位置，灰常重要
/omd/sites/XXX/tmp/nagios/status.dat        #omd中nagios组件界面的状态文件status.dat
/omd/sites/XXX/tmp/check_mk/cache           #该目录存放的是从check_mk-agent获取到的最新的结果，每个host对应一个文件
/omd/sites/XXX/local                        #目录存放的是用户自定义的一些脚本或配置，例如短信/微信报警、用户自定义的check_mk采集等等
```

/omd/sites/XXX/var/check_mk/precompiled中预编译脚本的引用：

![](/images/omd_1_6.png)


学习资料参考于：
http://www.jianshu.com/p/11fb320816ab
