---
title: HTML基础
date: 2018-07-08 01:59:18
tags:
categories: HTML
---

# HTML简介

HTML指的是超文本标记语言，HyperText Markup Language，它不是一种编程语言，而是一种标记语言。由HTML标签和文本内容加在一起就是HTML文档或WEB页面。

目前，HTML有好多版本，具体如下：

![](/images/html_1_1.png)

为了让浏览器能正确显示不同HTML版本的网页，需要在WEB页面中使用`<!DOCTYPE>`声明来表明HTML文档所使用的HTML的版本，例如下面是HTML 4.01的类型：

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
```

# HTML标签

HTML标记标签通常被称为HTML标签(HTML tag)。HTML标签是由尖括号包围的关键词，比如`<html>`。HTML标签通常是成对出现的，比如`<b>`和`</b>`。标签对中的第一个标签是开始标签，也称为开始标签；第二个标签是结束标签，也称为闭合标签。

```html
<标签>内容</标签>
```

由HTML元素组成的WEB页面如下图所示：

![](/images/html_1_2.png)

# HTML标签的属性

HTML元素可以设置属性，属性可以在元素中添加附加信息，属性一般描述于开始标签，属性总是以名称/值对的形式出现，比如：`name="value"`。例如超链接标签`<a>`，其跳转的目的地址就时放到属性`herf`中。

```html
<a href="http://www.baidu.com">超链接到百度首页</a>
```

一般来讲，HTML元素一般有很多属性，通用的属性有：

（1）class

可以为标签定义一个或多个类名。同一个class名称就代表了WEB页面元素的某个集合。

（2）id

定义元素的唯一id

（3）style

指明html元素的样式风格

（4）title

描述了元素的额外信息

# HTML DOM

DOM，全称为Document Object Model，中文为文档对象模型。HTML DOM就是HTML语言对外界开通的接口，以便其他语言能够访问或修改HTML内部的元素。

# HTML文档的编码声明

目前在大部分浏览器中，直接输出中文会出现中文乱码的情况，这时候我们就需要在头部将字符声明为`UTF-8`。在`<head>`标签里面加入`<metacharset="UTF-8">`标签，表明文档的编码类型为`UTF-8`。
