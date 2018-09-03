---
title: WEB服务中的cookies和session机制小结
date: 2018-05-23 17:23:50
tags:
categories: 杂货铺
---

# 为什么需要cookies和session

由于HTTP协议是无状态的协议，为了能够记住请求的状态，于是引入了Session和Cookie的机制，从而能够间接地实现让HTTP请求带有状态。

# cookie机制

（1）cookie机制简介

Cookie（复数形态为Cookies），指某些网站为了辨别用户身份而储存在用户本地终端（ClientSide）上的数据。定义于RFC2109。是网景公司的前雇员卢·蒙特利在1993年3月的发明。Cookie会存储浏览信息，例如您的网站偏好设置或个人资料信息等等。

Cookie总是保存在客户端中，按在客户端中的存储位置，可分为内存Cookie和硬盘Cookie。内存Cookie由浏览器维护，保存在内存中，浏览器关闭后就消失了，其存在时间是短暂的。硬盘Cookie保存在硬盘里，有一个过期时间，除非用户手工清理或到了过期时间，硬盘Cookie不会被删除，其存在时间是长期的。

因为HTTP协议是无状态的，对于一个浏览器发出的多次请求，WEB服务器无法区分 是不是来源于同一个浏览器。所以，需要额外的数据用于维护会话。Cookie 正是这样的一段随HTTP请求一起被传递的额外数据。Cookie只是一段文本，所以它只能保存字符串。而且浏览器对它有大小限制以及 它会随着每次请求被发送到服务器，所以应该保证它不要太大。Cookie的内容也是明文保存的，有些浏览器提供界面修改，所以， 不适合保存重要的或者涉及隐私的内容。

（2）cookies的设置和读取过程

- 服务器端

服务器端在HTTP响应Response Headers中设置一个Set-Cookie的HTTP头，来告诉浏览器端创建一个cookie。如下图所示，每个Set-Cookie表示一个cookie（如果有多个cookie，需写多个Set-Cookie），每个属性也是以名/值对的形式（除了secure），属性间以分号加空格隔开。格式如下：

```
Set-Cookie: name=value[; expires=GMTDate][; domain=domain][; path=path][; secure]
```

其中只有cookie的名字和值是必需的，其他都是可选的。注意这些通过Set-Cookie指定的可选项（域、路径、失效时间、secure标志）只会在浏览器端使用，它们都是服务器给浏览器的指示，以指定何时应该发送cookie。这些参数不会被发送至服务器端，只有name和value才会被发送到服务端。

- 浏览器端

浏览器在HTTP Request头中设置Cookie请求头中，将相关的cookeise发送到服务端的。

（3）cookies的格式及含义说明

cookies的格式如下：

```
name=value[; expires=GMTDate][; domain=domain][; path=path][; secure]
```

举例来说：

![](/images/cookies_session_1_1.png)

下面分别说明各部分的含义：

- name和value

name和value是cookies最核心的key-value键值对了。

- domain和path

domain和path这两个选项共同决定了哪些页面可以使用这个cookies，即访问哪些页面可以读取浏览器本地的cookies并且发送给服务器端。

举例来说：

![](/images/cookies_session_1_2.png)

domain参数是用来控制cookie对「哪个域」有效，默认为设置cookie的那个域。这个值可以包含子域，也可以不包含它。如上图的例子，domain选项中，可以是`.google.com.hk`（是不包含子域的，表示它对google.com.hk下的所有子域都有效，例如aa.google.com.hk等），也可以是`www.google.com.hk`（是包含子域的，该cookies仅能被www.google.com.hk所使用）。

path用来控制cookie发送的指定域的「路径」，它是在域名的基础下，指定可以访问的路径。默认为"/"，表示指定域下的所有路径都能访问。例如cookie设置为`domain=.google.com.hk; path=/webhp`，那么只有`.google.com.hk/webhp`及`/webhp`下的任一子目录如`/webhp/aaa`或`/webhp/bbb`会可以读取cookie信息，而`.google.com.hk`就不会发送，即使它们来自同一个域。

- expires/max-age

expries和max-age是用来决定cookie的生命周期的，也就是cookie何时会被删除。

- secure

secure是cookie的安全标志，通过cookie直接包含一个secure单词来指定，也是cookie中唯一一个非名值对儿的部分。指定后，cookie只有在使用SSL连接（如HTTPS请求）时才会发送到服务器。 默认情况为空，不指定secure选项，即不论是http请求还是https请求，均会发送cookie。

（4）Google Chrome清除和禁止浏览器Cookies

- 清除Cookies

```
设置 --> 显示高级设置 --> 内容设置 --> 所有Cookie和网站数据
```

- 禁止浏览器Cookies

```
设置 --> 显示高级设置 --> 内容设置
```

# session机制

session机制是一种服务器端的机制，服务器使用一种类似于散列表的结构（也可能就是使用散列表）来保存信息。

当程序需要为某个客户端的请求创建一个session的时候，服务器首先检查这个客户端的请求里是否已包含了一个session标识（称为session id），如果已包含一个sessionid则说明以前已经为此客户端创建过session，服务器就按照sessionid把这个session检索出来使用（如果检索不到，可能会新建一个），如果客户端请求不包含sessionid，则为此客户端创建一个session并且生成一个与此session相关联的session id，sessionid的值应该是一个既不会重复，又不容易被找到规律以仿造的字符串，这个session id将被在本次响应中返回给客户端保存。 保存这个sessionid的方式可以采用cookie，这样在交互过程中浏览器可以自动的按照规则把这个标识发挥给服务器。一般这个cookie的名字都是类似于SEEESIONID，而。比如weblogic对于web应用程序生成的cookie，如`JSESSIONID=ByOK3vjFD75aPnrF7C2HmdnV6QZcEbzWoWiBYEnLerjQ99zWpBng!-145788764`，它的名字就是JSESSIONID。

简单来说，WEB服务器会为每一个客户端创建一个session，web应用可以将一些信息保存到session中，然后WEB服务器生成一个session id传给客户端，然后客户端带着这个session id去请求WEB服务器，WEB服务器根据客户端的session id来找到对应的session对象，并获取其中的信息。

# cookie和session机制的区别与联系

举例来说，某家咖啡店有喝5杯咖啡免费赠一杯咖啡的优惠，这时就需要某种方式来纪录某位顾客的消费数量。有下面的几种方案：

- 服务员很厉害，能记住每位顾客的消费数量，只要顾客一走进咖啡店，店员就知道该怎么对待了。这种做法就是协议本身支持状态。

- 发给顾客一张卡片，上面记录着消费的数量，一般还有个有效期限。每次消费时，如果顾客出示这张卡片，则此次消费就会与以前或以后的消费相联系起来。这种做法就是在客户端保持状态。

- 发给顾客一张会员卡，除了卡号之外什么信息也不纪录，每次消费时，如果顾客出示该卡片，则店员在店里的纪录本上找到这个卡号对应的纪录添加一些消费信息。这种做法就是在服务器端保持状态。

将上面的例子映射到HTTP请求的状态信息上来，由于HTTP协议是无状态的，而出于种种考虑也不希望使之成为有状态的，因此，后面两种方案就成为现实的选择。具体来说cookie机制采用的是在客户端保持状态的方案，而session机制采用的是在服务器端保持状态的方案。同时我们也看到，由于采用服务器端保持状态的方案在客户端也需要保存一个标识，所以session机制可能需要借助于cookie机制来达到保存标识的目的，但实际上它还有其他选择。

学习资料参考于：
http://www.2cto.com/kf/201206/135471.html
https://segmentfault.com/a/1190000004743454
