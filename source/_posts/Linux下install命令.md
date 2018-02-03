---
title: Linux下install命令
date: 2018-02-04 01:27:59
tags:
categories: Linux
---

# install命令

install和cp类似，都可以将文件/目录拷贝到指定的地点。但是，install允许你控制目标文件的属性。install通常用于程序的makefile（在RPM的spec里面也经常用到），使用它来将程序拷贝到目标（安装）目录。

# install命令的使用

install的使用格式：

```bash
install [OPTION] [-T] SOURCE DEST
install [OPTION] SOURCE DIRECTORY
install [OPTION] -t DIRECTORY SOURCE
install [OPTION] -d DIRECTORY
```

install命令常用选项：

	-p —— 安装文件时，保留原来的文件的时间戳属性
	-m —— 自行设置权限，而不是默认的rwxr-xr-x
	-D —— 创建目的地前的所有目录，然后将来源复制到目的地
