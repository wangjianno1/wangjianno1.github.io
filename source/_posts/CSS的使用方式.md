---
title: CSS的使用方式
date: 2018-07-08 02:22:54
tags:
categories: CSS
---

# 外部样式表

外部样式表就是将CSS的内容定义在一个单独的文件中，这样就可以使用同一个CSS样式表来控制多个HTML文档。然后HTML文档使用`<link>`标签链接到外部样式表。 `<link>`标签在HTML文档的头部：

```html
<head>
    <link rel="stylesheet" type="text/css" href="mystyle.css">
</head>
```

# 内部样式表

当单个文档需要特殊的样式时，就应该使用内部样式表。你可以使用`<style>`标签在文档头部定义内部样式表，像如下方式：

```html
<head>
<style>
hr {color:sienna;}
p {margin-left:20px;}
body {background-image:url("images/back40.gif");}
</style>
</head>
```

# 内联样式

内联样式，就是在HTML标签内使用样式`style`属性，`style`属性可以包含任何CSS属性。如下例子是用来控制段落的颜色和左外边距：

```html
<p style="color:sienna;margin-left:20px">This is a paragraph.</p>
```

# 各种使用方式的优先级

当一个HTML文档同时使用了外部样式表、内部样式表和内联样式。这时候各个样式表会合并成一个样式，假设样式表1中定义了`a`元素，样式表2中定义了`b`元素上，那么最终的`a`和`b`都会得到控制。但是如果不同的样式表对同一个元素进行了重复的定义，那么就会使用样式表的优先级来覆盖，优先级为`内联样式 > 内部样式表 > 外部样式表 > 浏览器缺省值`，也就是内联样式的优先级最大。
