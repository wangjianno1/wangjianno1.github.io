---
title: Linux运行时动态调整内核参数工具sysctl工具
date: 2019-03-14 12:19:01
tags:
categories: Linux
---

# sysctl工具简介

sysctl命令被用于在内核运行时动态地修改内核的运行参数，可用的内核参数在目录`/proc/sys`中。它包含一些TCP/IP堆栈和虚拟内存系统的高级选项， 这可以让有经验的管理员提高引人注目的系统性能。用sysctl可以读取设置超过五百个系统变量。

通过sysctl工具有两种方式修改内核参数：

（1）直接使用sysctl命令

直接执行`sysctl -w key=value`命令去修改内核参数。需要注意，这种方式只在内存中有效，机器重启后就失效了。

（2）修改/etc/sysctl.conf配置文件

sysctl命令的配置文件是`/etc/sysctl.conf`，我们可以直接修改`/etc/sysctl.conf`这个配置文件，然后执行`sysctl -p`命令将配置文件中的内容加载到内存。建议使用这种方式，机器重启后仍然有效。

# 命令使用格式

```bash
sysctl [options] parameters
```

常用的选项：

    -w #当改变sysctl设置时使用此项
    -p #加载指定的配置文件中的内核参数，默认是/etc/sysctl.conf
    -a #打印当前所有可用的内核参数变量和值
    -A #以表格方式打印当前所有可用的内核参数变量和值

# 常用操作举例

```bash
sysctl -a                           #查看所有可读变量
sysctl kernel.hostname              #查看指定变量的设置，输出为key=value形式
sysctl -n kernel.hostname           #查看指定变量的设置，只输出变量的值
sysctl -w kernel.hostname=testhost  #修改的是内存中的主机名
```

学习资料来源于：
http://man.linuxde.net/sysctl
