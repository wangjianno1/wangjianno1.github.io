---
title: Shadowsocks简介及使用
date: 2018-02-03 18:32:03
tags:
categories: GFW
---


# GFW的来临

这个文章来源于一个朋友在科学上网的过程中，搞不清楚Shadowsocks的配置问题，在这里我想按照我对Shadowsocks 的理解简单梳理一下，以便一些非专业人士也能了解。

在很久很久以前，我们访问各种网站都是简单而直接的，用户的请求通过互联网发送到服务提供方，服务提供方直接将信息反馈给用户。

![](/images/shadowsocks_1_1.png) 

然后有一天，GFW 就出现了，他像一个收过路费的强盗一样夹在了在用户和服务之间，每当用户需要获取信息，都经过了 GFW，GFW将它不喜欢的内容统统过滤掉，于是客户当触发 GFW 的过滤规则的时候，就会收到 Connection Reset 这样的响应内容，而无法接收到正常的内容。

![](/images/shadowsocks_1_2.png) 

# ssh tunnel

聪明的人们想到了利用境外服务器代理的方法来绕过GFW的过滤，其中包含了各种HTTP代理服务、Socks服务、VPN服务。其中以ssh tunnel的方法比较有代表性。

1）首先用户和境外服务器基于ssh建立起一条加密的通道
2-3）用户通过建立起的隧道进行代理，通过ssh server向真实的服务发起请求
4-5）服务通过ssh server，再通过创建好的隧道返回给用户

![](/images/shadowsocks_1_3.png)

由于ssh本身就是基于RSA加密技术，所以GFW无法从数据传输的过程中的加密数据内容进行关键词分析，避免了被重置链接的问题，但由于创建隧道和数据传输的过程中，ssh本身的特征是明显的，所以GFW一度通过分析连接的特征进行干扰，导致ssh存在被定向进行干扰的问题。

# Shadowsocks

简单来说，shadowsocks是将原来ssh创建的Socks5协议拆开成server端和client端，所以下面这个原理图基本上和利用ssh tunnel大致类似。

1,6）客户端发出的请求基于Socks5协议跟ss-local端进行通讯，由于这个ss-local一般是本机或路由器或局域网的其他机器，不经过GFW，所以解决了上面被GFW通过特征分析进行干扰的问题

2,5）ss-local和ss-server两端通过多种可选的加密方法进行通讯，经过GFW的时候是常规的TCP包，没有明显的特征码而且 GFW 也无法对通讯数据进行解密

3,4）ss-server将收到的加密数据进行解密，还原原来的请求，再发送到用户需要访问的服务，获取响应原路返回 

![](/images/shadowsocks_1_4.png)

备注：
简单来说，有香港或国外服务器的话，用shadowsocks客户端在本地代理，在香港或国外服务器运行`ssserver -p 8388 -k 密码 -m aes-256-cfb -d start`，Google Chrome里面装个代理插件（例如SwitchyOmega）就可以翻墙了。


学习资料参考于：
https://www.loyalsoldier.me/fuck-the-gfw-with-my-own-shadowsocks-server/
