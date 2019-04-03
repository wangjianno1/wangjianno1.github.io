---
title: BIND|smbind技术调研
date: 2018-02-02 19:29:43
tags: DNS
categories: SRE
---

# Bind简介

BIND，Berkeley Internet Name Daemon，是现今互联网上最常使用的DNS服务器软件，使用BIND作为服务器软件的DNS服务器约占所有DNS服务器的九成。BIND现在由互联网系统协会（Internet Systems Consortium）负责开发与维护。20世纪80年代，柏克莱加州大学计算机系统研究小组的四个研究生Douglas B Terry、Mark Painter、David W. Riggle和周松年（Songnian Zhou）一同编写了BIND的第一个版本，并随4.3BSD发布。

# Bind的安装和启动

（1）Bind的安装

- 源码安装
在Bind官网`https://www.isc.org/downloads/bind/`中下载源码，然后编译安装。需要注意的是，源码安装Bind需要很多前置Lib环境的安装。

- 通过包管理工具安装bind
```
yum install bind bindchroot  #RedHat系
sudo apt-get install bind9   #Debian系
```

（2）Bind的启动

named的启动命令如下：

```bash
/usr/local/sbin/named -u named -t /var/named/chroot -c /etc/named/named.conf
```

其中，

```
-u username     #指定用什么账户名来启动named
-t directory    #chroot到指定目录，chroot是在加载配置文件之前，也就是配置文件路径还是从系统原先的根路径开始，等named服务启动后，那就是以-t后的directory目录作为根路径
-c config-file  #指定named加载的配置文件路径。若没有该选项，则默认加载/etc/named.conf
```

# Bind的配置文件

BIND服务的进程名为named，主要的配置文件有：

（1）named.conf

bind的主配置文件，用来对bind服务的基本配置、zonefile的位置、权限等设置、zone和zonefile的对应关系等。bind主配置文件named.conf的基本格式如下：

```
// 全局配置段
options { ... };
// 日志配置段
logging { ... };
// 区域配置段
zone { ... };
```

named.conf options全局配置段中一些重要配置参数：

```
listen-on port 53 { 127.0.0.1; 192.168.1.108; };    //定义DNS监听在哪个IP的特定端口上
directory      "/var/named";    //指定DNS zone文件存放目录
allow-query    { localhost; 192.168.1.100; };    //定义允许哪些主机可以查询该DNS服务
recursion yes;    //定义是否允许DNS服务器做递归查询
notify yes;    //DNS服务器采用主从模式时，定义是否当主服务器zone文件发生改变，通知从服务器更新
```

（2）zone file

包括域名正解配置文件、ip反解配置文件。是域名解析的关键文件。举例说明如下：

```
zone "." IN {     //根域的zone文件属性配置
    type hint;    //定义此区域文件的类型为hint
    file "named.ca";    //相对directory "/var/named/"目录的文件，为根域的zone文件
};

zone "example1.com" {
    type master;     //说明该DNS对于example1.com域是Master
    file "db/example1.com.zone";
};
```

在zone中类型type可以是hint、master、slave以及forward。特殊符号`@`是DNS配置中的保留关键字，表示当前域的名称，在上述的例子`db/example1.com.zone`配置中，可以使用`@`表示`example1.com`。在zone file中还有一些特殊参数：

```
@TTL    #设置zone file中每一条记录的TTL值
@ORIGIN #重新定义zone的名称，如上述例子中db/example1.com.zone文件中代表的域是example1.com，但当我们使用@ORIGIN bb.example1.com就表示当前域是bb.example1.com
```

备注：为保持主配置文件简洁，可以将部分配置信息存放于其他文件，然后再主配置文件named.conf中通过include指令进行引入，如include "/etc/named.rfc1912.zones"。

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

如果某个DNS服务器只有`.`这个zone file（root dns），我们称这种没有自己公共的DNS数据库的服务器称为cache-only DNS服务器。也就是这种DNS服务器只有缓存查找的功能，它自身并没有任何域名和IP正反解的配置文件。

cache-only DNS的配置举例如下：

```
# named.conf主要的文件内容
zone "." {
  type hint;
  file "named.root";
};
```

```
# named.root文件的内容
.                       446466  IN      NS      g.root-servers.net.
.                       446466  IN      NS      k.root-servers.net.
.                       446466  IN      NS      f.root-servers.net.
.                       446466  IN      NS      a.root-servers.net.
.                       446466  IN      NS      c.root-servers.net.
.                       446466  IN      NS      d.root-servers.net.
.                       446466  IN      NS      j.root-servers.net.
.                       446466  IN      NS      l.root-servers.net.
.                       446466  IN      NS      e.root-servers.net.
.                       446466  IN      NS      i.root-servers.net.
.                       446466  IN      NS      b.root-servers.net.
.                       446466  IN      NS      m.root-servers.net.
.                       446466  IN      NS      h.root-servers.net.

a.root-servers.net.     447955  IN      A       198.41.0.4
a.root-servers.net.     447958  IN      AAAA    2001:503:ba3e::2:30
b.root-servers.net.     447955  IN      A       192.228.79.201
b.root-servers.net.     447958  IN      AAAA    2001:500:84::b
c.root-servers.net.     447955  IN      A       192.33.4.12
c.root-servers.net.     447968  IN      AAAA    2001:500:2::c
d.root-servers.net.     447955  IN      A       199.7.91.13
d.root-servers.net.     447968  IN      AAAA    2001:500:2d::d
e.root-servers.net.     447955  IN      A       192.203.230.10
f.root-servers.net.     447955  IN      A       192.5.5.241
f.root-servers.net.     447968  IN      AAAA    2001:500:2f::f
g.root-servers.net.     447955  IN      A       192.112.36.4
h.root-servers.net.     447968  IN      A       128.63.2.53
h.root-servers.net.     447968  IN      AAAA    2001:500:1::803f:235
i.root-servers.net.     447968  IN      A       192.36.148.17
i.root-servers.net.     447968  IN      AAAA    2001:7fe::53
j.root-servers.net.     447968  IN      A       192.58.128.30
j.root-servers.net.     447968  IN      AAAA    2001:503:c27::2:30
k.root-servers.net.     447968  IN      A       193.0.14.129
k.root-servers.net.     447968  IN      AAAA    2001:7fd::1
l.root-servers.net.     447968  IN      A       199.7.83.42
l.root-servers.net.     447968  IN      AAAA    2001:500:3::42
m.root-servers.net.     447968  IN      A       202.12.27.33
m.root-servers.net.     447968  IN      AAAA    2001:dc3::35
```

