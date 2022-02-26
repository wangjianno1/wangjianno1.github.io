---
title: SSL数字证书标准(X.509)及编码格式(PEM|DER)
date: 2018-02-03 18:52:53
tags:
categories: HTTPS
---

# SSL数字证书标准X.509

SSL数字证书没有单一的全球标准，不过现在使用的大多数SSL证书都以一种标准格式——X.509 v3来存储它们的信息。X.509数字证书标准，定义证书文件的结构和内容，详情参考RFC5280。SSL数字证书通常采用这种标准，一般由用户公共密钥和用户标识符组成，此外还包括版本号、证书序列号、CA标识符、签名算法标识、签发者名称、证书有效期等信息。X.509 v3证书提供了一种标准的方式，将证书信息规范至一些可解析字段中。尽管不同类型的证书有不同的字段值，但大部分都遵循X.509 v3结构。如下为X.509 v3证书中的一些字段信息：

![](/images/x.509_1_1.png)

# 数字证书的编码格式

X.509 标准的证书文件具有不同的编码格式，一般包括PEM和DER两种：

（1）PEM

PEM，是Privacy Enhanced Mail的缩写，以文本的方式进行存储。它的文件结构以`-----BEGIN XXX-----`开头，并以`-----END XXX-----`为结尾，中间Body内容为Base64编码过的数据。以PEM格式存储的证书结构大概如下：

	-----BEGIN CERTIFICATE-----
	Base64编码过的证书数据
	-----END CERTIFICATE-----

它也可以用来编码存储公钥（RSA PUBLIC KEY）、私钥（RSA PRIVATE KEY）、证书签名请求（CERTIFICATE REQUEST）等数据。一般Apache和Nginx服务器应用偏向于使用PEM这种编码格式。

（2）DER

DER，是Distinguished Encoding Rules的缩写，以二进制方式进行存储，文件结构无法直接预览，同样可以通过如下OpenSSL命令查看其证书内容。一般Java和Windows服务器应用偏向于使用DER这种编码格式。当然同一X.509证书的不同编码之间可以互相转换。

# 证书相关的一些扩展名

如上所述，对于X.509标准的证书两种不同编码格式，一般采用PEM编码就以.pem作为文件扩展名，若采用DER编码，就应以.der作为扩展名。但常见的证书扩展名还包括.crt、.cer、.p12等，他们采用的编码格式可能不同，内容也有所差别，但大多数都能互相转换，现总结如下：

（1）.pem

采用PEM编码格式的X.509证书的文件扩展名。

（2）.der

采用DER编码格式的X.509证书的文件扩展名。

（3）.crt

即certificate的缩写，常见于类UNIX系统，有可能是PEM编码，也有可能是DER编码，但绝大多数情况下此格式证书都是采用PEM编码。

（4）.cer

也是certificate的缩写，常见于Windows系统，同样地，可能是PEM编码，也可能是DER编码，但绝大多数情况下此格式证书都是采用DER编码。

（5）.p12

也写作.pfx，全称为PKCS #12，是公钥加密标准（Public Key Cryptography Standards，PKCS）系列的一种，它定义了描述个人信息交换语法（Personal Information Exchange Syntax）的标准，可以用来将包含了公钥的X.509证书和证书对应的私钥以及其他相关信息打包，进行交换。简单理解为·`一份.p12文件 = X.509证书 + 私钥`。

（6）.csr

Certificate Signing Request的缩写，即证书签名请求，它并不是证书的格式，而是用于向权威证书颁发机构（Certificate Authority, CA）获得签名证书的申请，其核心内容包含一个RSA公钥和其他附带信息，在生成这个.csr申请的时候，同时也会生成一个配对RSA私钥，私钥通常需要严格保存于服务端，不能外泄。

（7）.key

通常用来存放一个RSA公钥或者私钥，它并非X.509证书格式，编码同样可能是PEM，也可能是DER。

备注：各种证书格式之间是可以相互转换的哦。


学习资料参考于：
http://www.cnblogs.com/guogangj/p/4118605.html
https://kangzubin.com/certificate-format/
https://www.chinassl.net/faq/n509.html
