---
title: dmesg命令使用
date: 2018-02-04 01:53:01
tags:
categories: Linux
---

# dmesg

kernel会将开机信息存储在ring buffer中，另外，也会保存在/var/log/dmesg的磁盘文件中。dmesg命令用于打印Linux系统开机启动信息，dmesg是从kernel ring buffer中读取开启启动信息，并不是从/var/log/dmesg文件中读取哦。

备注：/var/log/dmesg好像不是syslogd写入的。

# dmesg常见的用法

（1）查看看机信息

```bash
dmesg
```

（2）清除kernel ring buffer中的开机信息，并打印到控制台上

```bash
dmesg -c
```

备注：使用`dmesg -c`只会清除kernel ring buffer中的内容，并不会清除/var/log/dmesg，所以我们还是可以通过查看/var/log/dmesg文件来获取系统启动信息。
