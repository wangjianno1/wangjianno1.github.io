---
title: Chrome浏览器的一些使用小技巧
date: 2018-02-02 20:16:59
tags: Chrome
categories: Tools
---

# 使用Google Smart Lock保存网页表单密码

打开Chrome浏览器选择`设置 -> 显示高级设置 -> 密码和表单 -> 管理密码`，即可修改密码、添加密码等。当下次打开了这些被保存了密码的WEB页面时，Chrome会自动填充表单。打开Google Smart Lock的密码保存页面如下：

![](/images/chrome_1_1.png)

# Google Chrome提供的接口工具

	chrome://dns/                 #查看chrome缓存的DNS信息 
	chrome://net-internals/#dns   #清除chrome的DNS缓存
	chrome://version/             #查看chrome的详细版本信息

# Provisional headers are shown

使用Chrome的开发者工具，有时会发现一些HTTP请求的请求头为Provisional headers are shown，截图如下：

![](/images/chrome_1_2.png)

一般来说，如果看到HTTP请求头为Provisional headers are shown，说明这个请求实际上根本没有产生，对应的请求头当然也不应该存在。但对于这样的请求，Google Chrome也会显示部分请求头信息，并给出「CAUTION:Provisional headers are shown」这样的提示。具体原因有多种，比如：

（1）请求被某些扩展如Adblock给拦截了

（2）走本地缓存（memory cache OR disk cache），举例来说，如下资源是直接从disk cache或memory cache中获取的，因此浏览器并没有向网络服务器发送HTTP请求，因此它的HTTP请求头就显示为Provisional headers are shown。

![](/images/chrome_1_3.png)

# Chrome模拟移动终端设置

使用Google Chrome可以模拟移动终端设备，例如IPad、IPhone、Galaxy、Nexus等等。打开Chrome开发者工具，点击左上角的移动设备切换开发即可，如下所示：

![](/images/chrome_1_4.png)

然后就可以选择要模拟的终端设备即可。

![](/images/chrome_1_5.png)

# 使用Chrome模拟弱网环境

打开Google Chrome开发者工具，选择Network面板如下所示，即可选择不同的弱网环境：

![](/images/chrome_1_6.png)

# Google Chrome开发者工具Network面板的一些小Tips

使用Disable cache，可以禁止Chrome从本地cache中获取资源，而是直接发起HTTP请求到服务端获取资源，这样浏览器就直接忽略本地缓存（Cache-Control/Expires等）。使用Preserve log可以避免Network面板中历史的资源请求记录被清除。这样的一个好处是，如果我们在浏览器中请求的是A资源，但是A资源被30X到B资源，可是我们在Network面板中看不到从资源A 30X到资源B的这个处理过程，这时勾选上Preserve log功能就好了。

![](/images/chrome_1_7.png)

# 删除Chrome地址栏中推荐的不需要的网址

Chrome的地址栏自动补齐功能提供了非常方便的地址预测功能，浏览器可以通过用户当前输入的字符来与用户的访问历史与书签匹配，然后在下拉栏中为用户提供准确的补齐方案推荐，提高用户访问效率。在大部分情况下，这个功能是非常好用的。但是有时，出于某些原因，用户需要移除某个记录（例如网址无法访问、网址更换域名等）。因此我们按照如下步骤删除访问地址推荐：

（1）在地址栏中输入所需删除网址的完整URL或部分关键字

（2）使用↑键或↓键移动蓝色高亮选框，使用Page Up或Page Down移动蓝色高亮选框到首项或末项

（3）使用Shift+Delete来删除选中记录

（4）再次输入关键字，补齐方案中已没有了已删除的记录

备注：已加入书签的URL会在左侧显示☆号，这部分记录必须在书签中删除。

# TTFB

TTFB，全称为Time To First Byte，是最初的网络请求被发起到从服务器接收到第一个字节这段时间，它包含了TCP连接时间，发送HTTP请求时间和获得响应消息第一个字节的时间。

![](/images/chrome_1_8.png)

# chrome的chrome://***功能

在Chrome地址栏中输入chrome://chrome-urls/，即可以看到各种`chrome://***`，例如：

![](/images/chrome_1_9.png)

# chrome查看单页面大小

在network标签页下面，可以看到总请求数以及请求内容总大小等信息。

![](/images/chrome_1_10.png)

