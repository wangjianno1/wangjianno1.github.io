---
title: Python中序列的通用操作
date: 2019-02-22 12:08:17
tags:
categories: Python
---

# 序列通用操作

Python中序列包括列表list、元组tuple、字符串、Unicode字符串、buffer对象以及xrange对象六种。对于Python中的序列，有一些通用的操作，如索引、分片、加、乘、成员资格判断以及内建函数等等。

# 索引

序列中的元素都是有编号的，从0开始递增。我们可以使用`sequence[index]`的方式访问序列中第index位置处的元素。注意index可以是正数，也可以是负数。-1表示的最后一个元素，-2表示倒数第二个元素，依次类推。举例来说：

```python
str = 'beijing'
print str[2]         #输出为i
print 'shanghai'[3]  #输出为n
print 'wuhan'[-2]    #输出a
```

# 分片

与使用索引来访问单个元素类似，可以使用分片操作来访问一定范围内的元素，即使用`sequence[start:end]`来访问序列中若干元素。关于分片有几个需要注意的点：

（1）使用`sequence[start:end]`可以获取到序列中大于等于start，小于end范围内的元素。注意不包括end所在位置处的元素

（2）`sequence[start:end]`中start和end可以是正数，也可以是负数。-1表示是最后一个元素所对应的索引

（3）`sequence[start:end]`中start所指的元素要出现在end所指的元素的前面。否则分片的结果是一个空list

（4）`sequence[start:end]`中，若start省略掉，表示从第一个元素开始。若end省略掉，表示分片直到最后一个元素结束。注意end省略，和-1的效果是不一样的哦，若为-1的话，分片的结果是不包括最后一个元素的。而end省略，是包括最后一个元素的。

（5）`sequence[start:end:step]`可以使用指定的步长step来分片，步长step可以是正数，也可以是负数。如果step是正数，那么分片会从序列的头部开始向右提取元素。如果step是负数，那么分片会从序列的尾部开始向左提取元素。举例来说：

```python
elements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print elements[2:4]     #输出[3, 4]
print elements[-3:-1]   #输出[8, 9]
print elements[-3:0]    #输出[],因为-3所指的元素在0所指的元素的后面
print elements[:3]      #输出[1, 2, 3]
print elements[-3:]     #输出[8, 9, 10]
print elements[:]       #copy出一个新的elements列表
print elements[-3:-1]   #输出[8, 9]
print elements[0:10:2]  #输出[1, 3, 5, 7, 9]
print elements[10:0:-2] #输出[10, 8, 6, 4, 2]
```

# 加

通过使用加号+可以进行序列的连接操作，举例来说：

```python
print [1, 2, 3] + [4, 5, 6]  #输出[1, 2, 3, 4, 5, 6]
print 'hello' + 'world'      #输出helloworld
```

# 乘

用序列乘以一个数字n会生成一个新的序列，而在新的序列中，原来的序列将被重复n次。举例来说：

```python
print 'python' * 2  #输出pythonpython
print [2, 3] * 3    #输出[2, 3, 2, 3, 2, 3]
print [None] * 2    #输出[None, None]
```

# 成员资格判断

可以使用`in`操作符，来检查一个值是否在序列中。举例来说：

```python
str = 'helloworld'
print 'w' in str   #输出为True
```

# 通用的内建函数

一些Python内建函数，可以作用于序列。比如`len`、`min`以及`max`等。举例来说：

```python
elements = [34, 56, 13]
print max(elements)
print min(elements)
print len(elements)
print max(3, 5)     #这里并没有使用序列，注意
print min(3, 7, 2)  #这里并没有使用序列，注意
```
