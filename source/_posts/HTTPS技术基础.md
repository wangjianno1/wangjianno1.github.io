---
title: HTTPS技术基础
date: 2022-02-26 16:10:38
tags:
categories: HTTPS
---

# SSL简介

SSL是Secure socket Layer英文缩写，它的中文意思是安全套接层协议。SSL是Netscape所研发，用以保障在Internet上数据传输的安全的一个协议。SSL因为应用广泛，成为互联网的事实标准，然后IETF组织就把SSL进行标准化，标准化后改名为TLS（全称为Transport Layer Security），所以SSL和TLS一般被并列称呼为SSL/TLS，两者可以视作同一个东西的不同阶段。

# SSL/TLS协议版本的演进及二者的关系

（1）SSL1.0、SSL2.0与SSL3.0

SSL，Secure Sockets Layer是网景公司（Netscape）设计的主要用于Web的安全传输协议，这种协议在Web上获得了广泛的应用。SSL基础算法由作为网景公司的首席科学家塔希尔·盖莫尔（Taher Elgamal）编写，他被人称为“SSL之父”。SSL的版本演进：

SSL 1.0版本从未公开过，因为存在严重的安全漏洞。

SSL 2.0版本在1995年2月发布，但因为存在数个严重的安全漏洞而被3.0版本替代。

SSL 3.0版本在1996年发布，是由网景工程师Paul Kocher、Phil Karlton和Alan Freier完全重新设计的。

（2）TLS 1.0

IETF将SSL标准化，即RFC 2246，并将其称为TLS（Transport Layer Security）。从技术上讲，TLS 1.0与SSL 3.0的差异非常微小。

（3）TLS 1.1

TLS 1.1在RFC 4346中定义，于2006年4月发表，它是基于TLS 1.0的更新。在此版本中的差异包括：添加对CBC攻击的保护、隐式IV被替换成一个显式的IV、更改分组密码模式中的填充错误以及支持IANA登记的参数等等。

（4）TLS 1.2

TLS 1.2在RFC 5246中定义，于2008年8月发表。它基于更早的TLS 1.1规范。主要区别包括：

    可使用密码组合选项指定伪随机函数使用SHA-256替换MD5-SHA-1组合;
    可使用密码组合选项指定在完成消息的哈希认证中使用SHA-256替换MD5-SHA-1算法，但完成消息中哈希值的长度仍然被截断为96位;
    在握手期间MD5-SHA-1组合的数字签名被替换为使用单一Hash方法，默认为SHA-1;
    增强服务器和客户端指定Hash和签名算法的能力;
    扩大经过身份验证的加密密码，主要用于GCM和CCM模式的AES加密的支持;
    添加TLS扩展定义和AES密码组合

（5）TLS 1.3

截至2016年1月，TLS 1.3还是一个互联网草案，细节尚属临时并且不完整。它基于更早的TLS 1.2规范，与TLS 1.2的主要区别包括：

    移除脆弱和较少使用的命名椭圆曲线支持
    移除MD5和SHA-224密码散列函数的支持
    请求数字签名，即便使用之前的配置
    集成HKDF和半短暂DH提议
    替换使用PSK和票据的恢复
    支持1-RTT握手和初步支持0-RTT
    放弃许多不安全或过时特性的支持，包括数据压缩、重新协商、非AEAD密码本、静态RSA和静态DH密钥交换、自定义DHE分组、点格式协商、更改密码本规范的协议、UNIX时间的Hello消息，以及长度字段AD输入到AEAD密码本
    禁止用于向后兼容性的SSL和RC4协商
    集成会话散列的使用
    弃用记录层版本号和冻结数以改进向后兼容性
    将一些安全相关的算法细节从标准移动到标准，并将ClientKeyShare降级到附录
    添加Curve25519和Ed25519到TLS标准。

![](/images/https_basic_1_1.png)

补充说明：

A）所有TLS版本在2011年3月发布的RFC 6176中删除了对SSL的兼容，这样TLS会话将永远无法协商使用的SSL 2.0以避免安全问题

B）2014年10月，Google发布在SSL 3.0中发现设计缺陷，建议禁用此一协议。攻击者可以向TLS发送虚假错误提示，然后将安全连接强行降级到过时且不安全的SSL 3.0，然后就可以利用其中的设计漏洞窃取敏感信息。Google在自己公司相关产品中陆续禁止向后兼容，强制使用TLS协议。Mozilla也在11月25日发布的Firefox 34中彻底禁用了SSL 3.0。微软同样发出了安全通告。

# SSL协议所涉及到协议安全机制

（1）数据传输加密：利用加密算法对传输的数据进行加密

（2）身份验证机制：基于证书，利用数据签名方法对服务器和客户端进行身份验证。其中客户端的验证是可选的。

（3）消息完整性验证：消息传输过程中使用MAC算法来检验消息的完整性，以防止传输数据被他人篡改。

# SSL证书的申请和部署流程

（1）生成私钥和CSR文件

