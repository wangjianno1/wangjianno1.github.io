---
title: Nginx基本配置
date: 2019-03-05 23:21:44
tags:
categories: Nginx
---


# Nginx配置文件结构

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

# Nginx配置中一些细节

（1）server_name

```
server_name www.example.com example.com news.example.com; #server_name指令可以配置多个server，中间用空格分开即可
server_name *.example.com;                                #server_name也可以用通配符，用来匹配满足要求的请求，而不单单匹配某一个虚机Host
```

（2）Nginx作为代理的配置

如果Nginx的虚机是用来做反向代理，那么一般就需要如下的配置：

```
proxy_set_header Host $host;               #设置代理转发http request的Host header中
proxy_set_header X-Real-IP $remote_addr;   #将上一层http请求的来源IP，设置到转发http request的X-Real-IP header中
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;   #将多层代理的IP，设置到转发http request的X-Forwarded-For header中，最终让服务端能够获取的多层代理的IP
proxy_pass http://10.17.136.17:8080;
```

（3）expires指令的用法

expires指令用来控制HTTP响应头中是否增加或修改Expires和Cache-Control，expires指令仅仅对响应状态码为200，201，204，206，301，302，303，304及307的时候有效。

    当expire为负时，会在响应头增加`Cache-Control: no-cache`
    当expire为正或者0时，就表示Cache-Control: max-age=指定的时间(秒)，同时Expires被设置为当前时间加上time值所代表的时间点
    当expire为max时，会把Expires设置为“Thu, 31 Dec 2037 23:55:55 GMT”，Cache-Control设置到10年
    当expire为off时，表示不增加或修改Expires和Cache-Control

expire指令的使用举例如下：

```
expires -1;
expires 0;
expires 1h;
expires max;
expires off;
```

（4）Nginx关于proxy_set_header和add_header指令的一个坑

我们知道，Nginx的配置是有层级关系的，如：

```
xxxxx
http
{
    upstream xxxx {
    }
    server {
        xxxxxx
        location /path {
            xxxxx
        }
    }
}
```

以proxy_set_header为例来说，当某个级别中不包含proxy_set_header指令时，就会从上一级继承。举例来说，若location中配置了任何的proxy_set_header指令，那么即使sever中配置了再多的proxy_set_header，location中还是只生效其自己配置的proxy_set_header。当location中没有配置任何的proxy_set_header，那么它会从server中继承一些proxy_set_header配置。

在这个地方，我们一般有一定的误解，认为proxy_set_header和其他指令一样，会叠加上一层级的配置，事实上会覆盖上一级的配置。如下图中，`proxy_set_header X-**-Https "https"`所配置的位置和箭头所指向的位置带来的效果是不一样的哦。

![](/images/nginx_conf_1_1.png)

同理add_header也有这样的问题。

学习资料参考于：
https://www.4os.org/?p=1010
