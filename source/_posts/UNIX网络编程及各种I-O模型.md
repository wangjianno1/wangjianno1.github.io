---
title: UNIX网络编程及各种I/O模型
date: 2019-03-03 11:36:14
tags:
categories: OS
---

# UNIX网络编程概述

在UNIX网络编程中，同时有大量的客户端连接到同一个服务器上时，服务端一般对每一个客户端请求fork出一个进程来响应处理，或者对每一个客户端创建出一个线程来响应处理。

# 最基础的TCP网络编程

![](/images/unix_io_1_1.png)

（1）socket函数

socket()函数用于在客户端或服务端创建一个socket对象，sockect函数的定义如下：

```c
#include<sys/socket.h>
int socket(int family, int type, int protocol);  //若成功则返回非负整数，即为socket的文件描述符fd。若失败则返回-1
```

（2）connect函数

客户端使用connect函数来建立与服务端的连接，connect函数的定义如下：

```c
#include<sys/socket.h>
int connect(int sockfd, const struct sockaddr * servaddr, socklen_t addrlen);  //若成功则返回0，若失败则返回-1
```

（3）bind函数

服务端使用bind函数绑定到ip地址和端口。

（4）listen函数

listen函数将套接字的状态从CLOSED转换到LISTEN状态。

（5）accept函数

阻塞函数。服务端调用，用于获取与客户端的连接，该函数会导致进程或线程阻塞，直至有客户端连接进来。accept函数定义如下：

```c
#include<sys/socket.h>
int accept(int sockfd, struct sockaddr * cliaddr, socklen_t * addrlen);  //若accept成功，则返回一个全新的文件描述符，代表着与客户端的网络连接
```

（6）read函数

阻塞函数，直到read函数结束返回，才执行下一条代码。

（7）write函数

阻塞函数，直到write函数结束返回，才执行下一条代码。

# UNIX的I/O模型

UNIX下有5种I/O模型。

## 阻塞式I/O

最流行的I/O模型是阻塞式I/O（blocking I/O）模型。

![](/images/unix_io_1_2.png)

在上图中，进程调用recvfrom，该系统调用直到数据报文到达且被复制到应用进程的缓冲区中或者发生错误才返回，因此，应用进程在从调用recvfrom开始到它返回的整段时间内是被阻塞的，recvfrom成功返回后，应用进程才开始处理数据报。

## 非阻塞式I/O

下图是非阻塞式I/O（non blocking I/O）模型的示意图：

![](/images/unix_io_1_3.png)

前三次调用recvfrom时没有数据可返回，因此内核立即返回一个EWOULDBLOCK错误，第四次调用recvfrom时已有一个数据报准备好，它被复制到应用进程缓冲区，于是recvfrom成功返回，应用进程接着处理数据。

当一个应用进程像这样对一个非阻塞描述符循环调用recvfrom时，我们称之为轮询polling。应用进程持续轮询内核，以查看某个操作是否就绪。这么做往往耗费大量CPU时间。

## I/O复用（select/poll/epoll）

有了I/O复用（I/O multiplexing），我们就可以调用select和poll，那么应用进程会阻塞在select或poll系统调用上，而不是阻塞在真正的I/O系统调用上。如下图：

![](/images/unix_io_1_4.png)

应用进程阻塞在select系统调用，等待数据报套接字变为可读。当select返回套接字可读这一条件时，我们调用recvfrom把所读数据报复制到应用进程的缓冲区。

## 信号驱动式I/O（SIGIO）

应用进程可以让内核在描述符就绪时发送SIGIO信号给应用进程，我们称这种模型为信号驱动式I/O模型，即signal-driven I/O模型。如下图：

![](/images/unix_io_1_5.png)

应用进程首先开启套接字的信号驱动式I/O功能，并通过sigaction系统调用安装一个信号处理函数。该系统调用将立即返回，我们的进程继续工作，也就是说应用进程并没有被阻塞。当数据报准备好读取时，内核就为该进程产生一个SIGIO信号，应用进程虽后就可以在信号处理函数中调用recvfrom读取数据报。

## 异步I/O（POSIX的`aio_*`系列函数）

异步I/O模型，asynchronous I/O。如下图：

![](/images/unix_io_1_6.png)

首先应用进程告知内核启动某个操作，并让内核在整个操作（包括将数据从内核复制到应用进程的缓冲区）完成后通知应用进程。与信号驱动式I/O不同的是，信号驱动式I/O是由内核通知应用进程何时可以启动一个I/O操作，而异步I/O模型是由内核通知我们I/O操作何时完成。

