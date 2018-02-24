---
title: RawGit_为GitHub服务的Global CDN
date: 2018-02-24 17:29:04
tags:
categories: 杂货铺
---

# RawGit介绍

RawGit是一个全球性的CDN服务，它是专门用来缓存GitHub上的代码文件的。值得注意的是，RawGit不是GitHub提供的服务，这个服务是由GitHub使用者Ryan Grove自发性提供的，因此不保证SLA。

# RawGit的使用

打开网址`https://rawgit.com/`，将GitHub上的文件路径地址，复制到页面的文本框中，就会自动生成rawgit相关的地址。通过新生成的地址访问文件时，就会使用到RawGit提供的CDN加速服务。举例来说，原始GitHub文件地址为`https://github.com/wangjianno1/MyFirstProject/blob/master/HelloWorld.java`，生成RawGit  CDN地址如下：

	https://cdn.rawgit.com/wangjianno1/MyFirstProject/1f914100/HelloWorld.java
	https://rawgit.com/wangjianno1/MyFirstProject/master/HelloWorld.java

其中`https://rawgit.com/xxx`用于开发或测试环境，文件更新后几分钟内会生效。`https://cdn.rawgit.com/xxx`用于正式环境，它走的是全球的CDN，沒有流量限制，文件第一次被缓存后就会被永久Cache。

学习资料参考于：
https://blog.ccjeng.com/2015/07/GitHub-RawGit-Raw-File.html