---
title: Python网页截屏（selenium+PhantomJS）
date: 2018-02-02 17:29:20
tags: Python实践
categories: Python
---

# selenium | PhantomJS简介

PhantomJS是一个基于webkit的没有界面的浏览器，也就是它可以像浏览器解析网页，功能非常强大。selenium是一个web的自动测试工具，可以模拟人的操作，支持市面上几乎所有的主流浏览器（Chrome/FireFox等），同时也支持PhantomJS这种无界面浏览器。

正是有了PhantomJS这种无界面的浏览器，所以我们可以在Linux字符界面下，截取网页内容并生成图片。

# Linux下使用selenium+PhantomJS截取网页

（1）安装PhantomJS

到`https://bitbucket.org/ariya/phantomjs/downloads/`页面上下载linux下二进制PhantomJS程序，放入/usr/local/bin或配置到环境变量中。

若是Windows平台，则需要下载windows下的二进制文件，并配置到系统环境变量PATH中。

备注：在linux平台上不要到`http://phantomjs.org`上下载，下载下来的二进制文件在执行时会报缺少so库的错误。

（2）安装selenium

直接使用`pip install selenium`安装selenium即可。

（3）编写截屏程序

代码如下所示：

```Python
from selenium import webdriver

driver = webdriver.PhantomJS()
#driver.set_window_size(1024, 768)

url = 'http://www.sohu.com';
driver.get(url)
title = driver.title     #获取html页面的标题
driver.save_screenshot(title + '.png')  #将截屏生成为本地png文件
```


学习资料参考于：
https://www.jianshu.com/p/520749be7377
