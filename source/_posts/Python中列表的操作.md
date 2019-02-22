---
title: Python中列表的操作
date: 2019-02-22 12:28:54
tags:
categories: Python
---

# Python列表对象的定义

```python
elements = ['heilongjiang', 'jilin', 'liaoning']
list('wahaha')  #输出['w', 'a', 'h', 'a', 'h', 'a']
```

# Python列表list的操作

（1）序列的通用操作

（2）特殊操作

```python
lst[index] = value  #对指定元素赋值
del lst[index]      #删除index位置处的元素
```

（3）列表对象的方法

```python
lst.append(value)        #在列表尾部新增一个元素
lst.count(value)         #统计列表中value元素出现的次数
lst_a.extend(lst_b)      #将lst_b中的所有元素追加到lst_a列表对象中。注意与lst_a + lst_b的区别，extend不会新增一个新的list出来
lst.index(value)         #列表lst中value第一次出现的索引位置
lst.insert(index, value) #将value元素插入到列表的index位置
lst.pop()                #返回列表最后一个元素，并从列表中移除该元素
lst.pop(index)           #返回列表中index位置处的元素，并从列表中移除
lst.remove(value)        #移除列表中第一个值为value的元素，remove没有返回值，注意与pop的区别
lst.reverse()            #对列表中元素倒置，是直接对列表进行修改
lst.sort()               #对列表在原位置进行排序，注意sort函数有三个关键字参数cmp，key，reverse，其中cmp和key都是一个函数，cmp函数有两个参数，函数内容用来自定义比较的规则。key函数有一个参数，函数内容用来返回cmp函数要比较的key。这个用法同内置的sorted函数是一样的
```
