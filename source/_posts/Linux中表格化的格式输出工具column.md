---
title: Linux中表格化的格式输出工具column
date: 2018-02-04 00:19:41
tags:
categories: Linux
---

# column命令

linux有些命令的输出，因为字符串过度拥挤导致输出内容难以识别，例如mount命令。而column命令可以将一些命令的输出内容以表格的形式显示出来。

column命名默认以空格符来作为表格字段拆分，当然可以通过-s参数显式地指定分割符。

# column命令使用举例

```bash
mount | column -t                  #将mount命令的输出用表格的形式打印出来
cat /etc/passwd | column -t -s :   #将文件/etc/passwd中的每行内容以冒号(:)分割开来，并以表格的方式打印出来
```
