---
title: TLS1.2中会话恢复机制中SessionID和SessionTicket
date: 2022-02-26 17:55:12
tags:
categories: HTTPS
---

# SSL中会话Session简介

SSL中的Session会跟HTTP的Session类似，都是用来保存客户端和服务端之间交互的一些记录。在SSL协议中一次TLS握手（密钥协商）的结果是建立了一条对称加密的数据通道，这条对称加密的数据通道的相关参数都是可以保存的，我们把这个信息称为TLS中Session信息，使用这个Session信息就可以直接复原对称加密的通信通道，从而省去了密钥协商的过程。

不管是SessionCache，SessionTicket，还是TLS1.3中的PSK，都是为了解决对称加密通道的快速恢复问题。

SessionID是RFC5246引入，SessionTicket是RFC5077引入。

# SessionID/SessionCache

当SSL的Session保存在服务端时，服务端OpenSSL会给每个Session分配一个SessionID，并将这个SessionID发送给客户端。当客户端再次请求（Client Hello）到达的时候，客户端携带SessionID，服务端就可以根据这个SessionID找到该客户端上次和服务端SSL加密通信的上下文信息，从而直接复原对称加密信道了，而不用再进行SSL握手密钥协商了。

需要注意的是，该种方式下，服务端需要为每个客户端都维护一个Session，服务端有一个专门维护Session信息的OpenSSL组件，即OpenSSL SessionCache，服务端去管理这些Session信息，会消耗大量的服务器内存资源。

备注：SessionID机制在服务端这边就涉及到各服务器或各集群要实现Session共享。若不支持客户端和服务端的SSL回话恢复的成功率就低了，因为当下一次请求解析到另外的服务端IP时，服务端是没有Session信息的。

# SessionTicket

从上面看到，Session Cache的一些问题，即SessionCache需要消耗大量的服务器存储资源。对称加密的上下文并不是一个非常轻量级的内容，当数目很大的时候，内存资源的消耗就会很可观，另外由服务器管理这个上下文也带来了极大的管理成本。另外一个思路就是将这件事情交给客户端。因为客户端和服务端对已经建立的加密信道拥有相同的知识，所以客户端完全可以做到存储这个上下文，但是这也不能使得服务端完全的从这个事物中解脱，因为服务端如果伪造一个上下文，就失去了认证的作用了。所以客户端存储的对称加密的上下文是要用服务器的私有密钥（Session Ticket Encryption Key，简写为STEK）加密过的，也就是经过服务器传输给客户端的。这样服务器在收到一个SessionTicket的时候，自己能够正常的解密就能证明确实是自己颁发的，从而杜绝了伪造。

也就是说，服务端发送给客户端的SessionTicket，只有服务端自己能解密，当客户端发送给服务端后，服务端用密钥解密，即可以恢复与该客户端的加密数据通道，即对称加密通道，而不再需要SSL握手密钥协商了。

SessionTicket相对于SessionID/SessionCache机制，它的最大优势是给服务端减轻压力，把一部分计算放在了客户端。因为服务端会解密SessionTicket，从而复原出对称加密的上下文，所以对于服务端来说这个开销也是很小。由于其天然的不需要在服务端存储内容，所以服务端当要组成集群的时候，只需要定期换一下SessionTicket用来加密的key即可。不像SessionCache那样需要自己做一个分布式的缓存。

客户端保存的SessionTicket是由服务端通过SSL握手协议中的NewSessionTicket报文传送给客户端的。

TLS1.2中的NewSessionTicket报文格式如下：

```c
struct { 
    uint32 ticket_lifetime_hint; 
    opaque ticket<0..2^16-1>; 
} NewSessionTicket;
```

其中一个字段是ticket_lifetime_hint，其单位是秒，用来告知客户端这个sessionticket的生命周期（老化时间），sessionticket就是主要包含了主秘钥等其他信息（客户端认证的话可能还包含客户端的证书）。

LS1.3中的NewSessionTicket报文格式如下：

```c
struct {
    uint32 ticket_lifetime;
    uint32 ticket_age_add;
    opaque ticket_nonce<0..255>;
    opaque ticket<1..2^16-1>;
    Extension extensions<0..2^16-2>;
} NewSessionTicket;
```

其中ticket_lifetime和TLS 1.2中的ticket_lifetime_hint含义一样，用以告知客户端ticket的老化时间。

# SessionID与SessionTicket对比

