---
title: Python自省机制及dir|hasattr|getattr|setattr使用
date: 2019-02-24 12:03:01
tags:
categories: Python
---

# Python的自省机制

在计算机编程中，自省是指这种能力，检查某些事物以确定它是什么、它知道什么以及它能做什么。整个Python 语言对自省提供了深入而广泛的支持。实际上，很难想象假如Python语言没有其自省特性是什么样子。像dir()、hasattr()、getattr()、setattr()都属于Python自省机制中的核心函数。

# dir()|hasattr()|getattr()|setattr()的使用

（1）`dir([obj])`

dir()函数是一个python内置函数，可能是Python自省机制中最著名的部分了。它返回传递给它的任何对象的经过排序的属性名称列表（会有一些特殊的属性不包含在内）。如果不指定对象，则dir()返回当前作用域中的名称（obj的默认值是当前的模块对象）。

举例来说：

![](/images/python_self_1_1.png)

（2）`hasattr(obj, attr)`

这个方法用于检查obj是否有一个名称为attr的属性，返回一个布尔值。

（3）`getattr(obj, attr)`

getattr是一个python内置函数，也是自省机制里面的核心函数，可以返回一个对象的所有属性。调用这个方法将返回obj中名称为attr的属性值，例如如果attr为'bar'，则返回obj.bar。getattr的返回值是方法属性，则可以直接调用这个函数。举例如下：

![](/images/python_self_1_2.png)

（4）`setattr(obj, attr, val)`

调用这个方法将给obj的名称为attr的属性赋值为val。例如如果attr为'bar'，则相当于`obj.bar = val`。

参考学习资料来源于：
https://www.ibm.com/developerworks/cn/linux/l-pyint/
