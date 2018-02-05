---
title: 关于html中外链元素http/https的简写问题汇总
date: 2018-02-05 20:31:14
tags: BKM
categories: SRE
---

# 关于URL中协议的省略——相对URL

HTML和CSS代码中引用的图片、媒体、CSS和JS文件中的URL都可以去掉协议部分（http:和https:），比如

```html
<script src="http://www.google-analytics.com/ga.js" type="text/javascript"></script>
<script src="https://www.google-analytics.com/ga.js" type="text/javascript"></script>
```

都可以换成：

```html
<script src="//www.google-analytics.com/ga.js" type="text/javascript"></script>
```

只要是使用http/https这两种协议都可以省略。原因是可以节省一点文件体积（当然只是那么一点点），另外一个原因是可以解决混合内容(mix-content)的问题（即https页面中引用了http元素，造成mix-content问题）。

以`//`开头的叫做相对URL（protocol-relative URL），相关的标准可以看RFC 3986 Section 4.2。总之浏览器遇到相对URL，则会根据当前的网页协议，自动在`//`前面加上相同的协议。如当前网页是http访问，那么所有的相对引用`//`都会变成`http://`，若当前网页是https访问，那么所有的相对引用`//`都会变成`https://`。如果你在本地查看，协议就会变成`file://`。

# 相对路径和绝对路径

假设现在有如下的文件目录结构：

```
d:\dreamdu\exe\1.html
d:\dreamdu\exe\first\2.html
d:\dreamdu\exe\first\3.html
d:\dreamdu\exe\first\second\4.html
```

（1）相对路径
2.html和3.html在同一个文件夹下，如果2.html链接到3.html，可以在2.html中这样写：

```html
<a href="3.html">同目录下文件间互相链接</a>
```

1.html是2.html和3.html的上级目录中的文件，如果2.html或3.html链接到1.html，可以在2.html或3.html中这样写：

```html
<a href="../1.html">链接到上级目录中的文件</a>
```

../ 代表一级上级目录(间隔一个目录) 

../../代表二级上级目录(间隔两个目录)，比如4.html链接到1.html，可以在4.html中这样写：

```html
<a href="../../1.html">链接到上级目录的上级目录中的文件</a>
```

2.html和3.html是1.html的下级目录中的文件，如果在1.html中链接到2.html， 可以在1.html中这样写：

```html
<a href="first/2.html">链接到下级目录(first)中的文件</a>
```

如果在1.html中链接到4.html，可以在1.html中这样写：

```html
<a href="first/second/4.html">链接到下级目录(first/second/)中的文件</a>
```

（2）绝对路径(Absolute Path)

绝对路径就是带有网址的路径，比如你有一个域名www.dreamdu.com，和一个网站空间，上面的四个文件就可以这么表示。

```html
<a href="http://www.dreamdu.com/exe/1.html">链接到1.html</a>
<a href="http://www.dreamdu.com/exe/first/2.html">链接到2.html</a>
<a href="http://www.dreamdu.com/exe/first/3.html">链接到3.html</a>
<a href="http://www.dreamdu.com/exe/first/second/4.html">链接到4.html</a>
```

（3）根目录

使用根目录的方式表示的路径和绝对路径的表示方式相似，去掉前面的域名就可。比如：

```html
<a href="/exe/1.html">链接到1.html</a>
<a href="/exe/first/2.html">链接到2.html</a>
```


学习资料参考于：
http://pandacafe.net/post/231
http://www.dreamdu.com/webbuild/relativepath_vs_absolutepath/
