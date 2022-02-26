---
title: HTTPS中Keyless SSL方案
date: 2022-02-27 00:20:13
tags:
categories: HTTPS
---

Keyless SSL方案，也即HTTPS卸载。

在使用第三方CDN的HTTPS服务时，如果要使用自己的域名，需要把对应的证书私钥给第三方，这也是一件风险很高的事情。CloudFlare公司针对这种场景研发了Keyless SSL技术。你可以不把证书私钥给第三方，改为提供一台实时计算的Key Server即可。CDN要用到私钥时，通过加密通道将必要的参数传给Key Server，由Key Server算出结果并返回即可。整个过程中，私钥都保管在自己的Key Server之中，不会暴露给第三方。

SSL协议是基于密码学的基础上，解决通信双方加密信道和身份鉴权的安全问题。SSL协议的算法本身是公开的，但是算法本身的输入参数（key）是由通信双方私自保存。在非对称加密中，服务端保存有一对公钥/私钥对，用于服务端鉴权和加密通信。服务端的私钥泄露会导致恶意攻击者伪造虚假的服务器和客户端通信。特别是源站把业务迁移到云或者CDN上，私钥的安全保存要求更高。

Keyless在方案，把服务器的私钥统一管理，并且把服务器的公钥算法中密钥协商的相关计算过程，加密解密的计算等，统一放在一组单独的机器上，这些机器在硬件或软件上都比较特殊，比如这些带有QAT硬件加速卡的机器，我们称这些机器为“Keyless Server”。

![](/images/https_keyless_1_1.png)

![](/images/https_keyless_1_2.png)

![](/images/https_keyless_1_3.png)

备注：像akamai那边把CDN侧的加解密计算，放在单独的Key Server来处理，这些Key Server在资源和底层硬件资源上都有特殊的地方，从而整体提高HTTPS的性能。