CSR是Cerificate Signing Request的英文缩写，即证书请求文件。证书申请者在申请数字证书时需要生成私钥，也需要生成证书请求文件，证书申请者只要把CSR文件提交给证书颁发机构后，证书颁发机构就会依据此来为证书请求者颁发数字证书。私钥则需要证书申请者自己保管。生成CSR的工具可以是openssl，也可以是证书颁发机构提供的工具或web在线生成工具。

（2）在服务器端安装数字证书

以Nginx的SSL配置为例，将私钥server.key以及数字证书server.pem文件放到Nginx的conf目录中。然后在nginx.conf配置文件添加如下配置：


    server {
        listen       443;
        server_name  localhost;
        ssl                  on;
        ssl_certificate      server.pem;
        ssl_certificate_key  server.key;
        ssl_session_timeout  5m;
        ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;#启用TLS1.1、TLS1.2要求OpenSSL1.0.1及以上版本，若您的OpenSSL版本低于要求，请使用 ssl_protocolsTLSv1;
        ssl_ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!NULL:!DH:!EDH:!EXP:+MEDIUM;
        ssl_prefer_server_ciphers   on;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }

# HTTPS交互过程

HTTPS交互过程如下：

（1）客户端发起HTTPS请求

用户在浏览器里输入一个HTTPS网址。

（2）服务器传送证书

服务器端将数字证书以及证书的数字签名发送给浏览器。

（3）浏览器端对数字证书进行验证

CA在颁发证书时，首先使用哈希函数对待签名内容进行安全哈希，生成消息摘要，然后使用CA自己的私钥对消息摘要进行签名。浏览器端使用CA的公钥（一般来说，CA的证书已经内置安装到浏览器中啦，所以浏览器很容易获知CA的公钥哦）进行签名验证，如果验证通过，说明数字证书确实是CA机构颁发的，同时也获取到了消息摘要M1。然后使用相同的哈希算法对证书中的内容计算出消息摘要M2，若M1和M2如果一样，则说明数字证书是完整的。

（4）浏览器使用服务器端数字证书中的公钥将“对称加密的秘钥”发送给服务端。

（5）服务端使用私钥解析浏览器发过来的数据，得到后面需要用到的对称加密的秘钥。

（6）服务器和浏览端之间就开始使用对称加密的方式来进行应用数据的传递。

![](/images/https_basic_1_2.png)

备注：HTTPS交互主要有两个过程，一个是秘钥协商阶段（亦叫密钥交换或SSL握手），一个是应用数据传输阶段。在秘钥协商阶段使用非对称加密来交互，而在应用数据传输阶段使用对称加密的方式。非对称加密计算量占整个握手过程的90%以上。而对称加密的计算量只相当于非对称加密的0.1%，如果应用层数据也使用非对称加解密，性能开销太大，无法承受。

有一个更完整的过程图如下：

![](/images/https_basic_1_3.png)

# 秘钥协商阶段的非对称加密算法

在客户端和服务器开始交换TLS所保护的加密信息之前，他们必须安全地交换或协定加密密钥和加密数据时要使用的密码。用于密钥交换的方法包括：

（1）TLS_RSA

使用RSA算法生成公钥和私钥（在TLS 握手协议中被称为TLS_RSA）

（2）TLS_DH

Diffie-Hellman（在TLS握手协议中被称为TLS_DH）

（3）TLS_DHE

临时Diffie-Hellman（在TLS握手协议中被称为TLS_DHE）

（4）TLS_ECDH

椭圆曲线迪菲-赫尔曼（在TLS握手协议中被称为TLS_ECDH）

（5）TLS_ECDHE

临时椭圆曲线Diffie-Hellman（在TLS握手协议中被称为TLS_ECDHE）

（6）TLS_DH_anon

匿名Diffie-Hellman（在TLS握手协议中被称为TLS_DH_anon）

（7）TLS_PSK

预共享密钥（在TLS握手协议中被称为TLS_PSK）

详细的算法如下：

![](/images/https_basic_1_4.png)

# 数据传输阶段的对称加密算法

![](/images/https_basic_1_5.png)

# 关于SSL的一点闲话

（1）HTTPS，Hypertext Transfer Protocol Secure，安全超文本传输协议。是HTTP协议的安全版本。HTTPS是基于SSL安全连接的HTTP协议。HTTPS通过SSL提供的数据加密、身份验证和消息完整性验证等安全机制，为Web访问提供了安全性保证，广泛应用于网上银行、电子商务等领域。

（2）OpenSSL是一个开放源代码的SSL协议的产品实现，它采用C语言作为开发语言，具备了跨系统的性能。在系统中调用OpenSSL的函数就可以实现一个SSL加密的安全数据传输通道，配合使用USBKey来储存key等机密信息，从而达到秘密性，完整性，认证性的目的。

学习资料参考于：
http://blog.csdn.net/zhuyingqingfen/article/details/7610098
http://blog.csdn.net/angela_615/article/details/5358280
https://zh.wikipedia.org/wiki/%E5%82%B3%E8%BC%B8%E5%B1%A4%E5%AE%89%E5%85%A8%E5%8D%94%E8%AD%B0
https://www.ssllabs.com/ssltest/
