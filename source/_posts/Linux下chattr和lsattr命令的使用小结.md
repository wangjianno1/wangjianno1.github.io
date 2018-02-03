---
title: Linux下chattr和lsattr命令的使用小结
date: 2018-02-04 01:20:46
tags:
categories: Linux
---

# chattr/lsattr简介

chattr命令的作用很大，其中一些功能是由Linux内核版本来支持的，不过现在生产绝大部分跑的linux系统都是2.6以上内核了。通过chattr命令修改属性能够提高系统的安全性，但是它并不适合所有的目录。chattr命令不能保护/、/dev、/tmp、/var目录。lsattr命令是显示chattr命令设置的文件属性。

这两个命令是用来查看和改变文件、目录属性的，与chmod这个命令相比，chmod只是改变文件的读写、执行权限，更底层的属性控制是由chattr来改变的。

# chattr的使用

命令使用格式：

```bash
chattr [ -RVf ] [ -v version ] [ mode ] files…
```

备注：最关键的是在[mode]部分，[mode]部分是由+-=和[acdeijstuADST]这些字符组合的，这部分是用来控制文件的 属性。

# chattr/lsattr可查看和设置的一些属性

	i —— 设定该属性后，文件不能被删除、改名、设定链接关系，同时不能写入或新增内容。i参数对于文件 系统的安全设置有很大帮助
	a —— 即append，设定该属性后，只能向文件中添加数据，而不能删除，多用于服务器日志文件安全，只有root才能设定这个属性

# chattr/lsattr命令使用举例

```bash
chattr +i file1  #给file1增加i属性
chattr -i file1  #去掉file1的i属性
chattr +a file1  #给file1增加a属性
chattr -a file1  #去掉file1的a属性
lsattr file1
```


学习资料参考于：
http://www.ha97.com/5172.html
