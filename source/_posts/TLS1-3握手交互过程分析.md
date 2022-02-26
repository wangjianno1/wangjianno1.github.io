---
title: TLS1.3握手交互过程分析
date: 2022-02-26 18:23:58
tags:
categories: HTTPS
---

# TLS1.3首次完整握手过程(1-RTT)

TLS1.3版本以DH密钥协商的过程如下：

![](/images/https_handshake13_1_1.png)

![](/images/https_handshake13_1_2.png)

support_groups提供了Client所能支持的所有密钥协商算法，然后Client通过key_share将各个密钥协商算法对应client的共享参数，提前发送给服务端，然后由服务端来选择使用那个密钥协商算法和共享参数。

首次完整握手完成以后，还会发送NewSessionTicket消息。在TLS1.3中，这个消息中会带early_data的扩展。如果有early_data这个扩展，就表明Server可以支持0-RTT。如果没有带这个扩展，表明Server不支持0-RTT，Client在下次会话恢复的时候不要发送early_data扩展。

# TLS1.3会话恢复(1-RTT/0-RTT)

网上很多文章对TLS1.3第二次握手（会话恢复）有误解。TLS1.3在宣传的时候就以0-RTT为主，大家都会认为TLS 1.3在第二次握手的时候都是0-RTT 的，包括网上一些分析的文章里面提到的最新的PSK密钥协商，PSK密钥协商并非是0-RTT的。

TLS1.3再次握手其实是分两种，一种是普通会话恢复模式，另一种是0-RTT模式。非0-RTT的会话恢复模式和TLS 1.2的会话恢复在耗时上没有提升，都是1-RTT，只不过比TLS 1.2更加安全了。只有在0-RTT的会话恢复模式下，TLS 1.3才比TLS 1.2有提升。具体提升对比见下表：

![](/images/https_handshake13_1_3.png)

在TLS1.3完整握手中，Client在收到Finished消息以后，还会收到Server发过来的NewSessionTicket消息。需要注意的是，TLS 1.2中NewSessionTicket是主密钥，而TLS 1.3的NewSessionTicket中只是一个PSK。

## 基于1-RTT的PSK会话恢复模式

TLS 1.3中更改了会话恢复机制，废除了原有的SessionID和SessionTicket的方式，而是使用PSK的机制，同时NewSessionTicket中添加了过期时间。TLS 1.2中的SessionTicket不包含过期时间。

在经历了一次完整握手以后，生成了PSK，下次握手就会进入会话恢复模式，在ClientHello中，先在本地Cache中查找ServerName对应的PSK，找到后在ClientHello的pre_shared_key扩展中带上两部分内容：

    * Identity: NewSessionTicket中加密的ticket
    * Binder: 由PSK导出binder_key，使用binder_key对不包含binder list部分的ClientHello作HMAC计算

Server收到带有PSK的ClientHello以后，生成协商之后的key_share，并检查Client hello中的pre_shared_key扩展，解密PskIdentity.identity(即ticket)，查看该ticket是否过期，各项检查通过以后，由PSK导出binder_key并计算ClientHello的HMAC，检查binder是否正确。验证完ticket和binder之后，在ServerHello扩展中带上pre_shared_key扩展，标识使用哪个PSK进行会话恢复。和Client一样，从Resumtion Secret开始导出PSK，最终导出earlyData使用的密钥。后续的密钥导出规则和完整握手是一样的，唯一的区别就是会话恢复多了PSK，它是作为early secret的输入密钥材料IKM。

整个过程如下：

![](/images/https_handshake13_1_4.png)

![](/images/https_handshake13_1_5.png)

## 基于0-RTT的会话恢复模式

据Google统计，全网有60%的网站访问流量是来自于新访问的网站和过去曾经访问过但是隔了一段时间再次访问。这部分流量在TLS 1.3的优化下，已经从2-RTT降低到1-RTT了。剩下40%的网站访问流量是来自于会话恢复，TLS 1.3废除了之前的SessionID和SessionTicket的会话恢复的方式，统一成了PSK方式，使得原有会话恢复变的更加安全。但是TLS 1.3的会话恢复并没有降低RTT，依旧停留在了1-RTT。为了进一步降低延迟，于是提出了0-RTT的概念。0-RTT能让用户有更快更顺滑更好的用户体验，在移动网络上更加明显。

TLS 1.3的里程碑标志就是添加了0-RTT会话恢复模式。也就是说，当Client和Server共享一个PSK（从外部获得或通过一个以前的握手获得）时，TLS 1.3允许Client在第一个发送出去的消息中携带数据（"early data"）。Client使用这个PSK生成client_early_traffic_secret并用它加密early data。Server收到这个ClientHello之后，用ClientHello扩展中的PSK导出client_early_traffic_secret并用它解密early data。

想实现0-RTT也是有一些条件的，条件比较苛刻，如果条件有一条不满足，会话恢复都只能是1-RTT的PSK会话恢复模式。0-RTT的开启条件是：

（1）Server在前一次完整握手中，发送了NewSessionTicket，并且SessionTicket中存在max_early_data_size扩展表示愿意接受early data。如果没有这个扩展，0-RTT无法开启。

（2）在PSK会话恢复的过程中，ClientHello的扩展中配置了early data扩展，表示Client想要开启0-RTT模式。

（3）Server在Encrypted Extensions消息中携带了early data扩展表示同意读取early data。0-RTT模式开启成功。

只有同时满足了上面3个条件，才能开启0-RTT会话恢复模式。否则握手会是1-RTT的会话恢复模式。

0-RTT握手的流程图如下：

![](/images/https_handshake13_1_6.png)

![](/images/https_handshake13_1_7.png)

Client发送完early_data数据以后，还需要回一个EndOfEarlyData的子消息。

需要说明的是，目前不少浏览器虽然支持TLS 1.3协议，但是还不支持发送early data，所以它们也没法启用0-RTT模式的会话恢复。

备注：我理解0-RTT会话恢复中的early data应该是真实的应用数据，如HTTP GET/POST请求。

学习资料参考于：
https://halfrost.com/https_tls1-3_handshake/
https://github.com/halfrost/Halfrost-Field/blob/master/contents/Protocol/TLS_1.3_Handshake_Protocol.md
