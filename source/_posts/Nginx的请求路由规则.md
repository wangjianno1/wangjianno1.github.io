---
title: Nginx的请求路由规则
date: 2019-03-05 22:28:03
tags:
categories: Nginx
---

Nginx的请求处理过程大概有两个步骤，第一步是虚拟主机的确定，第二步是location路由的确定。

# 虚拟主机的确定

Nginx首先决定由哪个虚拟主机来处理请求，就是由哪个server段来处理请求。在这个过程中又分几个步骤：

（1）判断listen指令

listen指令的格式是`listen ip:port`。如果port省略，则监听标准端口80；如果ip省略，表示监听所有ip，也就是监听来自所有网卡的请求；如果server段中没有listen指令，那就表示监听所有网卡ip的80的端口。

（2）判断server_name指令

server_name指令可以有精确配置、通配符配置以及正则配置三种形式：

```
server_name www.baidu.com;                 #精确配置
server_name *.baidu.com;                   #以通配符开头的配置
server_name baidu.*;                       #以通配符结尾的配置
server_name ~^(?<user>.+)\.example\.net$;  #正则的配置，必须以波浪线为开头
```

假设在Nginx中由多个虚拟主机监听同一个端口，相当于在步骤（1）中同时匹配到多个虚拟主机，这时就需要通过server_name指令决定使用哪个虚拟主机来响应请求。也就是通过HTTP请求中的Host请求头来和server_name进行匹配。如果通过server_name还是有多个虚拟主机能够匹配上，那么就会按照一定的优先级来决定，规则为：

    精确匹配 >> 以通配符开头匹配 >> 以通配符结尾的匹配 >> 正则匹配

（3）例外

如果通过listen和server_name没有匹配上任何的虚拟主机，那么请求会交给default server来处理。default server默认为Nginx配置文件中第一个虚拟主机，当然我们在`listen ip:port default_server`来显式指定一个缺省的虚拟主机。

还有，如果用户的HTTP请求中，没有Host请求头，那么我们需要为其配置一个虚拟主机来处理，如下配置（在0.8.48以后的版本，下面的配置可以省略）：

```
server {
    listen 80;
    server_name "";
    return 444;
}
```

# location路由处理

以`=`开头，表示精确匹配；

以`^~`开头，表示uri以某个常规字符串开头，不是正则匹配；

以`~`开头，表示区分大小写的正则匹配；

以`~*`开头，表示不区分大小写的正则匹配；

以`/`开头，表示通用匹配，如果没有其它匹配,任何请求都会匹配到；

如果多个location匹配均匹配，按照如下的优先级来确定：

    (location =) >> (location 完整路径) >> (location ^~ 路径) >> (location ~,~* 正则顺序) >> (location 部分起始路径) >> (/)

# location @name实现内部跳转

举例来说，

```
location /img/ {
    error_page 404 @img_err;
}
    
location @img_err {
    # 规则
}
```

上述规则表示，以`/img/`开头的请求，如果请求返回的状态为404，则会匹配到`@img_err`这条规则上。
