---
title: Linux中的strace|pstack工具的使用
date: 2018-02-24 17:15:21
tags:
categories: Linux
---

# strace

使用strace工具可以追踪一个命令或进程在执行期间的系统调用和信号接收的情况。也就是进程和os打交道的一些过程。

strace命令的执行格式：

```bash
strace command
strace -p pid   #使用strace attach到pid进程上
```

strace常用的选项：

	-p pid       #指定待attach进程的进程号
	-o filename  #指定strace命令的执行结果输出到指定的文件中
	-ff          #配合-o使用，将不同进程的trace结果，输出到以进程号为后缀的文件filename.pid中

使用举例：

```bash
strace rm output.log  #查看rm命令在执行过程中有哪些系统调用
```

# pstack

pstack可以打印出一个进程当前的堆栈信息，如果这个进程包含有多个线程，那么每个线程的堆栈信息都会被打印。

pstack命令执行格式：

```bash
pstack pid
```

学习参考资料来源：
http://www.dbabeta.com/2009/strace.html