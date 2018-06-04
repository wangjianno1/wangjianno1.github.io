---
title: A | CNAME | NS | SOA记录说明和使用
date: 2018-06-04 01:03:20
tags: DNS
categories: SRE
---

# A记录、CNAME记录、NS记录、SOA记录

无论是A记录还是CNAME记录，还是其他什么记录，都是一个`key：value`结构，存储在DNS服务器中的一条记录。例如CNAME记录：

```
www.taobao.com.    CNAME   www.gslb.taobao.com.danuoyi.tbcache.com
```

（1）A记录

比如我们访问域名`www.a.com`，经过DNS服务解析，最终解析了一个32b IP返回给了网民，网名通过ip获取服务器的访问。这个域名和iP的对应关系就称为A记录。

（2）CNAME记录

比如我们访问域名`www.a.com`时，经过DNS解析，告诉你这个`www.a.com`其实是`www.b.com`的一个别名，然后告诉网名直接去解析`www.b.com`就好了。那么`www.a.co`m就是`www.b.com`的一个CNAME，而`www.b.com`和IP的对应关系就是A记录。

（3）NS记录

NS记录是这样的一条记录，key是一个域名或者域名服务器，value是另外一个域名服务器的名称。例如：

```
sina.com.cn.            5       IN      NS      ns1.sina.com.cn.
```

在`.com`的域名服务器中有上面这条NS记录。表示要查sina域下的域名，得到`ns1.sina.com.cn.`域名服务器上查询。也可以理解为管理`sina.com.cn.`这个域的域名服务器是`ns1.sina.com.cn.`。

（4）SOA记录

SOA，Start of Authority，称为起始授权资源记录。如果有多台DNS服务器管理同一个域名，那么最好使用Master/Slave架构来进行搭建。既然采用这样的架构，按就需要声明被管理的zone file是如何进行传输的，此时就需要SOA（Start Of Authority）的标志了。也就是说，在DNS的每个zone file中都会有SOA记录的。下面来举例说明SOA记录的格式及字段含义：

```
cp.bat.com              IN SOA  ns.cp.bat.com. dnsadmin.sina.com. (
                                180525000 ; serial
                                1800      ; refresh (30 minutes)
                                600       ; retry (10 minutes)
                                1209600   ; expire (2 weeks)
                                60        ; minimum (1 minute)
                                )
```

备注：在zone file中，@是保留关键字，代表当前域名的意思。这里最开始的cp.bat.com可以用@符号来代替。

SOA后面一共有七个参数，下面分别来介绍：

- Master DNS服务器的主机名
这个字段是用来说明哪台DNS服务器作为Master，在本例中ns.cp.bat.com是Master/Slave架构中的Master服务器。

- 管理员的邮箱地址
如果该域名的解析有问题，可以联系该邮箱地址。需要注意的是，@符号在bind中有特殊含义，因此邮箱地址的@符号不能直接写出来，而是用点号来代替。在本例中dnsadmin.sina.com其实相当于dnsadmin@sina.com。

- 序号（Serial）
这个序号代表的是该zone file的新旧，序号越大表示越新。当Slave要判断是否主动下载新的zone file时，就以此序号是否比Slave上的还要新来判断，若是则下载，若不是则不下载。所以当我们需要了zone file时，一定要将这个Serial值变大才可以，否则Slave是不会同步下载该zone file的。需要注意的是，序号不可以大于2的32次方，亦即必须小于4294967296才行。

- 更新频率（Refresh）
Slave会依据该数值来定期地从Master中下载zone file。在本例中设置的是1800，表示Salve会每隔30分钟就试图向Master获取最新的zone file，若serial数值没有变大，则就不会去更新zone file了。

- 失败重新尝试时间（Retry）
如果由于某些因素导致Slave无法对Master实现连接，那么在依据该数值再去尝试连接到Master服务器。在本例中设置的是600，表示Slave连接Master失败，则会尝试每隔10分钟就去重新尝试连接Master，若在某次重试时连接成功，则会再次恢复到Refresh设置的更新频率。

- 失效时间（Expire）
如果Slave连接Master一直失败，一直到Expire设置的时间时，那么Slave将不在继续尝试连接，并且尝试删除这个zone file的信息。如本例中设置的1209600，表示连续2week Slave都连不上Master，那么Slave将不在尝试且会删除zone file，也就是在Slave上是解析不了这个域名了，很危险哦。

- 缓存时间（Minumum TTL）
如果在zone file中，没有显式的指明TTL时，将会这个TTL设置为主。

备注：当出现如下场景之一时，DNS服务器会返回SOA记录：

- 当查询的类型不存在时，会在“AUTHORITY SECTION”返回SOA记录
- 当查询的域名不存在时，会在“AUTHORITY SECTION”返回SOA记录

# 使用CNAME的场景

使用别名记录，对于多网站、多域名的人来说，是一个非常方便的管理方法。特别是对租用虚拟主机的用户，更是简单。做一个别名记录后，就不用再去管服务器的IP怎么变了。

（1）使用域名的别名记录(CNAME)，让多域名管理轻松到极点

别名记录(CNAME)：也被称为规范名字。这种记录允许您将多个名字映射到同一台计算机。 通常用于同时提供WWW和MAIL服务的计算机。例如，有一台计算机名为`host.mydomain.com`(A记录)。 它同时提供WWW和MAIL服务，为了便于用户访问服务。可以为该计算机设置两个别名(CNAME)：WWW和MAIL。 这两个别名的全称就是`www.mydomain.com`和`mail.mydomain.com`。实际上他们都指向`host.mydomain.com`。 同样的方法可以用于当您拥有多个域名需要指向同一服务器IP，此时您就可以将一个域名做A记录指向服务器IP然后将其他的域名做别名到之前做A记录的域名上，那么当您的服务器IP地址变更时您就可以不必麻烦的一个一个域名更改指向了 只需要更改做A记录的那个域名其他做别名的那些域名的指向也将自动更改到新的IP地址上了。如果你是租用虚拟主机的话，一般的服务商都会提供一个三级或者四级的域名给你，那个地址解析的IP永远是服务器的最新IP，所以，大家如果是租用虚拟主机的，就直接做别名记录指向到那个赠送的域名就可以了。

（2）使用域名的别名记录(CNAME)，让你的域名解析不再蜗牛

众所周知，国内很多域名注册机构的DNS服务器解析生效速度很慢，这便给很多人带来了麻烦，当网站需要更换IP或其他必须对域名重新解析的时候，如果存在大量网站，第一麻烦就是多域名的解析问题，我们可以通过第一条技巧轻松解决!但对于生效速度，通过普通的解析估计我们就无法解决了。

其实，我们可以通过使用域名的别名(CNAME)另类使用达到加速解析的目的。首先我们最好选择一个主域名如：qqya.com，将该域名转移到国外(推荐：ENom)注册商平台下，解析速度与国内的注册商可不是一个两个等级的差别了，然后将其他的相关域名使用CNME记录：(`www.abc.com.`)切记最后有一英文状态下的“句号”。

以后当需要更换域名解析的时候，只需要变动`abc.com`，立即解决了所有问题，因为你其他的域名都已经跟随你的`abc.com`域名了，只要你解析了`abc.com`，其他也都相应变化，不再担心国内解析慢的问题了。
