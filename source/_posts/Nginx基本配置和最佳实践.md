---
title: Nginx基本配置和最佳实践
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

# Nginx常用配置指令

Nginx的配置是由简单指令和块指令组成。简单指令如Listen、server_name等，块指令如events、http、stream等。

（1）access_log与error_log

access_log可以定义日志输出的格式，而error_log不可以定义日志的输出格式。

（2）include指令

可以把其他配置文件中的内容引入到Nginx的主配置文件nginx.conf中。

（3）keepalive_timeout 5  

表示nginx这边保持与客户端连接的时长。

（4）check interval=10000 rise=2 fall=3 timeout=3000 type=tcp default_down=false

upstream的健康检查，健康检查的周期为10000ms，健康检查超时时间为3000ms，即认为3000ms下游还未返回，那么任务本次健康检查是失败的。rise=2表示，如果两次健康检查都是正常的，那么对应的下游被标记为up，fall=3表示连续三次健康健康失败，对应的下游被标记为down，也就是会被剔除。

（5）proxy_pass URL

设置Nginx作为Proxy将请求转发到的目的地址。proxy_pass指令后可以是具体url，也可以是upstream哦。

（6）proxy_set_header  

Nginx作为Proxy将请求转发出去前，设置HTTP header。

（7）resolver address   

设置DNS服务器的地址，用来解析域名的IP地址。

（8）add_header name value 

用来设置http response的响应头给浏览器。

（9）proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for  

将$proxy_add_x_forwarded_for的值，设置到X-Forwarded-For请求头中。

# Nginx中常见的内置变量

Nginx中有一些内置的变量，可以在Nginx的配置文件中直接使用，如下列举出一些常用的内置变量：

```
$http_user_agent     #客户端代理信息
$request_method      #请求的方法，比如get/post等;
$scheme              #所用的协议，比如http/https等
$server_protocol     #请求使用的协议，通常是HTTP/1.0或HTTP/1.1
$host                #优先级如下：HTTP请求行的主机名>请求头HOST字段>符合请求的服务器名 server_name
$remote_addr         #客户端的IP，如果用nginx做了多层代理了，那么remote_addr就是上一层代理的IP
$remote_port         #客户端的端口
$request             #原始请求url
$http_cookie         #客户端cookie信息
$args                #这个变量等于请求行中的参数，同$query_string
$remote_user         #已经经过Auth Basic Module验证的用户名。
$request_uri         #包含请求参数的原始URI，不包含主机名，如："/foo/bar.php?arg=baz"
$uri                 #不带请求参数的当前URI，$uri不包含主机名，如"/foo/bar.html"
$document_uri        #与$uri相同
$server_name         #就是虚机的server_name
$proxy_add_x_forwarded_for   #该变量等于nginx收到的请求的X-Forwarded-For请求头内容，加上$remote_addr。也就是将请求来源的IP追加到X-Forwarded-For请求头的尾部，并用逗号分开
```

备注：remote_addr代表客户端的IP，但它的值不是由客户端提供的，而是服务端根据客户端的IP来指定的，当你的浏览器访问某个网站时，假设中间没有任何代理，那么网站的WEB服务器（Nginx/Apache等）就会把remote_addr设为你的机器IP，如果你用了某个代理，那么你的浏览器会先访问这个代理，然后再由这个代理转发到网站，这样web服务器就会把remote_addr设为这台代理机器的IP。对于使用了多层代理时，服务端要想获取到真实用户的IP，是通过proxy_add_x_forwarded_for变量来获取的啦。

# Nginx的最佳配置实践

（1）在实际安装部署Nginx时，要遵循按需安装模块的原则。需要某一个模块则安装，不需要则不要安装。因为每一个被安装的模块都可能会消耗资源，影响Nginx的性能。

（2）Nginx和Apache都是模块化的设计，但是二者的模块化管理有所有不用。Apache支持模块的“热插拔”，即Apache添加模块，只需要引入模块，然后重启Apache就行了。而Nginx添加模块需要重新编译。

（3）Nginx的worker进程数量最好要与CPU的核数保持一致，并设置CPU亲和力。

（4）在生产环境中，当我们修改完Nginx的配置后，可以使用`/sbin/nginx -t`来测试Nginx的配置文件格式是否正确。

（5）Nginx中server内location的推荐配置

在实际生成环境中，至少有三个匹配规则定义是不可少的，如下：

```
#直接匹配网站根，通过域名访问网站首页比较频繁，使用这个会加速处理，官网如是说。
#这里是直接转发给后端应用服务器了，也可以是一个静态首页
# 第一个必选规则
location = / {
    proxy_pass http://tomcat:8080/index
}
# 第二个必选规则是处理静态文件请求，这是nginx作为http服务器的强项
# 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
location ^~ /static/ {
    root /webroot/static/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /webroot/res/;
}
#第三个规则就是通用规则，用来转发动态请求到后端应用服务器
#非静态文件请求就默认是动态请求，自己根据实际把握
#毕竟目前的一些框架的流行，带.php,.jsp后缀的情况很少了
location / {
    proxy_pass http://tomcat:8080/
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

X-Forwarded-For是一个HTTP扩展头部。HTTP/1.1（RFC 2616）协议并没有对它的定义，它最开始是由Squid这个缓存代理软件引入，用来表示HTTP请求端真实IP。如今它已经成为事实上的标准，被各大HTTP代理、负载均衡等转发服务广泛使用，并被写入RFC 7239（Forwarded HTTP Extension）标准之中。说白了，对于有多层代理的架构来说，X-Forwarded-For能够将浏览器IP以及各层代理的IP记录到X-Forwarded-For请求头中，供WEB应用来获取。

X-Forwarded-For 请求头格式非常简单，如下：

    X-Forwarded-For: client, proxy1, proxy2

X-Real-IP也是一个HTTP扩展头部字段。X-Real-IP通常被HTTP代理用来表示与它产生TCP连接的设备IP，这个设备可能是其他代理，也可能是真正的请求端。需要注意的是，X-Real-IP目前并不属于任何标准，代理和Web应用之间可以约定用任何自定义头来传递这个信息。

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
