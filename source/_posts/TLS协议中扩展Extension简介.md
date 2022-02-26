---
title: TLS协议中扩展Extension简介
date: 2022-02-26 18:14:00
tags:
categories: HTTPS
---

# 扩展Extensions简介

扩展是TLS比较重要的一个知识点。它的存在能让Client和Server在不更新TLS版本的基础上，获得新的能力。Extension是TLS中的一系列可水平扩展的插件，是TLS中握手协议中ClientHello和ServerHello报文中的字段信息。

Client在ClientHello中申明多个自己可以支持的Extension，以向Server表示自己有以下这些能力，或者向Server协商某些协议。Server收到ClientHello以后，依次解析Extension，有些如果需要立即回应，就在ServerHello中作出回应，有些不需要回应，或者Server不支持的Extension就不用响应，忽略不处理。

# TLS1.2中一些扩展Extension

（1）server_name

我们知道，在Nginx中可以通过指定不同的server_name来配置多个站点。HTTP/1.1协议请求头中的Host字段可以标识出当前请求属于哪个站点。但是对于HTTPS网站来说，要想发送HTTP数据，必须等待SSL握手完成，而在握手阶段服务端就必须提供网站证书。对于在同一个IP部署不同HTTPS站点，并且还使用了不同证书的情况下，服务端怎么知道该发送哪个证书？

Server Name Indication，简称为SNI，是TLS的一个扩展，为解决这个问题应运而生。有了SNI，服务端可以通过ClientHello中的SNI扩展拿到用户要访问网站的Server Name，进而发送与之匹配的证书，顺利完成SSL握手。

server_name扩展比较简单，存储的就是Server的名字。

TLS没有为Client提供一种机制来告诉Server它正在建立链接的Server的名称。Client可能希望提供此信息以促进与在单个底层网络地址处托管多个“虚拟”服务的Server的安全连接。

当Client连接HTTPS网站的时候，解析出IP地址以后，就能创建TLS连接，在握手完成之前，Server接收到的消息中并没有Host HTTP的头部。如果这个Server有多个虚拟的服务，每个服务都有一张证书，那么此时Server不知道该用哪一张证书。

于是为了解决这个问题，增加了SNI扩展。用这个扩展就能区别出各个服务对应的证书了。

（2）supported_groups

这个扩展原名叫"elliptic_curves"，后来更名成"supported_groups"。从原名的意思就能看出来这个扩展的意义。它标识了Client支持的椭圆曲线的种类。举例来说，Client支持椭圆曲线有x25519、secp256r1、secp384r1、secp521r1等等。

（3）SessionTicket TLS

这个扩展表明了Client端是否有上次会话保存的SessionTicket，如果有，则表明Client希望基于SessionTicket的方式进行会话恢复。

（4）application_layer_protocol_negotiation，ALPN

Application Layer Protocol Negotiation，ALPN应用层协议扩展。由于应用层协议存在多个版本，Client在TLS握手的时候想知道应用层用的什么协议。基于这个目的，ALPN协议就出现了。ALPN希望能协商出双方都支持的应用层协议，应用层底层还是基于TLS/SSL协议的。

![](/images/https_extend_1_1.png)

（5）signature_algorithms

Client使用"signature_algorithms"扩展来向Server表明哪个签名/hash算法对会被用于数字签名。这个扩展的"extension_data"域包含了一个"supported_signature_algorithms"值。

# TLS1.3中的一些特有扩展Extension

（1）supported_versions

在TLS 1.3中，ClientHello中的supported_versions扩展非常重要。因为TLS 1.3是根据这个字段的值来协商是否支持TLS 1.3 。在TLS 1.3规范中规定，ClientHello中的legacy_version必须设置为0x0303，这个值代表的是TLS 1.2。这样规定是为了对网络中间件做的一些兼容。如果此时ClientHello中不携带supported_versions这个扩展，那么注定只能协商TLS 1.2了。

Client在ClientHello的supported_versions扩展中发送自己所能支持的TLS版本。Server收到以后，在ServerHello中的supported_versions扩展响应Client，告诉Client接下来进行哪个TLS版本的握手。

（2）supported groups

当Client发送"supported_groups”扩展时，是为了表明了Client支持的用于密钥交换的命名组。按照优先级从高到低。说白了，就是Client支持的密钥协商的(EC)DHE的具体名称。

（3）key_share

在TLS 1.3中，之所以能比TLS 1.2快的原因，原因之一就在key_share这个扩展上。key_share扩展内包含了(EC)DHE groups需要协商密钥参数，这样不需要再次花费1-RTT进行协商了。

"supported_groups"的扩展和"key_share"扩展配合使用。“supported_groups”这个扩展表明了Client支持的(EC)DHE groups，"key_share"扩展表明了Client是否包含了对应“supported_groups”的一些或者全部的（EC）DHE共享参数。说白了，就是将TLS1.2中ClientKeyExchange中的共享参数，在TLS1.3中直接通过ClientHello传递给Server，这也是TLS1.3的首次完整握手能降低到1-RTT的原因。

（3）psk_key_exchange_modes

在TLS 1.3会话恢复中出现。为了使用PSK，Client还必须发送一个"psk_key_exchange_modes"扩展。这个扩展语意是Client仅支持使用具有这些模式的PSK。这就限制了在这个ClientHello中提供的PSK的使用，也限制了Server通过NewSessionTicket提供的PSK的使用。

如果Client提供了"pre_shared_key"扩展，那么它必须也要提供"psk_key_exchange_modes"扩展。如果Client发送不带"psk_key_exchange_modes"扩展名的"pre_shared_key"，Server必须立即中止握手。Server不能选择一个Client没有列出的密钥交换模式。此扩展还限制了与PSK恢复使用的模式。Server也不能发送与建议的modes不兼容的NewSessionTicket。不过如果Server一定要这样做，影响的只是Client在尝试恢复会话的时候会失败。

Server不能发送"psk_key_exchange_modes”扩展。

（4）pre_shared_key

在TLS 1.3会话重建恢复中出现。"pre_shared_key"预共享密钥和"psk_key_exchange_modes"扩展配合使用。预共享密钥扩展包含了Client可以识别的对称密钥标识。"psk_key_exchange_modes"扩展表明了可能可以和psk一起使用的密钥交换模式。

（5）early_data

在TLS1.3会话恢复中出现。当使用PSK并且PSK允许使用early_data的时候，Client可以在其第一个消息中发送应用数据。如果Client选择这么做，则必须发送"pre_shared_key"和"early_data"扩展。

# 其他的一些扩展

（1）padding

属于一个填充扩展，目的是让ClientHello的达到指定的大小，以避免一些异常情况，填充的内容就是0比特。这个扩展是在ClientHello的最后面。可以参见[IETF官方说明](https://tools.ietf.org/html/rfc7685)

学习资料参考于：
https://halfrost.com/https-extensions/