（2）forwarding DNS服务器

有些DNS服务器可能连`.`这个zone file都没有，而是通过forwarding配置将域名解析请求转发给其他的DNS服务器，我们称这种DNS服务器为forwarding DNS服务器。

forwarding DNS服务器的配置举例如下：

```
zone "example1.com" {
  type forward;
  forward only;
  forwarders { 10.28.21.70; 10.28.21.71; };
};

zone "example2.com" {
  type forward;
  forward only;
  forwarders { 10.38.21.70; 10.38.21.71; };
};
```

备注：forwarding这个特性通常用来做DNS劫持吧，如某公司有内部域名`example-inc.com`需要解析到内部IP地址，此时在公司机房的Local DNS上针对`example-inc.com`这个zone配置forwarding，将DNS请求转发到一套内部的DNS集群，然后由这个内部的DNS集群负责解析`example-inc.com`这个zone。因此`example-inc.com`这个域名，就不需要向外部的`.com`域上申请授权啦。

（3）权威DNS服务器
自己的理解是，所谓权威DNS服务是相对于cache-only DNS和forwards DNS来说的，cache-only DNS和forwards DNS本身并不提供相关域名的解析（若自身缓存中有解析记录则可以返回给dns客户端，但这不叫自身的解析）。而权威服务器是自身就能够解析域名，即zone file中配置了域名和IP的映射关系（也有CNAME或MX等记录）。

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

# Bind的递归配置

在named.conf中options区域通过`recursion {yes | no}`来设置，默认是`recursion yes`配置，即默认是开启递归的。若开启了递归，那么bind dns服务会依据客户端的dns请求，不管是通过“自己本地解析”或“cache缓存”或者“查询其他dns服务器”，最终一定要得到客户端需要的终极结果返回给客户端。就不用客户端再去查询了。若关闭了递归，那么bind dns在收到客户端的请求后，如果本地不能解析或本地缓存中也不存在，那就会返回和dns请求相关的信息，如返回一条NS记录，告诉客户端再去其他的DNS上去查询结果。

BIND9默认打开递归查询和关闭转发功能。

# Bind提供的一些辅助工具

- named-checkconf
- named-checkzone
- named-compilezone
- rndc

# Bind的负载均衡

假设域名`www.bat.com`有多条A记录，如
```
www.bat.com  A  10.0.0.1
www.bat.com  A  10.0.0.2
www.bat.com  A  10.0.0.3
```

那么当客户端请求dns服务器解析`www.bat.com`时，dns服务器会随机的返回`1,2,3`、`2,1,3`、`3,1,2`等这样的顺序，一般来说客户端会使用第一条记录，那么所有的A记录的对应的服务的DNS请求数几乎是一样的。

# Bind能处理的类unix平台的信号

Bind能处理的类unix平台的信号有：

```
SIGHUP   #会触发bind重新加载named.conf配置
SIGTERM  #会触发bind退出
SIGINT   #会触发bind退出
```

# DNSPOD

DNSPod建立于2006年3月份，是一款免费智能DNS产品。DNSPod是中国第一大DNS解析服务提供商、第一大域名托管商。DNSPod可以为同时有电信、联通、教育网服务器的网站提供智能的解析，让电信用户访问电信的服务器，联通的用户访问联通的服务器，教育网的用户访问教育网的服务器，达到互联互通的效果。

说白了，DNSPOD对外提供了一个公共的DNS服务，帮助其用户解析域名，这样其用户就不需要搭建自己的DNS服务器了。注意和Public DNS，例如和8.8.8.8，114.114.114.114是有区别的，Public DNS是用来帮助用户的浏览器解析域名的，而不会帮忙搭建DNS域名解析服务。

DNSPod目前是腾讯旗下的公司。

# Bind的闲杂知识点

（1）bind配置的序列号serial num问题

序列号的上限是2147483647(2ˆ31-1)，超过这个值之后，需要重置才能生效。如下为官方手册的说明：

![](/images/smbind_1_1.png)

备注：先用当前序列号加上2147483647，并让bind reload配置，待各slaves更新完配置；在将序列号设定为自己想要的值，并再让bind reload配置即可。

学习资料参考于：
https://www.isc.org/downloads/bind/
https://www.isc.org/downloads/bind/doc/