应用进程调用aio_read函数，给内核传递描述符、缓冲区指针、缓冲区大小和文件偏移，并告诉内核当整个操作完成时如何通知我们。aio_read系统调用立即返回，而且在等待I/O完成期间，我们的应用进程不被阻塞。

# UNIX中五种I/O模型的异同

![](/images/unix_io_1_7.png)

前四种模型都会导致应用进程阻塞，我们称他们为“同步IO模型”，因为他们的真正I/O操作recvfrom会阻塞应用进程。只有第五种模型才是“异步IO模型”，因为自始至终都没有因为I/O操作导致应用进程被阻塞。

# 一点概念理解

同步，异步，阻塞以及非阻塞等概念相对难理解。

所谓同步/异步是客户端和服务端之间交互的一种行为状态，**是描述被调用方的**。同步就是在发出一个调用时，在没有得到结果之前，该调用就不返回，但是一旦调用返回，就得到返回值了。换句话说，就是由调用者主动等待这个调用的结果。而异步则是相反，调用在发出之后，这个调用就直接返回了，所以没有返回结果。换句话说，当一个异步过程调用发出后，调用者不会立刻得到结果。而是在调用发出后，被调用者通过状态信号来通知调用者，或通过回调函数处理这个调用。

所谓阻塞/非阻塞是客户端一种调用发出后的一种状态，**是描述调用方的**。阻塞调用是指调用结果返回之前，调用者会被挂起，调用线程只有在得到结果之后才会返回。非阻塞调用指在不能立刻得到结果之前，该调用不会阻塞当前线程。

举个简单的例子，老张烧水。

（1）老张把水壶放到火上，一直在水壶旁等着水开。（这是同步阻塞）

（2）老张把水壶放到火上，去客厅看电视，时不时去厨房看看水开没有。（这是同步非阻塞）

（3）老张把响水壶放到火上，一直在水壶旁等着水开。（这是异步阻塞） 

（4）老张把响水壶放到火上，去客厅看电视，水壶响之前不再去看它了，响了再去拿壶。（这是异步非阻塞）

1和2的区别是，调用方在得到返回之前所做的事情不一样。1和3的区别是，被调用方对于烧水的处理不一样。

同步就是烧开水，要自己来看开没开；异步就是水开了，然后水壶响了通知你水开了。阻塞是烧开水的过程中，你不能干其他事情（即你被阻塞住了）；非阻塞是烧开水的过程里可以干其他事情。同步与异步说的是你获得水开了的方式不同。阻塞与非阻塞说的是你得到结果之前能不能干其他事情。两组概念描述的是不同的内容。

# 网络编程的线程/进程模型

## 传统的线程/进程模型

```java
// 传统模型1：单线程模式，无法并发，如果当前的请求没有处理完，那么后面的请求只能被阻塞，服务器的吞吐量太低。
while(true){
    socket = accept();
    handle(socket);
}

// 传统模型2：多线程模式，connection per thread，每一个连接用一个线程处理。
while(true){
    socket = accept();
    new Thread(socket);
}

// 传统模型3：线程池模式，减少了线程的反复创建和销毁，但本质上一个线程还是要完整的处理连接、读取、写入
while(true){
    socket = accept();
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.execute(new Thread(socket));
}
```

## Reactor模型

基于I/O多路复用和线程池，就是所谓的"Reactor模型"的基本设计思想。

以Java的NIO库来说，Java nio的select函数，可以同时监听多个套接字socket。每个socket都会关联连接event、读取event、回写event。然后把一个线程拆分成更小的粒度：建立连接的handler、读取数据的handler、回写数据的hander。handler处理完event就丢给下一个handler处理，自己又可以去服务socket，提高了复用率，提高了系统的吞吐量。

Reactor模型由分为单Reactor单线程、单Reactor多线程和多Reactor多线程三种模型。

（1）单Reactor单线程

![](/images/unix_io_1_8.png)

（2）单Reactor多线程

![](/images/unix_io_1_9.png)

（3）多Reactor多线程

![](/images/unix_io_1_10.png)

## Proactor模型

基于异步IO模型。

学习资料参考于：
《UNIX网络编程卷1：套接字联网API》
https://blog.csdn.net/wangjianno2/article/details/45609863
https://blog.csdn.net/wangjianno2/article/details/38157057
