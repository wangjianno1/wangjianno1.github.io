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

普通代理下，浏览器/代理/服务端的网络交互过程如下（假设代理的IP:Port为192.168.2.100:8888）：

    浏览器与代理(192.168.2.100:8888)建立TCP连接（设置了代理，浏览器就不会再发起域名的DNS解析请求了）
    浏览器向代理(192.168.2.100:8888)发送HTTP GET/POST请求
    代理解析出HTTP请求中的域名，DNS解析拿到域名IP，然后建立代理和该IP对应的服务器80端口的TCP连接
    代理向服务器发送HTTP GET/POST请求
    代理收到服务器返回的HTTP响应报文
    代理将服务器的响应报文再发送给浏览器

（2）隧道代理

浏览器通过HTTP CONNECT方法请求“隧道代理”创建一条到达任意目标服务器和端口的TCP连接，并对浏览器和服务器之间的后继数据进行转发。

![](/images/charles_1_2.png)

隧道代理下，客户端/代理/服务端的网络交互过程如下（假设代理的IP:Port为192.168.2.100:8888）：

    浏览器与代理(192.168.2.100:8888)建立TCP连接（设置了代理，浏览器就不会再发起域名的DNS解析请求了）
    浏览器向代理(192.168.2.100:8888)发送HTTP CONNECT方法请求，主要请求的参数就是域名和端口，如www.baidu.com:443
    代理解析出HTTP CONNECT请求中的域名，DNS解析拿到域名IP，然后建立代理和该IP对应的服务器的443端口的TCP连接
    代理和服务器TCP连接建立完成后，代理向浏览器发送一个HTTP 200的Connection established的HTTP响应报文
    浏览器向代理(192.168.2.100:8888)发送TLS ClientHello报文
    代理将浏览器发过来的报文，修改一下SRCIP:SRCPORT为代理的IP和PORT之后，直接转发出去，也就是数据包会发送给服务端
    服务端收到TLS ClientHello报文，响应TLS ServerHello报文给代理。代理收到服务端的ServerHello报文，将DESTIP:DESTPORT修改为浏览器的IP和PORT后，直接转发给浏览器
    后面的流程类似，都是代理直接包报文转发出去就可以了，直至TLS握手完成，然后开始应用数据加密传输都是这个过程
    。。。

以上过程都可以通过WireShark抓包验证，在本地启动Charles，代理地址是127.0.0.1:8888，如下是使用WireShark在本地loopback网卡上的抓包结果：

![](/images/charles_1_6.png)

所以这种代理，理论上适用于任意基于TCP的应用层协议，HTTPS网站使用的TLS协议当然可以使用这种方式啦。这也是这种代理为什么被称为隧道的原因。对于HTTPS来说，浏览器透过代理直接跟服务端进行TLS握手协商密钥，所以依然是安全的。

使用隧道代理模式中，一个HTTPS请求，Charles只能抓取到一条HTTP CONNECT报文，其他报文都抓取不到。这是因为，第一在TLS握手阶段没有HTTP报文，第二在应用数据加密传输阶段，HTTP报文被加密然后被TLS协议封装，所以Charles也解析不出来HTTP报文了，对于Charles只能解析应用层是HTTP协议的报文的缘故，所以只有一条HTTP CONNECT请求。要想抓取HTTPS完整报文，且看下面的“HTTPS/SSL代理“部分。

## SOCKS代理

待补充。

## 反向代理

待补充。

## HTTPS/SSL代理（HTTPS中间人攻击）

### 原理说明

由于普通代理和隧道代理中，我们无法获取HTTPS报文的详细信息，因此我们可以开启Charles的SSL代理模式，这种Charles就相当于一个攻击中间人，来获取HTTPS的报文信息。首先浏览器或手机需要安装并信任Charles签发的CA根证书。浏览器或手机与Charles之间建立SSL连接，使用的是Charles自己签发的假证书。然后Charles和服务端也建立SSL连接，使用的是真实的后端服务发过来的证书。

