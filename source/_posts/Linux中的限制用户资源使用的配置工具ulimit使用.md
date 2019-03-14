---
title: Linux中的限制用户资源使用的配置工具ulimit使用
date: 2018-02-04 00:46:10
tags:
categories: Linux
---

# ulimit

ulimit是一种简单并且有效的实现资源限制的方式。

ulimit用于限制shell启动进程所占用的资源，支持以下各种类型的限制：所创建的内核文件的大小、进程数据块的大小、Shell进程创建文件的大小、内存锁住的大小、常驻内存集的大小、打开文件描述符的数量、分配堆栈的最大大小、CPU时间、单个用户的最大线程数、Shell进程所能使用的最大虚拟内存。同时，它支持硬资源和软资源的限制。

作为临时限制，ulimit可以作用于通过使用其命令登录的shell会话，在会话终止时便结束限制，并不影响于其他shell会话。而对于长期的固定限制，ulimit命令语句又可以被添加到由登录shell读取的文件中，作用于特定的shell用户。

# ulimit命令格式及常用选项

命令格式如下：

```bash
ulimit [options] parameter
```

命令常用的参数有：

```bash
-H  #设置硬资源限制，即是一定不会超过配额值
-S  #设置软资源限制，即可以超过配额值，但若超过配额值会有警告信息
-a  #显示当前所有的limit信息
-c  #最大的core文件的大小， 以blocks为单位
-d  #进程最大的数据段的大小，以Kbytes为单位
-f  #进程可以创建文件的最大值，以blocks为单位
-l  #最大可加锁内存大小，以Kbytes为单位
-m  #最大内存大小，以Kbytes为单位
-n  #可以打开最大文件描述符的数量
-p  #管道缓冲区的大小，以Kbytes为单位
-s  #线程栈大小，以Kbytes为单位
-t  #最大的CPU占用时间，以秒为单位
-u  #用户最大可用的进程数
-v  #进程最大可用的虚拟内存，以Kbytes为单位
```

备注：我们可以通过`ulimit -a`命令的输出结果，来对应出每个配置项的参数

# ulimit命令使用举例

```bash
ulimit –Hs 64         #限制硬资源，线程栈大小为64K
ulimit –Sn 32         #限制软资源，32个文件描述符
ulimit -a             #显示当前所有的limit信息
ulimit -c unlimited   #对生成的core文件的大小不进行限制
ulimit -f 2048        #限制进程可以创建的最大文件大小为2048blocks
```

# ulimit的使用方式

（1）在命令行执行`ulimit [options] parameter`
在命令执行`ulimit [options] parameter`进行资源限制，是有其作用范围的。这种情况下，ulimit限制的是当前shell进程以及其派生的子进程。举例来说，如果用户同时运行了两个shell终端进程，只在其中一个环境中执行了`ulimit -s 100`，则该shell进程里创建文件的大小收到相应的限制，而同时另一个shell终端包括其上运行的子程序都不会受其影响。

备注：当然，退出终端，会话结束，bash退出，ulimit设定的限制也就不存在了。

（2）修改系统的`/etc/security/limits.conf`和`/etc/security/limits.d/*`配置文件

`/etc/security/limits`和`/etc/security/limits.d/*`文件是linux PAM（插入式认证模块，Pluggable Authentication Modules）中pam_limits.so的配置文件。pam_limits.so先加载`/etc/security/limits.conf`，如果`/etc/security/limits.d/`目录下还有配置文件的话，也会被加载一起分析。这就意味`/etc/security/limits.d/`里面的文件里面的配置会覆盖`/etc/security/limits.conf`的配置。通过修改`/etc/security/limits.conf`和`/etc/security/limits.d/*`文件不仅能限制指定用户的资源使用，还能限制指定组的资源使用。该文件的每一行都是对限定的一个描述，格式如下：
 
	<domain> <type> <item> <value>

其中domain表示用户或者组的名字，还可以使用`*`作为通配符。type可以有两个值，soft和hard。item则表示需要限定的资源，可以有很多候选值，如stack，cpu，nofile等等，分别表示最大的堆栈大小，占用的cpu时间，以及打开的文件数。通过添加对应的一行描述，则可以产生相应的限制。例如：

	* hard noflle 100       #该行配置语句限定了任意用户所能创建的最大文件数是100
	apache hard noflle 100  #限定了apache用户所能创建的最大文件数是100

备注：修改了/etc/security/limits.conf配置文件后，配置会直接生效，不用重启系统哦。

# ulimit与sysctl

使用ulimit只是对某个用户或用户组所使用系统资源进行限制。有时候，我们需要对整个系统或内核上的进行资源限制，这时我们可以选择借助systrl工具修改内核参数来达到这个目的，举例来说，内核参数`fs.file-max`代表系统范围内所有进程可打开的文件句柄的数量限制，内核参数`fs.nr_open`表示单个进程打开文件句柄数上限。

学习资料参考于：
https://www.ibm.com/developerworks/cn/linux/l-cn-ulimit/
