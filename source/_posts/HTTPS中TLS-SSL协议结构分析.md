---
title: HTTPS中TLS/SSL协议结构分析
date: 2022-02-26 16:19:42
tags:
categories: HTTPS
---

# TLS/SSL协议结构

TLS/SSL协议位于应用层和传输层TCP协议之间。

![](/images/https_protocol_1_1.png)

TLS粗略地又可以划分为两层：

（1）靠近应用层的握手协议TLS Handshaking Protocols

（2）靠近TCP的记录层协议TLS Record Protocol

TLS握手协议TLS Handshaking Protocols还能细分为5个子协议：

（1）change_cipher_spec (在TLS 1.3中这个协议已经删除，为了兼容TLS老版本，可能还会存在)

（2）alert

（3）handshake

（4）application_data

（5）heartbeat（这个是TLS 1.3新加的，TLS 1.3之前的版本没有这个协议）

这些子协议之间的关系可以用下图来表示：

![](/images/https_protocol_1_2.png)

备注：当双方通过密钥协商过程得到会话密钥后，传输的加密数据，就走到了“应用数据协议”。

# TLS记录层协议

记录层将上层的信息块分段为TLSPlaintext记录，TLSPlaintext中包含2^14字节或更少字节块的数据。

![](/images/https_protocol_1_3.png)

备注：上图中Protocol Version是一个字段，占2个字节；length length也是一个字段，占两个字段。相关结构体如下：

```c
enum {
    invalid(0),
    change_cipher_spec(20),
    alert(21),
    handshake(22),
    application_data(23),
    heartbeat(24),  /* RFC 6520 */
    (255)
} ContentType;

// TLS记录层的完整结构
struct {
    ContentType type;
    ProtocolVersion legacy_record_version;
    uint16 length;
    opaque fragment[TLSPlaintext.length];
} TLSPlaintext;
```

# TLS密码切换协议

change_cipher_spec（以下简称CCS协议） 协议，是TLS记录层对应用数据是否进行加密的分界线。客户端或者服务端一旦收到对端发来的CCS协议，就表明接下来传输数据过程中可以对应用数据协议进行加密了。

经过TLS记录层包装以后（也就是说下面的结构是TLS记录层的完整结构，下面的Message Header头也是TLS记录层的协议头。然后后面的其他子协议都是一样的哦），结构如下:

![](/images/https_protocol_1_4.png)

TLS密码切换协议数据结构如下：

```c
struct {
    enum { 
    	change_cipher_spec(1), 
    	(255) 
    } type;
} ChangeCipherSpec;
```

# TLS警告协议

经过TLS记录层包装以后，结构如下:

![](/images/https_protocol_1_5.png)

TLS警告协议数据结构如下：

```c
enum { 
    warning(1), 
    fatal(2), 
    (255) 
} AlertLevel;

struct {
    AlertLevel level;
    AlertDescription description;
} Alert;
```

TLS 1.2的所有警告描述信息如下：

```c
enum {
    close_notify(0),
    unexpected_message(10),
    bad_record_mac(20),
    decryption_failed_RESERVED(21),
    record_overflow(22),
    decompression_failure(30),
    handshake_failure(40),
    no_certificate_RESERVED(41),
    bad_certificate(42),
    unsupported_certificate(43),
    certificate_revoked(44),
    certificate_expired(45),
    certificate_unknown(46),
    illegal_parameter(47),
    unknown_ca(48),
    access_denied(49),
    decode_error(50),
    decrypt_error(51),
    export_restriction_RESERVED(60),
    protocol_version(70),
    insufficient_security(71),
    internal_error(80),
    user_canceled(90),
    no_renegotiation(100),
    unsupported_extension(110),  /* new */
       (255)
} AlertDescription;
```

TLS 1.3的所有警告描述信息如下：

