---
title: Python开发中一些闲杂知识
date: 2019-03-18 15:18:30
tags:
categories: Python
---

# Python语言特点

Python语言是一种解释型的、面向对象的、带有动态语义的高级程序设计语言。其中解释型语言对应于编译型语言。

Remarks：解释型语言有awk、Perl、Python、Ruby、Shell等等

# IDLE

IDLE是集成开发环境IDE，而Python安装目录下面的python_dir/python.exe才是Python语言的解释器。

# Python中type()函数

Python中type()函数可以查看一个Python对象的数据类型。

# Python中None

python中没有null，但是None。python中None的含义和其他语言中null是一样的。

# Python没有自增自减运算符

```python
a = 4
a++     #不合法
a--     #不合法
a += 1  #合法
a -= 2  #合法
```

# `*.py`和`*.pyw`异同

直接双击`*.py`文件运行Python文件，会出现一个类似于DOS的窗口。而直接双击`*.pyw`文件运行Python文件就不会出现这个DOS窗口。

# 一些Pythonic例子

```python
a, b = b, a  #交换两个变量的值
```
