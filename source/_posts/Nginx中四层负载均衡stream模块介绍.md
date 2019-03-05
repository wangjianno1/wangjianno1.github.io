---
title: Nginx中四层负载均衡stream模块介绍
date: 2019-03-06 00:23:12
tags:
categories: Nginx
---

Nginx从1.9.0开始发布`ngx_stream_*_module`模块，该模块支持TCP代理及负载均衡。注意和HTTP七层代理和负载均衡区别开来，stream模块是在四层上做的负载均衡哦。举个使用stream模块的Nginx的配置：

```
worker_processes auto;

events {
    worker_connections  1024;
}

error_log /var/log/nginx_error.log info;

stream {
    upstream mysqld {
        hash $remote_addr consistent;
        server 192.168.1.42:3306 weight=5 max_fails=1 fail_timeout=10s;
        server 192.168.1.43:3306 weight=5 max_fails=1 fail_timeout=10s;
    }

    server {
        listen 3306;
        proxy_connect_timeout 1s;
        proxy_timeout 3s;
        proxy_pass mysqld;
    }
}
```

备注：如上是用Nginx对后端的MySQL服务进行四层代理和负载均衡。

学习资料参考于：
http://www.10tiao.com/html/357/201703/2247484964/1.html
