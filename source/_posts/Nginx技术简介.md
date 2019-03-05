---
title: Nginx技术简介
date: 2019-03-05 15:48:06
tags:
categories: Nginx
---

# Nginx简介
Nginx集web服务器、负载均衡、cache三种能力于一身。Nginx和Apache类似，采用的模块化设计，Nginx的模块分为内置模块和第三方模块。其中Nginx的内置模块有从功能上可以划分为：

（1）Nginx核心类模块

包括Nginx的内核模块和事件驱动events模块等。

（2）Nginx邮件类模块

包括Mail的内核模块和相关的额认证、代理，以及提供POP3、IMAP和SMTP的SSL模块。

（3）HTTP服务类模块

包括HTTP的内核模块http_core、代理模块http_proxy、负载均衡模块http_upstream等。

（4）4层代理stream类模块

包括stream的内核模块stream_core、代理模块stream_proxy、负载均衡模块stream_upstream等。

另外，Nginx plus是Nginx的商业版本，从2013年开始发布Nginx plus。Nginx plus对比开源版本重点增加了若干企业特性，包括更完善的七层、四层负载均衡、会话保持、健康检查以及实时监控和管理等。

# Nginx的进程模型

Nginx有两类进程，一类称为Master进程(相当于管理进程)，另一类称为Worker进程（实际工作进程）。启动方式有两种：

（1）单进程启动

此时系统中仅有一个进程，该进程既充当Master进程的角色，也充当Worker进程的角色。

（2）多进程启动

此时系统有且仅有一个Master进程，至少有一个Worker进程工作。Master进程主要进行一些全局性的初始化工作、绑定端口以及创建管理Worker进程等工作。Worker进程才是执行所有实际任务的进程，包括响应HTTP请求、处理网络连接、读取和写入内容到磁盘，与上游服务器通信等。

![](/images/nginx_analy_1_1.png)

另外，需要注意的是，如果Nginx开启了cache功能，那么Nginx还将启动两个cache相关的进程：

（1）cache manager process

缓存管理进程（cache manager process）周期性运行，并削减磁盘缓存（prunes entries from the disk caches），以使其保持在配置范围内。

（2）cache loader process

缓存加载进程（cache loader process）在启动时运行，把基于磁盘的缓存（disk-based cache）加载到内存中，然后退出。对它的调度很谨慎，所以其资源需求很低。

对于Nginx来说，cache manager process和cache loader process是两个特殊的Worker进程。


# Nginx的配置文件结构

Nginx的配置文件分为如下几个部分：

（1）全局配置

这是一些nginx的全局配置，例如user、worker_processes等配置。

（2）event配置

event主要用来定义Nginx的工作模块。

（3）http配置

http配置主要是提供一些web功能。例如http中包括了server配置，而server就是用来设置虚拟主机的，可以为Nginx配置多个server。

Nginx的主配置文件的大致结构如下：

```
#设置用户组
user nobody;
#启动子进程数
worker_processes 2;
......

events {
    #每个进程可以处理的连接数，受系统文件句柄的限制
    worker_connections 1024;
    ……
}

http {
    #mine.types为文件类型定义文件
    include mine.types;
    #是否采取压缩功能，将页面压缩后传输更节省流量
    gzip on;
    #使用sever定义虚拟主机
    server {
        #服务器监听的端口
        listen 80;
        #对URL进行匹配
        location / {
            ……
        }
    }
    #使用sever定义其他虚拟主机
    server {
        #服务器监听的端口
        listen 80;
        #对URL进行匹配
        location / {
            ……
        }
    }
}
```

