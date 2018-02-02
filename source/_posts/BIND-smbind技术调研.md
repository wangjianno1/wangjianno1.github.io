---
title: BIND|smbind技术调研
date: 2018-02-02 19:29:43
tags: DNS
categories: SRE
---

# BIND简介

BIND，Berkeley Internet Name Daemon，是现今互联网上最常使用的DNS服务器软件，使用BIND作为服务器软件的DNS服务器约占所有DNS服务器的九成。BIND现在由互联网系统协会（Internet Systems Consortium）负责开发与维护。20世纪80年代，柏克莱加州大学计算机系统研究小组的四个研究生Douglas B Terry、Mark Painter、David W. Riggle和周松年（Songnian Zhou）一同编写了BIND的第一个版本，并随4.3BSD发布。

# BIND的配置文件

BIND服务的进程名为named，主要的配置文件有：

（1）named.conf

bind的主配置文件，用来对bind服务的基本配置、zonefile的位置、权限等设置、zone和zonefile的对应关系等

（2）zone file

包括域名正解配置文件、ip反解配置文件。是域名解析的关键文件

# DNS的master/slave架构及配置同步问题

（1）master/slave架构简介

Bind的架构是Master/Slave架构模式，即一主多从的结构。在生产环境中一般有2台以上的DNS服务器，其中一台作为master dns，其他的作为slave dns。master dns用来提供域名解析的修改，不提供对外DNS解析服务。各个slave dns自动从master dns上同步配置文件，且他们真正对外提供DNS解析服务。

（2）master和slave dns的关键配置

master和slave dns的配置文件基本是一样的，但有如下的一些差异：

```
// master dns配置如下
zone "example.com" IN {
    type master;                       #指明dns的类型，这里是master dns
    file "named.example.com";          #指明zone file
    allow-transfer {192.168.100.10;};  #这里配置的是slave ip列表
}

// slave dns配置如下
zone "example.com" IN {
    type slave;                 #指明dns的类型，这里是slave dns
    file "named.example.com";   #指明zone file
    masters {192.168.100.122;}; #这里配置master dns的ip
}
```

（3）master和slave的同步机制

master和slave dns之间的同步有两种策略：

a）master主动告知，当master修改了正反解配置文件，会主动通知slave进行更新

b）slave定期地比较本地配置文件的序号（或称为版本号）与master dns的不同。如果发现master的序号比本地要大，那么就会去同步master dns的配置文件。

备注：dns的配置文件有序号或版本号的概念，每次修改dns的配置文件，则序号会递增一个。另外，master和slave间的配置同步是有bind自身来支持的，不是由rsync这样的工具来控制的哦。

# cache-only DNS服务器与forwarding DNS服务器

（1）cache-only DNS服务器

如果某个DNS服务器只有.这个zone file（root dns），我们称这种没有自己公共的DNS数据库的服务器称为cache-only DNS服务器。也就是这种DNS服务器只有缓存查找的功能，它自身并没有任何域名和IP正反解的配置文件。

（2）forwarding DNS服务器

有些DNS服务器可能连.这个zone file都没有，而是通过forwarding配置将域名解析请求转发给其他的DNS服务器，我们称这种DNS服务器为forwarding DNS服务器。

备注：其实在实际生产环境中，有些DNS服务器具有.这个zone file，同时通过forwading配置将某些域名的解析请求转发给其他的DNS服务器。

# Bind中的zone/ACL/view概念

Bind中zone是指一个解析域，例如dns.baidu.com域名服务器中就有baidu.com、iqiyi.com等zone，zone里面会具体配置A记录、CNAME记录以及NS记录等等。

Bind可以配置很多的ACL，每一个ACL包含了一个网络地址的集合，例如北京电信ACL，河南移动ACL，广州联通ACL等等。通过ACL就可以知道一个用户IP来源于哪个运营商网络。

Bind中的view是匹配某个ACL的解析集合。

如下是一个包含了view/acl/zone概念的Bind配置举例：

```
view beijing-cu { 
    match-clients      {beijing_cu.acl; };  #属于北京电信的用户才会被DNS从这个view中解析IP地址
    recursion no;  #不允许外部网络用户进行递归查询（我们不是免费的公共dns）

    zone "lustlost.com" IN { 
            type master; 
            file "lustlost.com.out"; 
            allow-transfer { none; }; 
            allow-update { none; }; 
    };
};
```

# DNS AXFR

DNS Zone Transfer Protocol，简称AXFR，是多台DNS服务器之间同步解析规则的协议。因此可以通过AXFR，查到指定DNS服务器的所有解析记录。可以使用dig命令查看AXFR的威力，如下：

```bash
dig AXFR baidu.com @ns2.baidu.com    #查询ns2.baidu.com
```

DNS服务器上baidu.com这个zone下的所有域名，当然一般来说，DNS服务器会限制外部使用AXFR功能，可以自己搭建一个DNS服务，然后到dns服务器上执行`dig AXFR example.com @localhost`或`dig AXFR example.com @127.0.0.1`。

# Bind的开源可视化管理界面

Bind有非常非常多的WEB管理工具，例如webbind/smbind/DNS control/ProBIND/Binder/myWebDNS等等，具体参加页面http://www.ti6.net/internet/1490.html

其中smbind，全称为Simple Management for BIND.

# 智能DNS

像上面使用了view的概念后，就是智能DNS的配置。可以根据用户的来源IP所属的区域运营商，来返回一个离用户比较近的服务端IP给用户。值得注意的是，原始的DNS协议是无法获取到用户的来源IP，后来由Google起草的EDNS，EDNS是一个DNS扩展协议，改进部分很简单，就是在DNS协议中加入用户原始IP，这样DNS就知道用户的来源网络，为其指定一个离他较近的IP来访问。

智能DNS需要用到的IP库可以从如下地址下载：
http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest

备注：
```bash
dig www.zhxfei.com @172.16.130.129 +subnet=120.0.0.1/24
```

如上命令中，dig工具需要安装支持edns的版本，+subnet指定客户端所属的子网，@server指定Local DNS，假设172.16.130.129支持了edns，那么她会依照+subnet来解析出一个离客户端比较近的IP，而不是根据Local DNS来解析出较近的IP。这种情况下，DNS的GLSB负载均衡将会更准确。

# DNSPOD

DNSPod建立于2006年3月份，是一款免费智能DNS产品。DNSPod是中国第一大DNS解析服务提供商、第一大域名托管商。DNSPod可以为同时有电信、联通、教育网服务器的网站提供智能的解析，让电信用户访问电信的服务器，联通的用户访问联通的服务器，教育网的用户访问教育网的服务器，达到互联互通的效果。

说白了，DNSPOD对外提供了一个公共的DNS服务，帮助其用户解析域名，这样其用户就不需要搭建自己的DNS服务器了。注意和Public DNS，例如和8.8.8.8，114.114.114.114是有区别的，Public DNS是用来帮助用户的浏览器解析域名的，而不会帮忙搭建DNS域名解析服务。

DNSPod目前是腾讯旗下的公司。

# Bind的闲杂知识点

（1）bind配置的序列号serial num问题

序列号的上限是2147483647(2ˆ31-1)，超过这个值之后，需要重置才能生效。如下为官方手册的说明：

![](/images/smbind_1_1.png)

备注：先用当前序列号加上2147483647，并让bind reload配置，待各slaves更新完配置；在将序列号设定为自己想要的值，并再让bind reload配置即可。
