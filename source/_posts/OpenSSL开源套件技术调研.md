---
title: OpenSSL开源套件技术调研
date: 2018-02-03 19:34:23
tags:
categories: Security
---

# OpenSSL开源套件简介

OpenSSL是一个开源程序的套件，这个套件有三个部分组成，如下：

（1）libcryto

libcryto是一个具有通用功能的加密库，里面实现了众多的加密库；

（2）libssl

libssl是实现SSL机制的，它是用于实现TLS/SSL的功能；

（3）openssl

openssl是个多功能命令行工具，它可以实现加密解密，甚至还可以当CA来用，可以让你创建证书、吊销证书。

# openssl工具常用命令

openssl工具命令支持的功能丰富，包括生成公私钥、生成X.509证书以及SSL/TLS客户端/服务端模拟等等。如下为几个常用的openssl子命令：

```bash
openssl ca       #给CSR签名，从而颁发证书相关
openssl genrsa   #生成RSA加密算法的私钥
openssl rsa      #RSA加密算法的密钥管理，例如生成RSA的公钥
openssl gendsa   #生成DSA加密算法的私钥
openssl dsa      #DSA加密算法的密钥管理，例如生成DSA的公钥
openssl req      #CSR文件管理，包括生成CSR文件并管理等其他操作
openssl x509     #x.509标准格式的证书管理
```

如下为openssl常用的命令举例：

（1）查看openssl版本

```bash
openssl version
openssl version -a
```

（2）生成私钥

```bash
openssl genrsa -out rsa_private_key.pem 1024  #生成RSA加密算法的私钥，是1024Bit的
```

（3）生成公钥

```bash
openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem  #指定私钥，来生成公钥
```

（4）生成CSR文件（即未签名的SSL证书）

```bash
openssl req -new -key rsa_private_key.pem -out wahaha.csr  #生成CSR文件wahaha.csr
```

（5）使用私钥给CSR文件签名，从而生成证书

```bash
#–signkey ca-key.pem参数指定的是用来签名的私钥，这个私钥正常来说是CA的私钥。在本例子中，使用的自己的私钥rsa_private_key.pem来签名的，因此这是一张自签名的证书。一般来说，顶级证书或根证书都是自签名的证书。
openssl x509 -req -in wahaha.csr -out wahaha.pem -signkey rsa_private_key.pem -days 3650
```
