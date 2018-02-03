---
title: Linux日志滚动或日志切割工具logrotate
date: 2018-02-04 01:30:08
tags:
categories: Linux
---

# logrotate简介

logrotate程序是一个日志文件管理工具，用于分割日志文件，删除旧的日志文件，并创建新的日志文件，起到“转储”作用。可以节省磁盘空间。日志切割的过程是，比如以系统日志/var/log/messages做切割来简单说明下：

	第一次执行完rotate之后，原本的messages会变成messages.1，而且会制造一个空的messages给系统来储存日志；
	第二次执行之后，messages.1会变成messages.2，而messages会变成messages.1，又造成一个空的messages来储存日志；
	如果仅设定保留三个日志（即轮转3次）的话，那么执行第三次时，则messages.3这个档案就会被删除，并由后面的较新的保存日志所取代，也就是会保存最新的几个日志。

logrotate不是一个常驻内存的后台服务，而是依赖crontab来执行，/etc/cron.daily/logrotate中配置了`/usr/sbin/logrotate /etc/logrotate.conf`，所有logrotate是有crontab来调度执行的。当然我们也可以通过`logrotate /etc/logrotate.conf`命令来手动执行。

logrotate命令常用的选项有：

	-d —— 调试模式，logrotate会打印执行过程，但不会真正去切割日志。另外，-d隐含了-v参数
	-v —— 打印logrotate详细执行过程
	-f —— 比如logrotate.conf中配置某个日志按周切割，现在还没有一周，此时当我们手动执行logrotate时，因为时间条件不满足，是不会切割日志的。当加上-f参数后，就会去强制切割日志

logrotate命令使用举例：

```bash
logrotate /etc/logrotate.conf
logrotate -d /etc/logrotate.conf
logrotate -v /etc/logrotate.conf
logrotate -vf /etc/logrotate.conf
```

# logrotate的配置

logrotate是linux系统默认安装的工具，logrotate的配置文件是/etc/logrotate.conf和/etc/logrotate.d/*，其中/etc/logrotate.conf是logrotate的主要的配置文件，/etc/logrotate.d/是一个目录，该目录里的所有文件都会被include指令加入/etc/logrotate.conf中。/etc/logrotate.d/目录可以放入一些我们针对某些日志单独配置的切割配置。/etc/logrotate.d/中会以/etc/logrotate.conf中配置作为默认值，另外，/etc/logrotate.d/中配置会覆盖/etc/logrotate.conf的配置。

如下为logrotate.conf的一些重要配置指令：

```bash
compress                  # 通过gzip 压缩转储以后的日志
nocompress                # 不做gzip压缩处理
copytruncate              # 用于还在打开中的日志文件，把当前日志备份并截断；是先拷贝再清空的方式，拷贝和清空之间有一个时间差，可能会丢失部分日志数据
nocopytruncate            # 备份日志文件不过不截断
create mode owner group   # 轮转时指定创建新文件的属性，如create 0777 nobody nobody
nocreate                  # 不建立新的日志文件
delaycompress             # 和compress一起使用时，转储的日志文件到下一次转储时才压缩
nodelaycompress           # 覆盖 delaycompress 选项，转储同时压缩。
missingok                 # 如果日志丢失，不报错继续滚动下一个日志
errors address            # 专储时的错误信息发送到指定的Email 地址
ifempty                   # 即使日志文件为空文件也做轮转，这个是logrotate的缺省选项。
notifempty                # 当日志文件为空时，不进行轮转
mail address              # 把转储的日志文件发送到指定的E-mail 地址
nomail                    # 转储时不发送日志文件
olddir directory          # 转储后的日志文件放入指定的目录，必须和当前日志文件在同一个文件系统
noolddir                  # 转储后的日志文件和当前日志文件放在同一个目录下
sharedscripts             # 运行postrotate脚本，作用是在所有日志都轮转后统一执行一次脚本。如果没有配置这个，那么每个日志轮转后都会执行一次脚本
prerotate                 # 在logrotate转储之前需要执行的指令，例如修改文件的属性等动作；必须独立成行
postrotate                # 在logrotate转储之后需要执行的指令，例如重新启动 (kill -HUP) 某个服务！必须独立成行
daily                     # 指定转储周期为每天
weekly                    # 指定转储周期为每周
monthly                   # 指定转储周期为每月
rotate count              # 指定日志文件删除之前转储的次数，0 指没有备份，5 指保留5 个备份
dateext                   # 使用当期日期作为命名格式
```

如下举例来说明logrotate的配置方法：

```bash
[root@master-server ~]# vim /etc/logrotate.d/nginx
/usr/local/nginx/logs/*.log {
daily
rotate 7
missingok
notifempty
dateext
sharedscripts
postrotate
    if [ -f /usr/local/nginx/logs/nginx.pid ]; then
        kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
    fi
endscript
}
```

# logrotate切割日志的原理

logrotate的日志切割方式有两种：

（1）create模式

即“先move再touch”的过程。首先先将当前日志文件重命名为一个新的文件，然后再touch出一个新的文件。例如/var/log/messages，先将messages文件move为messages.1，然后再touch出一个新的messages文件。值得注意的是，进程读写文件是通过inode，所以move走原始日志文件后，进程还是会向该文件输出日志。所以必须让进程重新打开日志，最简单粗暴的方式就是重启进程。

备注：使用create指令就是使用该种方式rotate日志

（2）copytruncate模式

即“先copy再truncate”的过程。首先先将当前日志文件copy，然后再置空当前日志文件。例如/var/log/messages，先用messges拷贝出一个新的文件messages.1，然后把messages置空。这样程序会继续往/var/log/messages中打印日志。值得注意是，该种方式下，在拷贝和置空的间隙可能会丢失一少部分日志。

备注：使用copytruncate指令就是使用该种方式rotate日志，配置了copytruncate指令后，create指令就会失效，二者是互斥的。

# logrotate的最佳实践

（1）一般来说，我们不把日志轮替的规则全部配置在/etc/logrotate.conf中，而是配置到/etc/logrotate.d/下某个文件中，然后在/etc/logrotate.conf中通过include指令将配置文件引入进来即可。


学习资料参考于：
http://www.cnblogs.com/kevingrace/p/6307298.html
