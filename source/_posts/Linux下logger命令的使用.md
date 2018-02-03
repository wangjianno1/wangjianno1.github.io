---
title: Linux下logger命令的使用
date: 2018-02-04 01:43:19
tags:
categories: Linux
---

# logger

logger命令可以和系统的syslog模块交互，也就是logger命令产生的日志会通过syslog服务来记录。

# logger命令的使用

格式：
```bash
logger [options] message
```

重要参数如下：

	-p facility.level  #制定这条日志的facility和等级，syslogd可以依据此来记录这条日志，缺省的是user.notice

# 使用举例

```bash
logger this is test log
logger -p user.info this is test log
```
