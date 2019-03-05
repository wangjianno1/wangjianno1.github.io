---
title: Nginx缓存原理及配置
date: 2019-03-05 22:59:52
tags:
categories: Nginx
---

# Nginx缓存简介

Nginx的http_proxy模块，可以实现类似于Squid的缓存功能。Nginx对客户已经访问过的内容在Nginx服务器本地建立副本，这样在一段时间内再次访问该数据，就不需要通过Nginx服务器再次向后端服务器发出请求，所以能够减少Nginx服务器与后端服务器之间的网络流量，减轻网络拥塞，同时还能减小数据传输延迟，提高用户访问速度。同时，当后端服务器宕机时，Nginx服务器上的副本资源还能够回应相关的用户请求，这样能够提高后端服务器的鲁棒性。

# Nginx cache基本配置

```
proxy_cache_path /path/to/cache levels=1:2 keys_zone=my_cache:10m max_size=10g inactive=60m use_temp_path=off;
server {
    set $upstream http://ip:port
    location / {
        proxy_cache my_cache;
        proxy_pass $upstream;
    }
}
```

配置项说明如下：

（1）/path/to/cache

本地路径，用来设置Nginx缓存资源的存放地址。

（2）levels

默认所有缓存文件都放在同一个/path/to/cache下，但是会影响缓存的性能，因此通常会在/path/to/cache下面建立子目录用来分别存放不同的文件。假设`levels=1:2`，Nginx为将要缓存的资源生成的key为f4cd0fbc769e94925ec5540b6a4136d0，那么key的最后一位0，以及倒数第2-3位6d作为两级的子目录，也就是该资源最终会被缓存到/path/to/cache/0/6d目录中。

（3）key_zone

在共享内存中设置一块存储区域来存放缓存的key和metadata（类似使用次数），这样Nginx可以快速判断一个request是否命中或者未命中缓存，1m可以存储8000个key，10m可以存储80000个key。

（4）max_size

最大cache空间，如果不指定，会使用掉所有disk space，当达到配额后，会删除最少使用的cache文件。

（5）inactive

未被访问文件在缓存中保留时间，本配置中如果60分钟未被访问则不论状态是否为expired，缓存控制程序会删掉文件。inactive默认是10分钟。需要注意的是，inactive和expired配置项的含义是不同的，expired只是缓存过期，但不会被删除，inactive是删除指定时间内未被访问的缓存文件。

（6）use_temp_path

如果为off，则Nginx会将缓存文件直接写入指定的cache文件中，而不是使用temp_path存储，official建议为off，避免文件在不同文件系统中不必要的拷贝。

（7）proxy_cache

启用proxy cache，并指定key_zone。另外，如果proxy_cache off表示关闭掉缓存。


# Nginx缓存机制

![](/images/nginx_cache_1_1.png)

# 一些其他Nginx缓存知识

（1）proxy_cache_use_stale增强站点容错能力

源站有问题时，Nginx可以通过proxy_cache_use_stale指令开启容错能力，即使用缓存内容来响应客户端的请求。举个栗子：

```
location / {
    ...
    proxy_cache_use_stale error timeout http_500 http_502 http_503 http_504;
}
```

如上配置表示，当作为cache的Nginx收到源站返回error、timeout或者其他指定的5XX错误，并且在其缓存中有请求文件的陈旧版本，则会将这些陈旧版本的文件而不是错误信息发送给客户端。

（2）多磁盘分割缓存

使用Nginx，不需要建立一个RAID（磁盘阵列）。如果有多个硬盘，Nginx可以用来在多个硬盘之间分割缓存。举个栗子：

```
proxy_cache_path /path/to/hdd1 levels=1:2 keys_zone=my_cache_hdd1:10m max_size=10g inactive=60m use_temp_path=off;
proxy_cache_path /path/to/hdd2 levels=1:2 keys_zone=my_cache_hdd2:10m max_size=10g inactive=60m use_temp_path=off;

split_clients $request_uri $my_cache {
    50%   "my_cache_hdd1";
    50%   "my_cache_hdd2";
}

server {
    ...
    location / {
        proxy_cache $my_cache;
        proxy_pass http://my_upstream;
    }
}
```

例子中的两个proxy_cache_path定义了两个缓存（my_cache_hdd1和my_cache_hdd2）分属两个不同的硬盘。split_clients配置部分指定了请求结果的一半在my_cache_hdd1中缓存，另一半在my_cache_hdd2中缓存。基于`$request_uri`（请求URI）变量的哈希值决定了每一个请求使用哪一个缓存，对于指定URI的请求结果通常会被缓存在同一个缓存中。

（3）缓存命中情况的Nginx变量$upstream_cache_status

$upstream_cache_status的可能值有：

    MISS        #响应在缓存中找不到，所以需要在服务器中取得。这个响应之后可能会被缓存起来
    BYPASS      #响应来自原始服务器而不是缓存，因为请求匹配了一个proxy_cache_bypass，这个响应之后可能会被缓存起来
    EXPIRED     #缓存中的某一项过期了，来自原始服务器的响应包含最新的内容
    STALE       #内容陈旧是因为原始服务器不能正确响应。需要配置proxy_cache_use_stale
    UPDATING    #内容过期了，因为相对于之前的请求，响应的入口（entry）已经更新，并且proxy_cache_use_stale的updating已被设置
    REVALIDATED #proxy_cache_revalidate命令被启用，Nginx检测得知当前的缓存内容依然有效（If-Modified-Since或者If-None-Match）
    HIT         #响应包含来自缓存的最新有效的内容

（4）HTTP响应头Cache-Control

当在响应头部中Cache-Control被配置为Private，No-Cache，No-Store或者Set-Cookie，不允许代理对资源进行缓存。

（5）Nginx对缓存的资源会设置一个key，Nginx生成的键的默认格式是类似于下面的Nginx变量的MD5哈希值`$scheme$proxy_host$request_uri`，实际的算法有些复杂。 为了改变变量（或其他项）作为基础键，可以使用proxy_cache_key命令。例如，

```
proxy_cache_key $proxy_host$request_uri$cookie_jessionid;
```

（6）缓存指令proxy_cache_valid

为不同的HTTP返回状态码的资源设置不同的缓存时长。

命令格式为：

```
proxy_cache_valid [code ...] time; 
```

举例来说，

```
proxy_cache_valid 200 302 10m;    #为响应码是200和302的资源，设置缓存时长为10分钟
proxy_cache_valid 404      1m;    #为响应码是404的资源，设置的缓存的时长为1分钟
```

（7）缓存清理指令proxy_cache_purge

学习资料参考于：
https://blog.51cto.com/benpaozhe/1763897
