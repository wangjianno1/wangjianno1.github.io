---
title: TLS1.2握手交互过程分析
date: 2022-02-26 17:36:52
tags:
categories: HTTPS
---

# TLS1.2首次完整握手过程(2-RTT)

TLS1.2版本以RSA密钥协商的过程如下：

![](/images/https_handshake12_1_1.png)

TLS1.2版本以DH密钥协商的过程如下：

![](/images/https_handshake12_1_2.png)

![](/images/https_handshake12_1_3.png)

备注：带星号`*`是表示是非必须的，可选择的，如客户端给服务端发送证书这个就是可选，不是所有的都需要双向验证的。其中ServerKeyExchange/ClientKeyExchange这两个报文是双方用来交换一些参数的，这些参数将来会用来生成对称密钥的。其中带中括号[]的ChangeCipherSpec表示它不是一个HandShake协议的一种报文，而是一个独立的ChangeCipherSpec协议。

HTTPS TLS1.2首次握手交互（2-RTT）过程文字描述如下：

（1）客户端发送一个ClientHello的信息到服务端，这个包含信息主要包含了客户端所支持的加密套件（cipher_suites）、支持的TLS版本（client_version）、会话ID（session_id）等数据。

（2）服务器在收到这个ClientHello后，会选择一个合适的加密套件cipher suites，然后返回一个ServerHello的信息，这当中包括了选中的加密套件。初此以外，还会发送证书以及密钥交换（ServerKeyExchange）。密钥交换的数据由选中的加密套件决定，比如使用ECDHE时，发送数据有椭圆曲线域参数、公钥的值（详情见 RFC 4492 section 5.4）。

（3）客户端收到ServerHello后，会对收到的证书进行验证。如果验证通过，则继续进行密钥交换流程，将客户端生成的公钥和服务端的结合，计算出本次会话的密钥，然后把公钥发送给服务端，最后再发送一个Finished信息。

（4）服务器收到客户端公钥信息，也会计算得出密钥，然后发送Finished信息。

（5）至此，握手阶段结束，加密连接开始。

从中可以看出，整个握手流程需要2-RTT，这在网络延迟较高的情况下是非常糟糕的，可能导致握手延迟增加几百毫秒。更糟糕的是，握手阶段的数据（如ServerHello阶段的信息），并不是加密的，中间人稍加利用，从中选择比较弱的加密算法，就可以带来降级攻击（Downgrade Attack）。

# TLS1.2会话恢复(1-RTT)

Client和Server只要一关闭连接，短时间内再次访问HTTPS网站的时候又需要重新连接。新的连接会造成网络延迟，并消耗双方的计算能力。有没有办法能复用之前的TLS连接呢？办法是有的，这就涉及到了TLS会话复用机制。Client和Server可以选择一个以前的会话或复制一个现存的会话，从而避免完整的握手交互过程。在TLS1.2中有两种会话恢复的机制，一种是基于SessionID，另一种是基于SessionTicket的。

（1）基于SessionID的会话恢复

Client发送的ClientHello中包含了之前已经建立了TLS连接的会话的SessionID，Server检查它的会话缓存SessionCache以进行匹配。如果匹配成功，并且Server愿意在指定的会话状态下重建连接，它将会发送一个带有相同SessionID值的ServerHello消息。这时，Client和Server必须都发送ChangeCipherSpec消息并且直接发送Finished消息。一旦重建立完成，Client和Server可以开始交换应用层数据（见下面的流程图）。如果一个SessionID不匹配，Server会产生一个新的SessionID，然后TLS Client和Server需要进行一次完整的握手。

![](/images/https_handshake12_1_4.png)

![](/images/https_handshake12_1_5.png)

（2）基于SessionTicket的会话恢复

用来替代SessionID会话恢复的方案是使用会话票证（SessionTicket）。使用这种方式，除了所有的状态都保存在客户端（与HTTP Cookie的原理类似）之外，其消息流与服务器会话缓存是一样的。

其思想是服务器取出它的所有会话数据（状态）并进行加密（密钥只有服务器知道），再以票证的方式发回客户端。在接下来的连接中，客户端恢复会话时在ClientHello的扩展字段session_ticket中携带加密信息将票证提交回服务器，由服务器检查票证的完整性，解密其内容，再使用其中的信息恢复会话。

对于Server来说，解密SessionTicket就可以得到主密钥。对于Client来说，完整握手的时候收到Server下发的NewSessionTicket子消息的时候，Client会将SesionTicket和对应的预备主密钥存在Client缓存中，简短握手的时候，一旦Server验证通过，可以进行简单握手的时候，Client通过本地存储的预备主密钥生成主密钥，最终再生成会话密钥（对称加密密钥）。

这种方法有可能使扩展服务器集群更为简单，因为如果不使用这种方式，就需要在服务集群的各个节点之间同步SessionCache。SessionTicket需要服务器和客户端都支持，属于一个扩展字段，占用服务器资源很少。

当Client本地获取了SessionTicket以后，下次想要进行简短握手，就可以使用这个SessionTicket了。Client在ClientHello的扩展中包含非空的SessionTicket扩展，如果Server支持SessionTicket会话恢复，则会在ServerHello中回复一个空的SessionTicket扩展（注意Sever一定要带上一个空的SessionTicket扩展，如果不带上这个扩展，表示Sever端不支持SessionTicket这个机制）。Server将会话信息进行加密保护，生成一个新的SessionTicket，通过NewSessionTicket子消息报文发给Client。发送完NewSessionTicket消息以后，紧跟着发送ChangeCipherSpec和Finished消息。Client收到上述消息以后，回应ChangeCipherSpec和Finished消息，会话恢复成功。

![](/images/https_handshake12_1_6.png)

![](/images/https_handshake12_1_7.png)

备注：客户端的SessionTicket是在双方在首次握手的完成后，是由Server通过NewSessionTicket消息报文发送给客户端的哦。

（3）一点特殊情况

如果Client在ClientHello中同时发送了SessionID和SessionTicket TLS扩展，Server必须是用ClientHello中相同的SessionID进行响应。但是在校验SessionTicket时，Sever不能依赖这个特定的SessionID，即不能用ClientHello中的SessionID判断是否可以会话恢复。Server优先使用SessionTicket进行会话恢复（SessionTicket优先级高于SessionID），如果SessionTicket校验通过，就继续发送ChangeCipherSpec和Finished消息。如果SessionTicket没有校验通过，那么服务端才会尝试使用SessionCache机制来恢复会话。

说白了，就是当客户端发出的ClientHello中既有SessionID又有非空的SessionTicket扩展时，Server端会优先尝试校验SessionTicket看是否可以恢复会话。若Server端校验SessionTicket成功后，会在ServerHello中带上和ClientHello中相同的SessionID作为响应，但是ServerHello中不会带上SessionTicket TLS扩展。若Server端校验SessionTicket失败后，Server端不会继续使用SessionID来重试会话重建，在返回的SeverHello报文中会带上一个空的SessionTicket扩展（注意，ClientHello中不会有SessionID信息），表示要进行完整SSL握手，且完整握手结束后，会发送新的NewSessionTicket报文给Client端。

![](/images/https_handshake12_1_8.png)

学习资料参考于：
https://halfrost.com/https_tls1-2_handshake/
