---
title: Python中元组tuple的操作
date: 2019-02-22 13:22:56
tags:
categories: Python
---

# python元组对象的定义

```python
elements = 'heilongjiang', 'jilin', 'liaoning'    #直接使用逗号分隔一些值，即可创建元组
elements = ('heilongjiang', 'jilin', 'liaoning')  #使用小括号
elements = 3,       #创建包含一个元素的元组，元素后面需要加上一个逗号
elements = (4,)     #创建包含一个元素的元组，后面必须有一个逗号哦，如果没有的话，elements就是一个普通的值变量
tuple([2, 5,8])     #使用一个list来构造元组
tuple('wahaha')     #使用一个字符串来构造元组
tuple((4, 5, 0))    #使用一个元组来构造元组
```

# python tuple的操作

就是序列的一些通用操作，例如索引、分片等。tuple是不可修改的序列。
