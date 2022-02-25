---
title: HTTP 30X重定向跳转小结
date: 2018-08-26 22:39:02
tags:
categories: HTTP
---

# 30X重定向

HTTP 301代表永久性转移（Permanently Moved）。

HTTP 302代表暂时性转移（Temporarily Moved）。

# 301/302对搜索引擎来说的异同

302重定向是暂时的重定向，搜索引擎会抓取新的内容而保留旧的网址，因为服务器返回302代码，搜索引擎认为新的网址只是暂时的。301重定向是永久的重定向，搜索引擎在抓取新内容的同时也将旧的网址替换为重定向之后的网址。

举例来说，假如我们把`www.example.com`域名302重定向到网易`www.163.com`，搜索引擎会索引网易的内容到`www.example.com`域名下；如果使用301重定向，搜索引擎则会直接使用新域名w`ww.163.com`来做索引，放弃使用`www.example.com`来做索引。 对于搜索引擎来说，302重定向会让搜索引擎公司索引重复的内容。

# 使用HTTP 200来间接实现页面跳转

除了30X可以实现重定向的效果外，状态200其实也可以间接实现页面跳转的效果，以知乎跳转到百度首页的做法，请求地址为`https://link.zhihu.com/?target=https://www.baidu.com`，在浏览器器中输入该地址后，对应的请求过程如下：

![](/images/http_redirect_1_1.png)

可以看到，请求上述地址后，响应的状态码是200，响应的内容是空，但浏览器之后却访问（跳转到）了`http://www.baidu.com`的页面。
其实我们使用`curl "https://link.zhihu.com/?target=https://www.baidu.com"`，内容如下：

![](/images/http_redirect_1_2.png)

正如上图中看到，关键部分在`window.location.href=decodeURIComponent(URI);`这个JS会在浏览器中打开`https://www.baidu.com`页面，即浏览器自动发起了一次`https://www.baidu.com`的请求。需要注意的是，这段JS在Chrome的调试面板中是看不到的哦。有很多的SSO产品也用到了这个知识点哦。