在这种情况下，Charles就可以截获HTTPS详细的报文信息。

HTTPS代理开启下，浏览器/代理/服务端的网络交互过程如下：

    浏览器与代理(192.168.2.100:8888)建立TCP连接（设置了代理，浏览器就不会再发起域名的DNS解析请求了）
    浏览器向代理(192.168.2.100:8888)发送HTTP CONNECT方法请求，主要请求的参数就是域名和端口，如www.baidu.com:443
    代理解析出HTTP CONNECT请求中的域名，DNS解析拿到域名IP，然后建立代理和该IP对应的服务器的443端口的TCP连接
    代理和服务器TCP连接建立完成后，代理向浏览器发送一个HTTP 200的Connection established的HTTP响应报文
    浏览器向代理(192.168.2.100:8888)发送TLS ClientHello报文
    代理开始与浏览器通过Charles私有证书开始建立TLS连接，并解析浏览器发过来的ClientHello报文，然后重新封装Charles自己的ClientHello报文，发给服务端，开始建立TLS连接。最终浏览器和代理TLS握手成功，代理和服务端TLS握手成功
    应用数据加密传输阶段，代理收到浏览器的TLS报文，直接解密出明文，然后重新封装TLS报文，发送给服务端。服务端返回的TLS报文，也是由代理先解密出明文，然后重新封装TLS报文，返回给浏览器

由此可见，对于“HTTPS/SSL代理”和“隧道代理”来说，浏览器的处理方式是一样的，也就浏览器发现本地设置了HTTPS代理，先向代理发起HTTP CONNECT请求，然后开始向代理发送TLS握手报文，以及应用传输阶段的TLS报文。然后两种模式下，Charles代理侧却是不一样的处理。

### 配置过程

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

# APP禁止Charles抓包原因和解决方案

部分大厂的APP的HTTP客户端禁止使用HTTP/HTTPS代理，导致无法使用Charles抓包。代理抓包的关键就是需要HTTP客户端按照要求去连接代理服务器，通常HTTP客户端都是按要求去实现的，在进行HTTP请求前会先检查系统代理，如果有设置代理，客户端会直接去连接代理服务器。然后有些APP使用一些HTTP客户端，使用了NO Proxy配置，导致有代理时，不会去连接代理，从而也就是无法使用Charles抓包。一些网络库，如OKhttp很容易设置不走系统代理的。

还有的APP，一部分请求的HTTP客户端禁用了代理，而一部分请求的HTTP客户端又会使用代理，这种情况下，就会抓取到该APP部分请求的数据包。

针对上面的这种原因，网上说可以在本地启VPN服务， 然后再代理到Charles，没具体研究过，后续有需要再研究。

另外需要注意的是，有些APP端上固定绑定了证书，是不信任Charles代理发过来的证书的，所以在APP和Charles之间的TLS握手阶段会失败。针对这种问题，比较难搞，网上说可以用“证书逆向”啥的，没具体研究过，有需要再研究。

# 闲杂

（1）HTTP CONNECT Method是HTTP的一个特殊请求方法，就是直接给使用了正向代理的HTTP客户端（浏览器）来使用的。

（2）点击Charles的`Proxy->macOSProxy`，可以快速将MacOS系统的本地代理设置为该Charles。然后系统上所有APP的特定协议的请求（如HTTP/HTTPS）会被Charles代理。如下为点击了菜单`Proxy->macOSProxy`之后，MacOS系统的代理配置截图：

![](/images/charles_1_7.png)

默认Charles仅代理HTTP/HTTPS协议，其他应用层协议的报文不会被Charles代理。


学习资料参考于：
https://blog.devtang.com/2015/11/14/charles-introduction/
https://bigzuo.github.io/2018/12/15/nginx-https-forward-proxy/
https://www.jianshu.com/p/a83b19a36a8b
https://imququ.com/post/web-proxy.html
https://www.jianshu.com/p/468e2905a3e1
