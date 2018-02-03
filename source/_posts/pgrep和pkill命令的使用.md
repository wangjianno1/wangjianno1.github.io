---
title: pgrep和pkill命令的使用
date: 2018-02-04 00:24:12
tags:
categories: Linux
---

# pgrep与pkill

pgrep和pkill是类似的，pgrep是通过进程的名称或其他属性查找进程，将满足条件的所有进程的PID列出来。pkill除了可以完成pgrep的功能，还能向匹配到的进程发送信号。

# pgrep和pkill命令使用举例

```bash
pgrep named           #列出名称为named的所有进程的进程号
pgrep -u root sshd    #列出所有进程名为sshd，且属于root用户的进程的进程号
pgrep -u root,daemon  #列出所有属于root或daemon用户的进程的进程号
pkill -HUP syslog     #向名称为syslog的所有进程发送SIGHUP信号
```

