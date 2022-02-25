---
title: HTTPS双向认证过程及配置
date: 2018-02-03 19:26:45
tags:
categories: HTTPS
---

# HTTPS双向认证简介

SSL双向认证就是，客户端要获取服务端的证书，检查下服务端是不是我可以信任的主机，否则我就认为那个站点的内容不可信任，不应该去访问你（浏览器会告诉你）。同时服务端也要检查客户端的证书，客户端如果不是服务端所信任的，那服务端也会认为，你不是我的合法用户，我拒绝给你提供服务。所以，要让HTTPS的双向认证顺利完成，就要在服务端给定一个证书，这个证书是浏览器可信任的，同时客户端（浏览器）也要发送给服务端一个证书，服务器端也要信任这个证书。

# HTTPS双向认证配置步骤

一、自建CA根证书

（1）生成根证书的私钥

```bash
openssl genrsa -out ca-key.pem 2048
```

![](/images/https_1_1.png)

（2）生成根证书的CSR文件

```bash
openssl req -new -key ca-key.pem -out ca-req.csr -days 3650
```

![](/images/https_1_2.png)

（3）使用自己的私钥签名CSR文件，生成自签名的根证书

```bash
openssl x509 -req -in ca-req.csr -out ca-cert.pem -signkey ca-key.pem -days 3650
```

![](/images/https_1_3.png)

（4）将pem的CA证书转换为DER格式

```bash
openssl x509 -in ca-cert.pem -out ca.der -outform DER
```

效果如下：

![](/images/https_1_4.png)

在windows上打开证书的效果如下：

![](/images/https_1_5.png)

二、用自建CA颁发客户端证书

（1）生成客户端证书的私钥

```bash
openssl genrsa -out wzjtest-key.pem 2048
```

![](/images/https_1_6.png)

（2）生成客户端证书的CSR文件

```bash
openssl req -new -key wzjtest-key.pem -out wzjtest-req.csr -days 3650
```

![](/images/https_1_7.png)

（3）使用自建的CA为客户端证书签名

```bash
openssl x509 -req -in wzjtest-req.csr -out wzjtest-cert.pem -days 3650 -CA ../ca/ca-cert.pem -CAkey ../ca/ca-key.pem -CAcreateserial
```

![](/images/https_1_8.png)

（4）将客户端证书的格式从pem转换为der

```bash
openssl x509 -in wzjtest-cert.pem -out wzjtest.der -outform DER
```

![](/images/https_1_9.png)

在windows下打开客户端证书效果如下：

![](/images/https_1_10.png)

![](/images/https_1_11.png)

（5）将客户端证书格式转换成PKCS #12格式

```bash
openssl pkcs12 -export -clcerts -in wzjtest-cert.pem -inkey wzjtest-key.pem -out wzjtest.p12
```

![](/images/https_1_12.png)

三、在原有的https服务端上开启客户端证书验证

一般来说，我们的https都是单向验证的，下面是开启了双向认证的nginx配置：

![](/images/https_1_13.png)

四、测试验证

（1）使用浏览器测试

可以在浏览器中先导入自己签发的私钥，然后再访问需要双向认证的站点。

（2）使用openssl工具测试

```bash
openssl s_client -quiet -servername wahaha.sohuno.com -connect 10.16.57.158:443
```

![](/images/https_1_14.png)

```bash
openssl s_client -quiet -servername wahaha.sohuno.com -connect 10.16.57.158:443 -cert lv2/test-lv2-cert.pem -key lv2/test-lv2-key.pem
```

![](/images/https_1_15.png)


学习资料参考于：
http://itindex.net/detail/52620-nginx-https-%E8%AE%A4%E8%AF%81
