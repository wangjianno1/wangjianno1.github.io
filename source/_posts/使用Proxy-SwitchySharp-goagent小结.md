---
title: 使用Proxy SwitchySharp+goagent小结
date: 2018-02-03 18:24:54
tags:
categories: GFW
---

# Proxy SwitchySharp和goagent简介

Proxy SwitchySharp只是一个chrome浏览器的一个插件，该插件是一个代理配置管理的插件，就类似与IE里面的Internet选项的中的代理设置的功能一样，不过Proxy SwitchySharp的功能更强大。

goagent是Google公司开发的一个翻墙软件，说白了，我们利用goagent架设了一个自己的代理服务器。goagent包括server端和local端，server端要上传部署到Google App Engine（所以我们要在GAE上创建appid）上。local端就在本地计算机。注意，当goagent配置成功后，以后当我们想要翻墙的时候，要先在本机上运行`*/local/goagent.exe`程序。

当在Proxy SwitchySharp设置代理方式是`127.0.0.1:8087`就表示，我们使用了自己搭建的goagent代理服务器。

备注：
Proxy SwitchySharp不是必备的东东哦，当我们搞定goagent的配置后，我们可以再chrome的自己的代理设置出填上`127.0.0.1:8087`就可以上网了。如果使用IE浏览器的话，我们在Internet局域网配置中配置代理为`127.0.0.1:8087`后也就可以翻墙了。

# 使用goagent的原理结构图

![](/images/gfw_1_1.png)


学习资料参考于：
https://code.google.com/p/goagent/