```c
enum {
    close_notify(0),
    unexpected_message(10),
    bad_record_mac(20),
    decryption_failed_RESERVED(21),
    record_overflow(22),
    decompression_failure_RESERVED(30),
    handshake_failure(40),
    no_certificate_RESERVED(41),
    bad_certificate(42),
    unsupported_certificate(43),
    certificate_revoked(44),
    certificate_expired(45),
    certificate_unknown(46),
    illegal_parameter(47),
    unknown_ca(48),
    access_denied(49),
    decode_error(50),
    decrypt_error(51),
    export_restriction_RESERVED(60),
    protocol_version(70),
    insufficient_security(71),
    internal_error(80),
    inappropriate_fallback(86),
    user_canceled(90),
    no_renegotiation_RESERVED(100),
    missing_extension(109),
    unsupported_extension(110),
    certificate_unobtainable_RESERVED(111),
    unrecognized_name(112),
    bad_certificate_status_response(113),
    bad_certificate_hash_value_RESERVED(114),
    unknown_psk_identity(115),
    certificate_required(116),
    no_application_protocol(120),
    (255)
} AlertDescription;
```

# TLS握手协议

握手协议是整个TLS协议簇中最最核心的协议，HTTPS能保证安全也是因为它的功劳。经过TLS记录层包装以后，结构如下:

![](/images/https_protocol_1_6.png)

TLS 1.2握手协议数据结构如下：

```c
enum {
    hello_request(0), 
    client_hello(1), 
    server_hello(2),
    certificate(11), 
    server_key_exchange (12),
    certificate_request(13), 
    server_hello_done(14),
    certificate_verify(15), 
    client_key_exchange(16),
    finished(20)
    (255)
} HandshakeType;

struct {
    HandshakeType msg_type;
    uint24 length;
    select (HandshakeType) {
        case hello_request:       HelloRequest;
        case client_hello:        ClientHello;
        case server_hello:        ServerHello;
        case certificate:         Certificate;
        case server_key_exchange: ServerKeyExchange;
        case certificate_request: CertificateRequest;
        case server_hello_done:   ServerHelloDone;
        case certificate_verify:  CertificateVerify;
        case client_key_exchange: ClientKeyExchange;
        case finished:            Finished;
    } body;
} Handshake;
```

TLS 1.3协议数据结构如下：

```c
enum {
    hello_request_RESERVED(0),
    client_hello(1),
    server_hello(2),
    hello_verify_request_RESERVED(3),
    new_session_ticket(4),
    end_of_early_data(5),
    hello_retry_request_RESERVED(6),
    encrypted_extensions(8),
    certificate(11),
    server_key_exchange_RESERVED(12),
    certificate_request(13),
    server_hello_done_RESERVED(14),
    certificate_verify(15),
    client_key_exchange_RESERVED(16),
    finished(20),
    certificate_url_RESERVED(21),
    certificate_status_RESERVED(22),
    supplemental_data_RESERVED(23),
    key_update(24),
    message_hash(254),
    (255)
} HandshakeType;

struct {
    HandshakeType msg_type;    /* handshake type */
    uint24 length;             /* bytes in message */
    select (Handshake.msg_type) {
        case client_hello:          ClientHello;
        case server_hello:          ServerHello;
        case end_of_early_data:     EndOfEarlyData;
        case encrypted_extensions:  EncryptedExtensions;
        case certificate_request:   CertificateRequest;
        case certificate:           Certificate;
        case certificate_verify:    CertificateVerify;
        case finished:              Finished;
        case new_session_ticket:    NewSessionTicket;
        case key_update:            KeyUpdate;
    };
} Handshake;
```

# TLS应用数据协议

应用数据协议就是TLS上层的各种协议，TLS主要保护的数据就是应用数据协议的数据。经过TLS记录层包装以后，结构如下:

![](/images/https_protocol_1_7.png)

# TLS心跳协议

经过TLS记录层包装以后，结构如下:

![](/images/https_protocol_1_8.png)

协议数据结构如下：

```c
enum {
    heartbeat_request(1),
    heartbeat_response(2),
    (255)
} HeartbeatMessageType;

struct {
    HeartbeatMessageType type;
    uint16 payload_length;
    opaque payload[HeartbeatMessage.payload_length];
    opaque padding[padding_length];
} HeartbeatMessage;
```

# 其他闲杂知识

（1）一个TCP包中可以包含多个TLS报文

![](/images/https_protocol_1_9.png)

学习资料参考于：
https://halfrost.com/https-begin/
