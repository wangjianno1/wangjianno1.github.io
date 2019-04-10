---
title: Python中控制逻辑语句
date: 2019-02-22 14:23:29
tags:
categories: Python
---

# if条件语句

```python
if expr_1:
    statement
elif expr_2:
    statement
else:
    statement
```

备注，if语句也可以组成Python的三元表达式，如下：

```python
z = x if expr else y
```

如上语句表示如果expr为True，三元表达式返回x，否则返回y。有点类似C/C++语言中`bool?a:b`表达式，但Python中并没有问号表达式。

# while循环语句

```python
while expr:
    statement
```

# for循环语句

```python
for word in words:
    statement
```

# 使用举例

（1）遍历列表

```python
citys = ['beijing', 'shanghai', 'chongqin', 'tianjin']

for city in citys:
    print city

for i in range(len(citys)):
    print citys[i]

for i, num in enumerate(nums):
    print i, num
```

（2）遍历字典

```python
dict_citys = {'beijing': 1, 'tianjin': 2, 'chongqin': 3, 'shanghai': 4} 
for key in dict_citys: 
    print key, 'corresponds to', dict_citys[key] 
 
for key, value in dict_citys.items(): 
    print key, 'corresponds to', dict_citys[key] 
```
