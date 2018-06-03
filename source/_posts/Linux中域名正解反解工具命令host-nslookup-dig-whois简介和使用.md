---
title: Linux中域名正解反解工具命令host | nslookup | dig | whois简介和使用
date: 2018-06-04 01:15:49
tags: DNS
categories: SRE
---

# DNS正解反解客户端工具

在Linux中与域名解析和反解的命令主要有下面三个：

- host
- nslookup
- dig

# host工具

（1）命令格式

```
host [option] domain [server]
```

其中的domain为要解析的域名，server为指定向哪个DNS服务器发起DNS解析请求。

常用的选项：

```
-a    #显示详细信息
```

（2）使用举例

```bash
# 解析域名
host www.sina.com
# 不使用/etc/resolv.conf默认的DNS服务器，指定一个特定的DNS发起请求
host www.sina.com 211.161.46.84  #向211.161.46.84 DNS服务器发起域名www.sina.com的解析请求
# ip反解析域名
host 202.108.33.60
```

# nslookup工具

nslookup支持交互式和非交互式两种查询。当直接在命令提示符后输入nslookup命令时，就进入了nslookup的交互式操作。否则直接返回给用户解析结果。

（1）命令格式

```
nslookup [option] hostname
```

常用的选项：

```
-query=type #type可以是mx、cname以及mx等等，可以查询指定类型的DNS记录
```

（2）使用举例

```bash
# 解析域名
nslookup www.sina.com
# ip反解析域名
nslookup 202.108.33.60
```

# dig工具

dig是比nslookup和host更强大的DNS查询工具。

（1）命令格式

```
dig [options] domain [@server]
```

其中`@server`表示不使用`/etc/resolv.conf`默认的DNS服务器，指定一个特定的DNS发起请求。

重要的选项：

```
+trace  #输出域名解析过程中详细的debug信息
-t type #制定查询的DNS记录类型，例如A记录、CNAME记录以及NS记录等等
-x      #从ip反解析域名
+short  #精简地输出dig结果
+subnet ip/submask  #向dns服务器传递客户端所属的网络地址
```

（2）使用举例

```bash
# 解析域名
dig www.sina.com
# 不使用/etc/resolv.conf默认的DNS服务器，指定一个特定的DNS发起请求
dig www.sina.com @211.161.46.84  #向211.161.46.84 DNS服务器发起域名www.sina.com的解析请求
# 查询域名的SOA记录相关信息
dig -t soa www.sina.com
# 查询某个域的NS服务器
dig -t ns baidu.com
# ip反解析域名
dig -x 202.108.33.60
```

如下为一个关于edns的一个用法：

```
dig www.zhxfei.com @172.16.130.129 +subnet=120.0.0.1/24
```

如上命令中，dig工具需要安装支持edns的版本，`+subnet`指定客户端所属的子网，`@server`指定Local DNS，假设172.16.130.129支持了edns，那么她会依照+subnet来解析出一个离客户端比较近的IP，而不是根据Local DNS来解析出较近的IP。这种情况下，DNS的GLSB负载均衡将会更准确。

备注：
`dig domainname +trace`表示从本机开始迭代查询，即从根域开始查，每次迭代查询结果直接返回给本机，然后本机再继续进行下一步迭代查询。`dig domainname`不加trace时，那么本机是直接向local DNS发起请求（本机和local DNS是递归查询），然后local DNS再去迭代查询并将最终的结果返回给本机。因此，+trace时，若本机访问不了公网，那么就dig不出外网的域名，因为本机与公网上dns根本连接不了。若不加trace，那么就和本机有没有公网连接就没有关系，只要local DNS能够查询到结果就会返回给本机了。

# whois命令

我们可以使用whois可以查询一个域名的一些注册信息，包括域名是谁注册的，什么时候注册的，什么时候过期失效，注册该域名的人或组织的联络方式等等。

whois常见使用举例：

```bash
whois domainname #查看某个域名的注册信息
whois ip         #查看某个IP所属地区及运营商等
```

# 闲杂

nslookup和dig工具的安装命令如下：

```bash
yum install bind-utils         #RedHat系
sudo apt-get install dnsutils  #Debian系
```

注意host|nslookup|dig是和域名解析相关的，与traceroute等不同哦。
