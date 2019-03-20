---
title: SaltStack技术简介
date: 2019-03-04 23:20:14
tags:
categories: SaltStack
---

# SaltStack简介

SaltStack是基于Python开发的一套C/S架构配置管理工具（功能不仅仅是配置管理，如使用salt-cloud配置AWS EC2实例），它的底层使用ZeroMQ消息队列Pub/Sub方式通信，使用SSL证书签发的方式进行认证管理。号称世界上最快的消息队列ZeroMQ使得SaltStack能快速在成千上万台机器上进行各种操作，而且采用RSA Key方式确认身份，传输采用AES加密，这使得它的安全性得到了保障。SaltStack具备配置管理、远程执行、监控等功能，一般可以理解为是简化版的Puppet和加强版的Func。SaltStack本身是基于Python语言开发实现，结合了轻量级的消息队列软件ZeroMQ与Python第三方模块（Pyzmq、PyCrypto、Pyjinjia2、python-msgpack和PyYAML等）构建。

puppet、chef、ansible以及saltstack都是同类性质的工具平台。

# SaltStack架构

在SaltsStack架构中服务端叫作Master，客户端叫作Minion，都是以守护进程的模式运行。salt-master一直监听配置文件中定义的ret_port（saltstack客户端与服务端通信的端口，负责接收客户端发送过来的结果，默认4506端口）和publish_port（saltstack的消息发布系统，默认4505端口）的端口。salt-minion在启动时，会自动生成一套密钥，包含私钥和公钥。之后将公钥发送给服务器端，服务器端验证并接受公钥，以此来建立可靠且加密的通信连接，同时通过消息队列ZeroMQ在客户端与服务端之间建立消息发布连接。

![](/images/saltstack_1_1.png)

salt-minion是SaltStack需要管理的客户端安装组件，会主动去连接salt-master端，并从salt-master端得到资源状态信息，同步资源管理信息。salt-master作为控制中心运行在主机服务器上，负责salt命令运行和资源状态的管理。ZeroMQ是一款开源的消息队列软件，用于在salt-minion端与salt-master端建立系统通信桥梁。

需要注意的是，ZeroMQ并非RocketMQ这样的消息队列。ZeroMQ仅仅就是一个消息队列库，有点像socket一样的东西，但比socket要高级。

# salt-master和salt-minion的安装

下面以CentOS6为例来说明：

（1）安装EPEL YUM源

```bash
rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/epel/epel-release-latest-6.noarch.rpm
```

（2）安装并启动salt管理端salt-master

```bash
yum -y install salt-master
service salt-master start
```

备注：salt-master启动之后会监听两个端口，一个是ret_port，该端口负责接收来自salt-minion发送过来的结果，默认4506端口；另一个是publish_port，该端口是saltstack的消息发布系统，默认4505端口。

（3）安装并启动salt客户端salt-minion

```bash
yum -y install salt-minion
sed -i 's@#master:.*@master: master_ipaddress@' /etc/salt/minion  #master_ipaddress为管理端IP
echo 10.252.137.141 > /etc/salt/minion_id   #个人习惯使用IP，默认主机名
service salt-minion start
```

当salt-minion启动时会自动连接到配置文件中定义的master地址ret_port端口进行连接认证。

备注：salt-master和salt-minion最好是同一个YUM仓库源，不然会出现奇怪的问题啦。

# salt-master/salt-minion的配置文件

salt-master/salt-minion的配置文件都在/etc/salt/目录中。

（1）salt-master的主要配置

    /etc/salt/master               #salt-master的主配置文件
    /etc/salt/pki/master/minions/  #该目录中存放了所有salt-minion的公钥

（2）salt-minion的主要配置

    /etc/salt/minion       #salt-minion的主配置文件
    /etc/salt/minion_id    #存放的是salt-minion的id
    /etc/salt/pki/minion/  #该目录存放的是该salt-minion的公私钥

# salt-master和salt-minion间认证

salt-minion在第一次启动时，会在/etc/salt/pki/minion/（该路径在/etc/salt/minion里面设置）下自动生成minion.pem（private key）和 minion.pub（public key），然后将minion.pub发送给salt-master。salt-master在接收到salt-minion的public key后，通过salt-key命令accept salt-minion public key，这样在salt-master的/etc/salt/pki/master/minions下的将会存放以minion id命名的public key，然后salt-master就能对salt-minion发送指令了。即salt-master使用salt-minion的public key来加密指令发送给salt-minion来实现安全通信的。

在salt-master端关于认证相关的命令有：

```bash
salt-key -L     #查看salt-master当前公钥认证情况
salt-key -A -y  #同意接受所有没有接受的salt-minion公钥
```

# salt-master执行命令

通用的salt-master命令格式为：

```bash
salt '<target>' <module.function> [arguments]
```

举例来说：

![](/images/saltstack_1_2.png)

其中，target是执行salt命令的目标，即代表一批salt-minion，可以使用通配符、Grains、列表以及正则表达式等；function是方法，由module提供；arguments是function的参数。

常用的命令举例有：

```bash
salt '*' test.ping           #ping所有的salt-minion
salt '*' disk.usage          #查看所有的salt-minion的磁盘使用率
salt '*' network.interfaces  #查看机器的网络接口卡信息
salt '*' cmd.run 'uname -r'  #*代表对所有的被管理客户端进行操作，cmd.run是命令调用模块
salt '*' pkg.install 'lrzsz' #批量安装lrzsz软件
```

另外，可以将module或function的名称作为参数传递给sys.doc，从而可以看到相应的一些帮助文档。命令格式如下：

```bash
salt '*' sys.doc pkg
salt '*' sys.doc pkg.install
salt '*' cmd.script salt://hostname.sh   #在salt-minion上执行salt-mater中file_roots中hostname.sh脚本文件，很重要哦
```

# SaltStack的执行模块

SaltStack有很多的执行模块，一部分的模块列表如下：

![](/images/saltstack_1_3.png)

例如，我们常用的有cmdmod（执行shell命令）等。

# salt-master/salt-minion运行日志

salt-master的运行日志在`/var/log/salt/master`；salt-minion的运行日志在`/var/log/salt/minion`。

# salt-master端的一些常用工具命令

（1）salt

在远程系统上执行命令。

（2）salt-key

salt-minion每次启动时会连接到salt-master时，会将salt-minion的公钥发送给salt-master，然后salt-master会利用salt-key命令来查看或同意接收新的公钥。具体命令举例如下：

```bash
salt-key -L      #查看salt-master当前公钥认证情况
salt-key -A -y   #同意接收所有没有接收的salt-minion公钥
```

（3）salt-run

是SaltStack Runners模块的工具命令。

# salt-minion端的一些常用工具命令

待补充

# SaltStack与Ansible的比较

Ansible、SaltStack都是基于Python开发的，Ansible基于SSH协议传输数据，SaltStack使用消息队列ZeroMQ传输数据。从网上数据来看，SaltStack比Ansible快大约40倍。对比Ansible，SaltStack缺点是需要安装客户端。为了速度建议选择SaltStack。

网络上有人测试过SaltStack与Ansible的性能数据。测试场景是对1000台服务器执行相同的操作所消耗的时间，基于SSH协议的Ansible耗时85s左右，基于ZeroMQ的SaltStack耗时2s左右。

学习资料参考于：
https://www.ibm.com/developerworks/cn/opensource/os-devops-saltstack-in-cloud/index.html
