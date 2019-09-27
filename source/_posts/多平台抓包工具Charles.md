---
title: 多平台抓包工具Charles
date: 2019-06-22 22:44:16
tags:
categories: Network
---

# 多平台抓包工具Charles简介

Charles是在Windows/Mac/Linux多平台下常用的网络封包截取工具，尤其在做移动开发项目时，为了调试与服务器端的网络通讯协议，常常需要截取网络封包来分析，而Charles就是一个很好的抓包分析工具。

Charles是收费软件，可以免费试用30天。试用期过后，未付费的用户仍然可以继续使用，但是每次使用时间不能超过30分钟，并且启动时将会有10秒种的延时。因此，该付费方案对广大用户还是相当友好的，即使你长期不付费，也能使用完整的软件功能。只是当你需要长时间进行封包调试时，会因为Charles强制关闭而遇到影响。

Charles通过将自己设置成系统的网络访问代理服务器，使得所有的网络访问请求都通过它来完成，从而实现了网络封包的截取和分析。简单来说，Charles可以理解为一个HTTP/HTTPS的代理服务器。Charles主要的功能包括：

+ 截取HTTP和HTTPS网络封包
+ 支持重发网络请求，方便后端调试
+ 支持修改网络请求参数
+ 支持网络请求的截获并动态修改
+ 支持模拟慢速网络

# Charles使用流程

（1）在Mac/Windows上安装Charles工具，并启动。然后在`help->Local Address`查看Charles监听的IP和Port。

（2）在无线网络或WiFi中配置代理。

（3）在手机上发起各种网络访问，然后就可以在Charles看到被截获的各种数据包。

# Charles的几种代理模式

## HTTP正向代理

（1）普通代理

若HTTP请求到达Charles代理时，有Charles向服务端发起HTTP请求，并将HTTP响应数据返回给客户端。这种情况下，因为HTTP都是明文的，Charles代理就能捕获所有的HTTP请求报文。

![](/images/charles_1_1.png)

（2）隧道代理

HTTP客户端通过HTTP CONNECT方法请求“隧道代理”创建一条到达任意目标服务器和端口的TCP连接，并对客户端和服务器之间的后继数据进行盲转发（无脑转发）。

![](/images/charles_1_2.png)

假如我通过代理访问A网站，浏览器首先通过CONNECT请求，让代理创建一条到A网站的TCP连接；一旦TCP连接建好，代理无脑转发后续流量即可。所以这种代理，理论上适用于任意基于TCP的应用层协议，HTTPS网站使用的TLS协议当然可以使用这种方式啦。这也是这种代理为什么被称为隧道的原因。对于HTTPS来说，客户端透过代理直接跟服务端进行TLS握手协商密钥，所以依然是安全的。

当HTTPS请求到达Charles时，Charles只能抓取到HTTP的CONNECT报文，并不能获取到HTTPS报文的任何内容。

## SOCKS代理

待补充。

## 反向代理

待补充。

## HTTPS/SSL代理（HTTPS中间人攻击）

由于普通代理和隧道代理中，我们无法获取HTTPS报文的详细信息，因此我们可以开启Charles的SSL代理模式，这种Charles就相当于一个攻击中间人，来获取HTTPS的报文信息。首先浏览器或手机需要安装并信任Charles签发的CA根证书。浏览器或手机与Charles之间建立SSL连接，使用的是Charles自己签发的假证书。然后Charles和服务端也建立SSL连接，使用的是真实的后端服务发过来的证书。

在这种情况下，Charles就可以截获HTTPS详细的报文信息。

HTTPS/SSL代理配置详细过程如下（客户端为iOS，Charles部署在MAC电脑上）：

（1）将Charles自签发的根证书安装到移动设备iOS上

在Charles上点击`Help->SSL Proxying->Install Charles Root Certificate on Mobile Device or Remote Browser…`这时会弹出一个对话框，如下：

![](/images/charles_1_3.png)

我们在IOS的Safari浏览器中输入`chls.pro/ssl`或`http://charlesproxy.com/getssl将证书安装到IOS上`。

（2）在IOS上信任新证书

首先在`设置->通用->描述文件与设备管理`中，安装刚刚下载的证书描述文件。然后在`设置->通用->关于本机->证书信任设置`中信任Charles的根证书。

![](/images/charles_1_4.png)

（3）在Charles的`Proxy->SSL Proxying Settings`中勾选Enable SSL Proxying，然后添加要抓取的域名和端口：

![](/images/charles_1_5.png)

（4）在IOS的无线局域网中设置代理即可大功告成。

学习资料参考于：
https://blog.devtang.com/2015/11/14/charles-introduction/
https://bigzuo.github.io/2018/12/15/nginx-https-forward-proxy/
https://www.jianshu.com/p/a83b19a36a8b
https://imququ.com/post/web-proxy.html
https://www.jianshu.com/p/468e2905a3e1
