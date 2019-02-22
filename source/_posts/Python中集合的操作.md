---
title: Python中集合的操作
date: 2019-02-22 13:25:41
tags:
categories: Python
---

# set简介

set和dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key。

# set的创建

```python
s = set(str)        #使用字符串来构造集合
s = set([1, 2, 3])  #使用set函数，以list作为实参，即可构建一个集合对象。若list中有重复对象，会自动过滤掉
```

# set的操作

```python
s.add(key)    #往集合对象s中添加元素
s.remove(key) #删除集合对象s中某个元素
s1 & s2       #集合对象s1和s2做交集
s1 | s2       #集合对象s1和s2做并集
s1 - s2       #集合对象s1和s2做差集，也就是s1有，s2无的元素
```
