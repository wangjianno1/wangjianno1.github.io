---
title: Python中一些重要函数（map|reduce|filter|sorted|range等）使用
date: 2019-02-26 17:17:29
tags:
categories: Python
---

# range函数

range函数可创建一个有一定规则的整数列表，函数原型如下：

```python
range(start, end, scan):
    #...
```

形参含义如下：

    start，表示计数从start开始，默认是从0开始，如range(5)等价于range(0, 5)
    end，表示计数到end结束，但不包括end，如range(0, 5)是[0, 1, 2, 3, 4]没有5
    scan，表示每次跳跃的间距，默认为1，如range(0, 5)等价于range(0, 5, 1)

举例来说：

    >>> range(5)
    [0, 1, 2, 3, 4]
    >>> range(0, 5)
    [0, 1, 2, 3, 4]
    >>> range(5)
    [0, 1, 2, 3, 4]
    >>> range(0, 5, 2)
    [0, 2, 4]
    >>> range(0, -5, -2)
    [0, -2, -4]
    >>> range(-5)
    []

# enumerate函数

enumerate函数用于将一个可遍历的数据对象（如列表、元组或字符串）组合为一个enumerate枚举对象，同时列出数据和数据下标，一般用在for循环当中。举例来说：

```python
seasons = ['Spring', 'Summer', 'Fall', 'Winter']

print enumerate(seasons)        #输出<enumerate object at 0x7f83e4c45550>
print list(enumerate(seasons))  #输出[(0, 'Spring'), (1, 'Summer'), (2, 'Fall'), (3, 'Winter')]

for index, season in enumerate(seasons):
    print index, season
```

# map函数

`map(function, sequence)`对sequence中的item依次执行function(item)，执行结果组成一个List返回。举例如下：

```python
def cube(x):
    return x*x*x

print map(cube, range(1, 11))  #输出结果为[1, 8, 27, 64, 125, 216, 343, 512, 729, 1000]
```

# reduce函数

`reduce(function, sequence, starting_value)`对sequence中的item顺序迭代调用function，如果有starting_value，还可以作为初始值调用，例如可以用来对List求和：

```python
def add(x,y):
    return x + y

print reduce(add, range(1, 11))     #输出结果为55 #1+2+3+4+5+6+7+8+9+10
print reduce(add, range(1, 11), 20) #输出结果为75 #1+2+3+4+5+6+7+8+9+10+20
```

# filter函数

`filter(function, sequence)`对sequence中的item依次执行function(item)，将执行结果为True的item组成一个List/String/Tuple（取决于sequence的类型）返回。例子如下：

```python
#例1
def f(x):
    return x % 2 != 0 and x % 3 != 0

print filter(f, range(2, 25)) #输出结果为[5, 7, 11, 13, 17, 19, 23]

#例2
def f(x):
    return x != 'a'

print filter(f, "abcdef")     #输出结果为bcdef
```

# sorted函数

`sorted(iterable[, cmp[, key[, reverse]]])`用来对一个可迭代的对象中包含的元素进行排序，返回一个新的List。

其中iterable是必须参数，为一个可迭代的对象。可选的参数有三个，分别是cmp、key和reverse。

（1）cmp参数指定一个定制化的比较函数，这个函数接收两个参数（iterable的元素），如果第一个参数小于第二个参数，返回一个负数；如果第一个参数等于第二个参数，返回零；如果第一个参数大于第二个参数，返回一个正数。默认值为None。

（2）key参数指定一个获取cmp函数参数的函数，这个函数用于从每个元素中提取一个用于比较的关键字。默认值为None。

（3）reverse是一个布尔值。如果设置为True，列表元素将被倒序排列。

备注：key指定的关键字，用来作为cmp所指定的比较函数中被比较的元素。

```python
def compare_reverse(x, y):   #自定义的比较函数
    if x < y:
        return 1
    elif x == y:
        return 0
    else:
        return -1
 
d_old = {'x': 31,'y': 5, 'zzx': 3, 'a': 4, 'b': 74, 'cc': 0}
 
#使用字典的value进行排序，默认为升序
#输出为[('cc', 0), ('zzx', 3), ('a', 4), ('y', 5), ('x', 31), ('b', 74)]
d_new_1 = sorted(d_old.items(), key = lambda x: x[1])

#使用字典的key长度来进行排序，默认为升序
#输出为[('a', 4), ('b', 74), ('y', 5), ('x', 31), ('cc', 0), ('zzx', 3)]
d_new_2 = sorted(d_old.items(), key=lambda x: len(x[0]))

#使用字典的key长度来进行排序，同时自定义了比较函数，比较的对象还是key函数的返回值
#输出为[('zzx', 3), ('cc', 0), ('a', 4), ('b', 74), ('y', 5), ('x', 31)]
d_new_3 = sorted(d_old.items(), cmp = compare_reverse, key = lambda x: len(x[0]))

#使用字典的key长度来进行排序，同时通过reverse参数来标注是否需要翻转
#输出为[('zzx', 3), ('cc', 0), ('a', 4), ('b', 74), ('y', 5), ('x', 31)]
d_new_4 = sorted(d_old.items(), key = lambda x: len(x[0]), reverse = True)
```
