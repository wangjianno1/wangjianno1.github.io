---
title: Linux下run-parts命令
date: 2018-02-04 01:47:29
tags:
categories: Linux
---

# run-parts

在Centos5下，run-parts命令工具的绝对路径是/usr/bin/run-parts，内容是很简单的一个shell脚本，就是遍历目标文件夹，执行第一层目录下的可执行权限的文件，其他非可执行文件和子目录下的文件不会被执行。举例来说：`run-parts /home/wahaha`。

在ubuntu下，该文件位于/bin/run-parts，是个二进制文件，功能更为强大，支持--test等命令参数。

# run-parts的应用场景

我们可以直接使用run-parts工具来执行某个目录中的所有可执行文件，但通常run-parts被用到crontab中。以Centos来说，系统中有/etc/cron.hourly，/etc/cron.daily，/etc/cron.weekly以及/etc/cron.monthly等目录，我们可以在/etc/crontab中通过配置`01 * * * * root run-parts /etc/cron.hourly`，来达到每小时执行一次/etc/cron.hourly目录中的可执行文件的效果。