SessionID机制有一些弊端，负载均衡中，服务端多个主机IP之间往往没有同步Session信息，如果客户端两次请求没有落在同一台机器上就无法找到匹配的Session信息。然后服务端存储SessionID对应的信息不好控制失效时间，太短起不到作用，太长又占用服务端大量资源。

而SessionTicket可以解决这些问题，SessionTicket是用只有服务端知道的安全密钥加密过的会话信息，最终保存在浏览器端。浏览器如果在ClientHello时带上了SessionTicket，只要服务器能成功解密就可以完成快速握手，即服务端很容易在多个主机IP间共享Session信息。

Github上有一个名为[《rfc5077》](https://github.com/vincentbernat/rfc5077)的项目，非常适合用来测试服务端对SessionID和SessionTicket这两种TLS会话复用机制的支持情况。编译完成后，当前目录会出现多个可执行文件。这里我们只会用到rfc5077-client，它的用法举例如下：

```bash
./rfc5077-client -s imququ.com 114.215.116.12 139.162.98.188
```

![](/images/https_session_1_1.png)

从以上结果可以看出，禁用SessionTicket时，每次连接到不同IP都会导致Session无法复用；而启用SessionTicket后，不同IP之间也可以复用Session。符合前面的结论。值得注意的是，为了让一台服务器生成的SessionTicket能被另外服务器承认，往往需要对WebServer进行额外配置。例如在Nginx中，就需要通过ssl_session_ticket_key参数让多台机器使用相同的key文件（其实这里的可以就是服务端加密和解密SessionTicket的密钥），否则Nginx会使用随机生成的key文件，无法复用SessionTicket。出于安全考虑，key文件应该定期更换，并且确保换下来的key文件被彻底销毁。

需要注意的是，SessionTicket在服务端的多个主机IP间都能复用，也是需要服务端去做配置支持的哦。

# SessionID和SessionTicket的生成

SessionID是服务端生成，通过ServerHello报文中的SessionID字段将信息传递给客户端。SessionTicket是服务端生成，当客户端和服务端完成完整的SSL握手过程后，服务端会发送一个NewSessionTicket的报文给客户端，也即是SessionTicket啦。

# Nginx中SessionID和SessionTicket的配置

（1）Nginx SessionCache的配置

SessionCache在Apache中可以通过SSLSessionCache来配置，在Nginx中可以通过ssl_session_cache来进行设置。举例来说：

    ssl_session_cache shared:SSL:50m;
    ssl_session_timeout 1d;

上述配置表示共享缓存，缓存大小为50MB，会话的缓存时间1天，超过1天就过期失效了。

ssl_session_cache设置储存SSL会话的缓存类型和大小。默认值为ssl_session_cache off，off为关闭，还有一些其它的缓存类型，不过这里建议使用shared共享缓存类型，这种方法更为有效。

ssl_session_timeout客户端能够反复使用储存在缓存中的会话参数时间。

（2）Nginx SessionTicket的配置

SessionTicket在Apache中可以通过SSLTicketKeyDefault来配置，在Nginx中可以通过ssl_session_tickets来进行设置。举例来说：

    ssl_session_tickets on;
    ssl_session_ticket_key current.key;
    ssl_session_ticket_key previous.key;

Nginx中使用ssl_session_ticket_key file来配置用于加密和解密SSL SessionTicket的密钥，如果用了多个指令文件，则仅第一个指令文件中的密钥用来加密和解密；其它的密钥文件（下面的）用来解密，这样的原因是，我们最好定期轮换加解密的key，轮换的时候把旧的放在下面用来解密旧的SessionTicket，第一个放新的，用来加解密新的请求。如果没有配置key文件，则openssl默认会在ssl初始化的时候生成随机数的key；这种时候只有在重启web server的时候才会重新生成随机key。

# TLS1.3中PSK

在TLS1.3中，SessionCache和SessionTicket都被完全的取消，取而代之的是PSK（Pre Shared Key）。这个PSK并不是说每个客户端都要和服务端提前共享一个密钥，而是与握手相同的首先使用非对称加密方法直接提前协商一个密钥出来（psk_dhe_ke ），或者直接从之前协商出来的密钥参数中得出一个密钥（psk_ke）。

# 国内外主流CDN厂商对SessionID和SessionTicket的支持情况

![](/images/https_session_1_2.png)

学习资料参考于：
https://zhuanlan.zhihu.com/p/37826359
