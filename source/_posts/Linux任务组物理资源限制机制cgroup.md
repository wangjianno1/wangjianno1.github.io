---
title: Linux任务组物理资源限制机制cgroup
date: 2019-03-10 17:55:38
tags:
categories: Virtualization
---

# cgroup简介

cgroup是control groups的缩写，是Linux内核提供的一种可以限制、记录、隔离进程组（process groups）所使用的物力资源（如CPU、Memory及I/O等等）的机制。cgroups也是LXC为实现虚拟化所使用的资源管理手段。

cgroup提供了一个cgroup虚拟文件系统，作为进行分组管理和各子系统设置的用户接口。要使用cgroup，必须挂载cgroup文件系统。这时通过挂载选项指定使用哪个子系统。

Linux使用了多种数据结构在内核中实现了cgroups的配置，关联了进程和cgroups节点，那么Linux又是如何让用户态的进程使用到cgroups的功能呢？Linux内核有一个很强大的模块叫VFS（Virtual File System）。VFS能够把具体文件系统的细节隐藏起来，给用户态进程提供一个统一的文件系统API接口。cgroups也是通过VFS把功能暴露给用户态的，cgroups与VFS之间的衔接部分称之为cgroups文件系统。

# 常见的cgroup子系统

    blkio   #这个子系统为块设备设定输入/输出限制，比如物理设备（磁盘，固态硬盘，USB等等）
    cpu     #这个子系统使用调度程序提供对CPU的cgroup任务访问
    cpuacct #这个子系统自动生成cgroup中任务所使用的CPU报告
    cpuset  #这个子系统为cgroup中的任务分配独立CPU（在多核系统）和内存节点
    devices #这个子系统可允许或者拒绝cgroup中的任务访问设备
    freezer #这个子系统挂起或者恢复cgroup中的任务
    memory  #这个子系统设定cgroup中任务使用的内存限制，并自动生成由那些任务使用的内存资源报告
    net_cls #这个子系统使用等级识别符（classid）标记网络数据包，可允许Linux流量控制程序（tc）识别从具体cgroup中生成的数据包
    ns      #名称空间子系统

# cgroup层级图

假设我们将cpu子系统mount到了`/cgroup/cpu`上，memory子系统mount到了`/cgroup/memory`等等，那`/cgroup/cpu`和`/cgroup/memory`称为root-cgroup，该cgroup的资源限制策略对`/cgroup/cpu`和`/cgroup/memory`目录中tasks文件以及cgroup.procs文件中的进程ID和线程ID有效。我们还可以在`/cgroup/cpu`和`/cgroup/memory`下mkdir新的目录xx，以及xx的子目录，那么将形成新的子cgroup，子cgroup对相应的tasks文件以及cgroup.procs文件中的进程ID和线程ID有效。

![](/images/linux_cgroups_1_1.png)

# 其他闲杂知识

（1）使用`cat /proc/cgroups`可以查看当前系统中开启了哪些子系统。

（2）使用`cat /proc/${pid}/cgroup`可以查看进程号为pid的进程处在哪个cgroup中。

学习资料参考于：
[《linux cgroups概述》](http://xiezhenye.com/2013/10/linux-cgroups-%E6%A6%82%E8%BF%B0.html)
[《用cgroups管理CPU资源》](http://xiezhenye.com/2013/10/%e7%94%a8-cgroups-%e7%ae%a1%e7%90%86-cpu-%e8%b5%84%e6%ba%90.html)
[《用cgroups管理进程磁盘IO》](http://xiezhenye.com/2013/10/%e7%94%a8-cgroups-%e7%ae%a1%e7%90%86%e8%bf%9b%e7%a8%8b%e7%a3%81%e7%9b%98-io.html)
[《用cgruops管理进程内存占用》](http://xiezhenye.com/2013/10/%e7%94%a8-cgruops-%e7%ae%a1%e7%90%86%e8%bf%9b%e7%a8%8b%e5%86%85%e5%ad%98%e5%8d%a0%e7%94%a8.html)
http://www.ibm.com/developerworks/cn/linux/1506_cgroup/index.html
