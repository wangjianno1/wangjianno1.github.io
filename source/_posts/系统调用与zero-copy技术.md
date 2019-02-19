---
title: 系统调用与zero copy技术
date: 2019-02-19 16:29:34
tags:
categories: OS
---

# 系统调用

操作系统提供了底层各种硬件资源的抽象层，应用程序必须通过这个抽象层来访问硬件资源。在抽象层之下就是操作系统的内核。

![](/images/os_zc_1_1.jpg)

当应用程序调用“系统调用”接口（如read、write、sendfile、fork以及exec等等）时，就会让应用程序从用户态切换到内核态，也就是执行内核的代码和数据。

# read和write系统调用

read是从磁盘读取数据的系统调用，write是向本地磁盘或socket写数据的系统调用。如下是应用程序从磁盘中读取数据，然后通过socket发送到网络中的一个系统调用过程：

![](/images/os_zc_1_2.jpg)

我们可以看到，通过read系统调用，操作系统使用DMA（Direct Memory Access）的方式把磁盘文件的数据从硬盘复制到了内核的缓冲区（也就是一段分配给内核的内存区域）， 然后又复制到了用户的缓冲区（也就是一段分配给上层应用程序的内存区域），这样read系统调用完成，返回到用户态 ，应用程序可以继续工作了。接下来，应用程序要通过socket发送数据，于是有向内核发起了write调用，再次进入内核态，内核又把用户缓冲区的数据复制到socket缓冲区（也是内核的内存区域）， write调用返回，返回用户态。网卡驱动会在一定的队列策略下，最终将数据发送到网络中去。

在这个例子中，我们发现一共发生了三次数据的复制，代价还是挺大的。

# sendfile系统调用及零拷贝zero copy技术

在上面read和write系统调用的例子中，我们发现内核空间和用户空间的数据发生了多次复制，系统开销大。其实我们可以使用`sendfile(socket, file, len)`系统调用，内核把数据从硬盘复制到内核缓冲区，同时会把数据在内核缓冲区的位置和数据长度等信息复制到socket缓冲区。在这个过程中其实只产生了一次复制，第二次复制只是将一些数据元信息复制到socket缓冲区，网卡驱动在发送数据时，其实还是使用的第一次的内核缓冲区中的数据啦。

在这个例子中，并没有发生数据从内核态空间和用户态空间的复制动作，我们称之为zero copy技术，即“零拷贝”技术啦。

![](/images/os_zc_1_3.jpg)

学习资料参考于：
码农翻身《操作系统和Web服务器那点事儿》——https://mp.weixin.qq.com/s?src=11×tamp=1544206393&ver=1283&signature=dpbbA0HjabqXDEWNjY0kO-wejYHf7pUNgpTuZCgYMc*giESDgjpG0rhX1qZnTYuhF0PQLkCmZz-hHlld1X71mcphRoeczn1hnbEiJaLvs4itVRCfl8bVV0isHxtiNhOA&new=1
