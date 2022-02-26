---
title: 加密套件Cipher Suites
date: 2022-02-26 23:50:12
tags:
categories: HTTPS
---

# 加密套件Cipher Suites简介

Cipher Suite加密套件。在HTTPS的交互过程中，需要有“密钥协商算法”、“数字签名算法”，“对称加密算法”以及“数据散列算法（数字签名生产和验证的时候会使用）”。常用的加密套件有：

![](/images/https_suites_1_1.png)

Cipher Suite中包含了多种技术，包括认证算法Authentication、加密算法Encryption、消息认证码算法Message Authentication Code（MAC）、密钥交换算法Key Exchange和密钥衍生算法Key Derivation Function。

SSL的CipherSuite协商机制具有良好的扩展性，每个Cipher Suite都需要在IANA注册，并被分配两个字节的标志。全部CipherSuite可以在IANA的[《TLS Cipher Suite Registry页面》](https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-4)中查看。

OpenSSL库支持的全部Cipher Suite可以通过以下命令查看：

![](/images/https_suites_1_2.png)

以TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256来说，ECDHE是秘钥交换算法，RSA身份验证算法，即数字签名算法，AES_128_GCM对称加密算法，SHA256摘要算法。

TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384来说，ECDHE是密钥协商算法，ECDSA是身份验证算法，AES_256_GCM是加密模式，由于GCM是属于AEAD加密模式，所以整个密码套件无须另外的HMAC，SHA384指的是伪随机数生成函数PRF算法。

![](/images/https_suites_1_3.png)

# TLS1.3支持的加密套件

在TLS1.3中，将Cipher Suites拆成两个部分，一个是Cipher Suites，另一个是密钥协商算法KeyAgreement。也就是TLS1.3的Cipher Suites没有密钥协商相关的信息了。

目前来说，TLS1.3只支持DHE和ECDHE两种密钥协商算法了。TLS 1.3规范中只支持5种密钥套件，TLS13-AES-256-GCM-SHA384、TLS13-CHACHA20-POLY1305-SHA256、TLS13-AES-128-GCM-SHA256、TLS13-AES-128-CCM-8-SHA256、TLS13-AES-128-CCM-SHA256，隐藏了密钥协商算法，因为默认都是椭圆曲线密钥协商，即DHE或ECDHE。

# 映射表

![](/images/https_suites_1_4.png)
