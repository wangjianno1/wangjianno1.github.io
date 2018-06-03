---
title: DNS胶水记录glue record说明
date: 2018-06-04 01:11:11
tags: DNS
categories: SRE
---

# DNS胶水记录举例说明

假设我们有一个域名`example.com`，同时搭建了DNS服务，有2台机器，即`ns1.example.com`和`ns2.example.com`。如果让互联网上的网民能够解析到`*.example.com`的域名，我们需要在`.com`的域名服务器上添加如下记录：

```
example.com NS ns1.example.com
example.com NS ns2.example.com

ns1.example.com A 192.0.2.10
ns2.example.com A 192.0.2.20
```

备注：如果不提供上面DNS服务器的A记录的话，域名解析时就会出现死循环。即`.com`的DNS告诉需要到`ns1~ns2.example.com`上去解析`example.com`的域名。然后用户询问`ns1~ns2.example.com`的ip，当请求达到`.com`的DNS时，又会被告知到`ns1~ns2.example.com`上去查询。

# 关于胶水记录的实际应用中注意点

假设我们有域名`example.com`，之前的DNS为`ns1.example.com`和`ns2.example.com`两个，现在新增一个DNS为`ns3.example.com`，那么我们需要在域名注册商（例如MarkMonitor、万网等）做如下修改：

（1）host注册

在域名商的管理控制台上，添加新增DNS的host注册，即`ns3.example.com`映射到`112.*.*.*`。

（2）添加NS记录

将`example.com`的DNS域名服务器，修改为`ns1.example.com`，`ns2.example.com`和`ns3.example.com`。

另外，除了注册商那边做如上修改，我们自己的`ns1.example.com`，`ns2.example.com`和`ns3.example.com`也要做相应地修改，每一个NS的zone file中都需要有如下信息：

```
@ NS   ns1.example.com
@ NS   ns2.example.com
@ NS   ns3.example.com
ns1.example.com   A   1.1.1.1
ns2.example.com   A   2.2.2.2
ns3.example.com   A   3.3.3.3
```

备注：一定要注意的是，上面的信息如IP地址要和注册商或上层DNS上保持一致，否则可能会出现一些奇奇怪怪的问题。
