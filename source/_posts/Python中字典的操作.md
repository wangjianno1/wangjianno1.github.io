---
title: Python中字典的操作
date: 2019-02-22 13:28:31
tags:
categories: Python
---

# 字典对象的定义

```python
#直接定义
d = {'zhangsan': '82781443', 'lisi': '827866123', 'wangwu': '82781203'}

#用列表初始化
items = [('zhangsan', '82781443'), ('lisi', '827866123'), ('wangwu', '82781203')]
d = dict(items)

#用dict函数初始化
d = dict(zhangsan='82781443', lisi='827866123', wangwu='82781203')

#用dict函数初始化
d1 = {'zhangsan': '82781443', 'lisi': '827866123'}
d2 = {'wangwu': '82781203'}
d = dict(d1, **d2)

#使用列表，然后通过zip/dict来构造
names = ['zhangsan', 'lisi', 'wangwu']
contacts = ['82781443', '827866123', '82781203']
d = dict(zip(names, contacts))
```

# 字典的操作

## 基本操作

```python
len(d)   #返回字典的key-value对的数量
d[k]     #取出字典d中key为k的值
d[k]=v   #给字典中指定的key赋值，若key在字典中不存在，则增加key-value键值对
del d[k] #删除键为k的项
k in d   #检查d中是否有含有键为k的项
```

## 字典对象方法

```python
d.clear()            #清除字典中所有的项
d.copy()             #浅拷贝
d1 = deepcopy(d)     #深拷贝
d.get('keyname')     #获取key为keyname的元素值，如果不存在返回None
d.has_key('keyname') #判断字典对象是否有key为keyname的元素
d.pop('keyname')     #获取key为keyname的值，并将该key-value对从dict中移除
d.popitem()          #从字典对象中随机弹出弹出一个key-value对，并在dict中移除
d.setdefault('keyname', 'valuename')  #返回字典对象中key为keyname所对应的值。如果keyname在字典中不存在，那么会在字典中添加keyname:valuename键值对；如果keyname在字典中存在，那么直接过去该keyname对应的值
d.update(x)                  #使用字典x去更新字典d，若x的key在d中不存在就添加到d中；若x的key在d中存在，那么就会覆盖d中的value
d.items()和d.iteritems()     #items返回字典key-value的列表，iteritems返回所有key-value的迭代器
d.keys()和d.iterkeys()       #keys返回字典key的列表，iterkeys返回字典key的迭代器
d.values()和d.itervalues()   #values返回字典中所有value的列表，itervalues()返回字典中所有的value的迭代器
{}.fromkeys(['keyname_1', 'keyname_2'])    #生成一个{'key1': None, 'key2': None}的字典
dict.fromkeys(['keyname_1', 'keyname_2'])  #同上
```

# 字典实现原理

Python dict的底层数据结构还是数组，但是元素添加以及获取，需要定位到在数组中的问题，使用的是哈希表的原理。
