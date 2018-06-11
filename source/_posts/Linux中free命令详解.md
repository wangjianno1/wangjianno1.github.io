---
title: Linux中free命令详解
date: 2018-06-11 11:06:17
tags:
categories: Linux
---

# free命令

下面是free的运行结果，一共有4行。为了方便说明，我加上了列号。这样可以把free的输出看成一个二维数组FO(Free Output)。例如：

                       1          2          3         4         5          6
    1              total       used       free    shared   buffers     cached
    2 Mem:      24677460   23276064    1401396         0    870540   12084008
    3 -/+ buffers/cache:   10321516   14355944
    4 Swap:     25151484     224188   24927296

通过二维数组的定义，我们可以很容易的得出：

    FO[2][1] = 24677460
    FO[3][2] = 10321516

free的输出一共有四行，第四行为交换区的信息（就是虚拟内存，所占用的空间是物理磁盘），分别是交换的总量（total），使用量（used）和有多少空闲的交换区（free），这个比较清楚，不说太多。

free输出地第二行和第三行是比较让人迷惑的。这两行都是说明内存使用情况的。第一列是总量（total），第二列是使用量（used），第三列是可用量（free）。

第一行的输出是从操作系统（OS）来看的。也就是说，从OS的角度来看，计算机上一共有:

    24677460KB（缺省时free的单位为KB）物理内存，即FO[2][1]；
    在这些物理内存中有23276064KB（即FO[2][2]）被使用了；
    还用1401396KB（即FO[2][3]）是可用的；

这里得到第一个等式：

    FO[2][1] = FO[2][2] + FO[2][3]

FO[2][4]表示被几个进程共享的内存的，现在已经deprecated，其值总是0（当然在一些系统上也可能不是0，主要取决于free命令是怎么实现的）。

FO[2][5]表示被OS buffer住的内存。FO[2][6]表示被OS cache的内存。在有些时候buffer和cache这两个词经常混用。不过在一些比较低层的软件里是要区分这两个词的，看老外的洋文:

    A buffer is something that has yet to be "written" to disk. 
    A cache is something that has been "read" from the disk and stored for later use.

也就是说buffer是用于存放要输出到disk（块设备）的数据的，而cache是存放从disk上读出的数据（就是os会将经常使用的数据先从磁盘上读取到内存上）。这二者是为了提高IO性能的，并由OS管理。

Linux和其他成熟的操作系统（例如windows），为了提高IO read的性能，总是要多cache一些数据，这也就是为什么FO[2][6]（cached memory）比较大，而FO[2][3]比较小的原因。

free输出的第二行是从一个应用程序的角度看系统内存的使用情况。

    对于FO[3][2]，即-buffers/cache，表示一个应用程序认为系统被用掉多少内存；
    对于FO[3][3]，即+buffers/cache，表示一个应用程序认为系统还有多少内存可以使用；

因为被系统cache和buffer占用的内存可以被快速回收，所以通常FO[3][3]比FO[2][3]会大很多。

这里还用两个等式：

    FO[3][2] = FO[2][2] - FO[2][5] - FO[2][6]
    FO[3][3] = FO[2][3] + FO[2][5] + FO[2][6]（很重要）

free命令的所有输出值都是从`/proc/meminfo`中读出的。

备注：使用free时，默认的单位是KB，我们可以使用如下选项来改变数值的单位：

```
-b   #数值单位是B
-k   #数值单位是KB
-m   #数值单位是MB
-g   #数值单位是GB
```

# linux平台释放buffer/cache内存资源

（1）释放buffer占用资源

执行`sync`命令，释放buffer占用的内存。sync命令将所有未写的系统缓冲区写到磁盘中，包含已修改的 i-node、已延迟的块I/O和读写映射文件。

（2）释放cache占用资源

```bash
echo 1 > /proc/sys/vm/drop_caches  #释放pagecache占用空间
echo 2 > /proc/sys/vm/drop_caches  #释放dentries和inodes占用空间
echo 3 > /proc/sys/vm/drop_caches  #释放pagecache、dentries和inodes占用空间
```

# 关于cache的一点补充

在实际的机器运维中，我们可能会看到某台服务器的cache占用很高，一般来说没有什么大问题。但是如果我们想弄清楚到底是哪个程序把cache弄的那么高，这并不是一件非常容易的事。不过可以借助一些第三方的工具来达到这个目的。

学习资料参考于：
http://www.cnblogs.com/coldplayerest/archive/2010/02/20/1669949.html
http://colobu.com/2017/03/07/what-is-in-linux-cached/
http://www.linuxfly.org/post/320/