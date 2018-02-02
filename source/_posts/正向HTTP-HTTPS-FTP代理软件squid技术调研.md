---
title: 正向HTTP/HTTPS/FTP代理软件squid技术调研
date: 2018-02-02 19:10:56
tags: BKM
categories: SRE
---

# squid简介

Squid是HTTP代理服务器和缓存软件，支持HTTP/HTTPS/FTP协议的请求的代理。可以使用squid在一台科学上网的机器上（例如香港或美国的机器）搭建一个squid，然后就可以利用它来科学上网了哦。另外，squid不仅可以做代理，而且它可以缓存源站的内容哦，类似于Nginx的缓存功能。

# squid的安装

在RedHat系上我们可以使用yum来安装squid，即`yum install squid`。squid安装后核心的目录文件结构有：

	/usr/sbin/squid        #squid的主程序
	/etc/squid/squid.conf  #squid的主配置文件
	/var/spool/squid       #squid的默认的缓存文件的存储目录

# squid的配置

squid的配置文件为/etc/squid/squid.conf，该配置文件主要有如下几个部分：

（1）acl的配置

包括本地、外网、以及服务端口等，举例来说：

	acl localhost src 127.0.0.1/32 ::1  #表示来源ip为本地
	acl localnet src 10.0.0.0/8         #表示来源ip为本地私网的一些机器
	acl Safe_ports port 80              #表示请求的端口是80

备注：其实本部分可以理解为定义满足一定特征的一些请求，供（2）来对这些类别的请求进行权限控制

（2）访问权限的控制

	http_access allow localnet   #允许来自（1）中定义的localnet特征的请求
	http_access allow localhost  #允许来自（1）中定义的localhost特征的请求
	http_access deny !Safe_ports #拒绝（1）中没有被定义为Safe_ports的端口的请求

备注：上面的访问控制是有先后顺序的。

（3）squid网络参数的配置

例如监听的端口，默认情况下，squid监听的是3128端口

（4）磁盘与缓存相关的配置

（5）其他的一些日志类的配置

# squid的access日志格式

![](/images/squid_1_1.png)

# squid的access.log的状态码

***使用TCP协议的状态码枚举***

（1）TCP_HIT

Squid发现请求资源的貌似新鲜的拷贝，并将其立即发送到客户端。

（2）TCP_MISS

Squid没有请求资源的cache拷贝。

（3）TCP_REFERSH_HIT

Squid发现请求资源的貌似陈旧的拷贝，并发送确认请求到原始服务器.原始服务器返回304（未修改）响应，指示squid的拷贝仍旧是新鲜的。

（4）TCP_REF_FAIL_HIT

Squid发现请求资源的貌似陈旧的拷贝，并发送确认请求到原始服务器。然而，原始服务器响应失败，或者返回的响应Squid不能理解。在此情形下，squid发送现有cache拷贝（很可能是陈旧的）到客户端。

（5）TCP_REFRESH_MISS

Squid发现请求资源的貌似陈旧的拷贝，并发送确认请求到原始服务器。原始服务器响应新的内容，指示这个cache拷贝确实是陈旧的。

（6）TCP_CLIENT_REFRESH_MISS

Squid发现了请求资源的拷贝，但客户端的请求包含了Cache-Control: no-cache指令。Squid转发客户端的请求到原始服务器，强迫cache确认。

（7）TCP_IMS_HIT

客户端发送确认请求，Squid发现更近来的、貌似新鲜的请求资源的拷贝。Squid发送更新的内容到客户端，而不联系原始服务器。

（8）TCP_SWAPFAIL_MISS

Squid发现请求资源的有效拷贝，但从磁盘装载它失败。这时squid发送请求到原始服务器，就如同这是个cache丢失一样。

（9）TCP_NEGATIVE_HIT

在对原始服务器的请求导致HTTP错误时，Squid也会cache这个响应。在短时间内对这些资源的重复请求，导致了否命中。negative_ttl指令控制这些错误被cache的时间数量。请注意这些错误只在内存cache，不会写往磁盘。下列HTTP状态码可能导致否定cache（也遵循于其他约束）： 204, 305, 400, 403, 404, 405, 414, 500, 501, 502, 503, 504.

（10）TCP_MEM_HIT

Squid在内存cache里发现请求资源的有效拷贝，并将其立即发送到客户端。注意这点并非精确的呈现了所有从内存服务的响应。例如，某些cache在内存里，但要求确认的响应，会以TCP_REFRESH_HIT、TCP_REFRESH_MISS等形式记录。

（11）TCP_DENIED

因为http_access或http_reply_access规则，客户端的请求被拒绝了。注意被http_access拒绝的请求在第9域的值是NONE/-，然而被http_reply_access拒绝的请求，在相应地方有一个有效值。

（12）TCP_OFFLINE_HIT

当offline_mode激活时，Squid对任何cache响应返回cache命中，而不用考虑它的新鲜程度。

（13）TCP_REDIRECT

重定向程序告诉Squid产生一个HTTP重定向到新的URI（见11.1节）。正常的，Squid不会记录这些重定向。假如要这样做，必须在编译squid前，手工定义LOG_TCP_REDIRECTS预处理指令。

（14）NONE

无分类的结果用于特定错误，例如无效主机名。

***使用UDP协议的状态码枚举***

（1）UDP_HIT

Squid在cache里发现请求资源的貌似新鲜的拷贝。

（2）UDP_MISS

Squid没有在cache里发现请求资源的貌似新鲜的拷贝。假如同一目标通过HTTP请求，就可能是个cache丢失，请对比UDP_MISS_NOFETCH。

（3）UDP_MISS_NOFETCH
跟UDP_MISS类似，不同的是这里也指示了Squid不愿去处理相应的HTTP请求。假如使用了-Y命令行选项，Squid在启动并编译其内存索引时，会返回这个标签而不是UDP_MISS。

（4）UDP_DENIED

因为icp_access规则，ICP查询被拒绝。假如超过95%的到某客户端的ICP响应是UDP_DENIED，并且客户端数据库激活了（见附录A），Squid在1小时内，停止发送任何ICP响应到该客户端。若这点发生，你也可在cache.log里见到一个警告。

（5）UDP_INVALID

Squid接受到无效查询（例如截断的消息、无效协议版本、URI里的空格等）。Squid发送UDP_INVALID响应到客户端。

# 使用squid代理的客户端机器的配置

客户端机器要使用squid代理，需要本地配置一些代理相关的环境，例如：

	# vi /etc/profile
	http_proxy=192.168.10.91:3128  #分别指定http/https/ftp协议使用的代理服务器地址
	https_proxy=192.168.10.91:3128
	ftp_proxy=192.168.10.91:3128
	no_proxy=192.168.10.0.  #访问局域网地址（192.168.20.0/24网段）时不使用代理，可以用逗号分隔多个地址
	export http_proxy https_proxy ftp_proxy no_proxy

备注：向curl/wget会使用http_proxy类环境变量，但是有些程序不会使用http_proxy变量，那么就需要按照该程序的说明文档单独地配置即可。

