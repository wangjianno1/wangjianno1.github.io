---
title: Python中文件对象操作
date: 2019-02-24 11:25:49
tags:
categories: Python
---

# Python中文件对象操作

Python中的文件对象提供了三种读取方法，即read/readline/readlines。

# read函数

read方法一次读取整个文件，返回值是字符串。举例来说：

```python
#read不带参数，表示一下读取文件中所有内容，返回字符串
file_obj = open('data1.txt')
out = f.read()
print out

#read(n)带参数，表示一次读取n个字符
file_obj = open('data2.txt')
out_1 = file_obj.read(3)  #读取前3个字符
out_2 = file_obj.read(2)  #读取紧接着的2个字符
print out_1
print out_2
```

# readline函数

readline方法一次读取文件对象中的一行内容，返回值是字符串。可以配合for循环使用，每一次循环，读取一行内容。适用于文件比较大，内存比较小，不能一次将整个文件读入内存的情况，使用readline就比较好。

```python
file_obj = open('data.txt')
while True:
    line = file_obj.readline()
    if not line: break
    print line
file_obj.close()
```

# readlines函数

readlines方法一度读取整个文件，返回值是列表list。返回值是list，当然可以使用for循环啦。

```python
file_obj = open('data.txt')
for line in file_obj.readlines():
    print line
file_obj.close()
```
