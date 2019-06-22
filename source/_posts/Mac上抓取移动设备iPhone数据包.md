---
title: Mac上抓取移动设备iPhone数据包
date: 2019-06-22 23:13:25
tags:
categories: Network
---

# Mac抓取移动设备数据包

在Mac上抓取iPhone手机上的数据包，前提条件是，iPhone上的数据包要经过Mac电脑。一般来说，使用Mac抓取iPhone数据包有如下三种方式：

+ 代理软件
+ Mac共享网络
+ 远程虚拟接口RVI

# 代理软件

在Mac上搭建HTTP代理软件，然后在手机上网络设置代理请求到Mac电脑，通常来说，可以使用代理软件有Charles、Flidder for Mono以及Andiparos等，它们在Mac上建立HTTP代理服务器。

# Mac上WiFi热点共享

使用Mac的网络共享功能将Mac的网络通过WiFi共享给iPhone连接。简单来说，就是在Mac上建立WiFi热点，然后手机联系该热点。对于网络共享的方式还要求Mac本身的网络不能使用WiFi，而且在iPhone上只能使用WiFi连接，无法抓取到xG（2G/3G/4G）网络包。

备注：Mac也可以通过蓝牙的方式，共享网络给iPhone手机，不过好像网络很慢的。

# 手机USB连接Mac

苹果在iOS 5中新引入了远程虚拟接口（Remote Virtual Interface，RVI）的特性，可以在Mac中建立一个虚拟网络接口来作为iOS设备的网络栈，这样所有经过iOS设备的流量都会经过此虚拟接口。此虚拟接口只是监听iOS设备本身的协议栈，但并没有将网络流量中转到Mac本身的网络连接上（前两种方式都需要iPhone通过Mac的网络上网，该方式不需要哦），所有网络连接都是iOS设备本身的，与Mac电脑本身联不联网或者联网类型无关。iOS设备本身可以为任意网络类型（WiFi/xG），这样在Mac电脑上使用任意抓包工具（tcpdump/WireShark/CPA）抓取RVI接口上的数据包就实现了对iPhone的抓包。具体步骤如下：

（1）iPhone手机通过USB接口连接到电脑上

（2）在Mac上为iPhone手机设置一个远程虚拟接口

使用`rvictl -s <UDID>`命令为iPhone手机新建远程虚拟接口，其中UDID代表连接到Mac电脑的设备ID，可以通过`iTunes->Summary`或者`Xcode->Organizer->Devices`获取iPhone的UDID。创建成功后，在终端通过ifconfig命令可以看到多了一个rvi0接口。当有多个iOS设备连接Mac时，依次是rvi1、rvi2等等。

使用`rvictl -l`命令可以列出所有挂接的远程虚拟接口。

使用`rvictl -x`命令可以删除指定的远程虚拟接口。

备注：Mac电脑中若没有rvictl命令工具，安装Xcode就好啦。

（3）启动WireShark监听步骤（2）中为iPhone设备新建的远程虚拟接口

（4）手机打开APP上网

学习资料参考于：
https://blog.csdn.net/phunxm/article/details/38590561
