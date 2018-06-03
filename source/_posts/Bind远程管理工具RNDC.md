---
title: Bind远程管理工具RNDC
date: 2018-06-04 00:57:50
tags: DNS
categories: SRE
---

# rndc工具简介

rndc，英文全称为Remote Name Domain Controllor，是一个远程管理bind的工具，通过这个工具可以在本地或者远程了解当前DNS服务器的运行状况，也可以对DNS服务器进行关闭、重载、刷新缓存、增加删除zone等操作。

使用rndc可以在不停止DNS服务器工作的情况进行数据的更新，使修改后的配置文件生效。在实际情况下，DNS服务器是非常繁忙的，任何短时间的停顿都会给用户的使用带来影响。因此，使用rndc工具可以使DNS服务器更好地为用户提供服务。在使用rndc管理bind前需要使用rndc生成一对密钥文件，一半保存于rndc的配置文件中，另一半保存于bind主配置文件中。rndc的配置文件为`/etc/rndc.conf`，在CentOS或者RHEL中，rndc的密钥保存在`/etc/rndc.key`文件中。rndc默认监听在953号端口（TCP），其实在bind9中rndc默认就是可以使用，不需要配置密钥文件。

rndc与DNS服务器实行连接时，需要通过数字证书进行认证，而不是传统的username/password方式。在当前版本下，rndc和named都只支持HMAC-MD5认证算法，在通信两端使用预共享密钥。在当前版本的rndc和named中，唯一支持的认证算法是HMAC-MD5，在连接的两端使用共享密钥。它为命令请求和名字服务器的响应提供TSIG类型的认证。所有经由通道发送的命令都必须被一个服务器所知道的key_id签名。为了生成双方都认可的密钥，可以使用rndc-confgen命令产生密钥和相应的配置，再把这些配置分别放入named.conf和rndc的配置文件rndc.conf中。

# rndc的配置

执行命令`rndc-confgen`，生成rndc的key，内容如下：

```
# Start of rndc.conf
key "rndc-key" {
    algorithm hmac-md5;
    secret "P9M+wf6zK47ynypJZiB/uQ==";
};
options {
    default-key "rndc-key";
    default-server 127.0.0.1;
    default-port 953;
};
# End of rndc.conf
# Use with the following in named.conf, adjusting the allow list as needed:
# key "rndc-key" {
#     algorithm hmac-md5;
#     secret "P9M+wf6zK47ynypJZiB/uQ==";
# };
#
# controls {
#     inet 127.0.0.1 port 953
#         allow { 127.0.0.1; } keys { "rndc-key"; };
# };
# End of named.conf
```

然后新建rndc.conf配置文件，将rndc-confgen生成的如下部分复制到rndc.conf文件中，

```
key "rndc-key" {
    algorithm hmac-md5;
    secret "P9M+wf6zK47ynypJZiB/uQ==";
};
options {
    default-key "rndc-key";
    default-server 127.0.0.1;
    default-port 953;
};
```

再然后新建rndc.key配置文件，将rndc-confgen生成的如下部分复制到rndc.key文件中，

```
key "rndc-key" {
    algorithm hmac-md5;
    secret "P9M+wf6zK47ynypJZiB/uQ==";
};
controls {
    inet 127.0.0.1 port 953
        allow { 127.0.0.1; } keys { "rndc-key"; };
};
```

再然后在named.conf中使用`include "/etc/named/rndc.key";`指令将rndc.key的文件内容引入到named.conf中。

# rndc的常用操作命令

rndc命令的通用操作格式为：

```
rndc [-c config-file] [-k key-file] [-s server] [-p port] {command}
```

其中`-c config-file`指定rndc的配置文件，若不显式指定，则默认为`/etc/rndc.conf`。`-k key-file`执行rndc的eky文件，若不显式指定，则默认为`/etc/rndc.key`。

常用的执行的命令command有：

```bash
rndc status   #显示bind服务器的工作状态
rndc reload   #重新加载配置文件和zone file
rndc reload zone_name #重新加载指定zone file
rndc reconfig   #重读配置文件并加载新增的区域
rndc querylog   #关闭或开启查询日志
rndc dumpdb     #将高速缓存转储到转储文件 (named_dump.db)
rndc freeze     #暂停更新所有动态zone
rndc freeze zone [class [view]]  #暂停更新一个动态zone
rndc flush [view]    #刷新服务器的所有高速缓存
rndc flushname name  #为某一视图刷新服务器的高速缓存
rndc stats    #将服务器统计信息写入统计文件中
rndc stop     #将暂挂更新保存到主文件并停止服务器
rndc halt     #停止服务器，但不保存暂挂更新
rndc trace    #打开debug, debug有级别的概念，每执行一次提升一次级别
rndc trace LEVEL   #指定 debug 的级别, trace 0 表示关闭debug
rndc notrace       #将调试级别设置为 0
rndc restart       #重新启动服务器（尚未实现）
rndc addzone zone [class [view]] { zone-options } #增加一个zone
rndc delzone zone [class [view]] #删除一个zone
rndc tsig-delete keyname [view]  #删除一个TSIG key
rndc tsig-list      #查询当前有效的TSIG列表
rndc validation newstate [view]  #开启/关闭dnssec
```

备注：rndc命令后面可以跟`-s`和`-p`选项连接到远程DNS服务器，以便对远程DNS服务器进行管理，但此时双方的密钥要一致才能正常连接。在设置rndc.conf时一定要注意key的名称和预共享密钥一定要和named.conf相同，否则rndc工具无法正常工作。
