---
title: Python中迭代器和生成器总结
date: 2019-02-24 02:17:09
tags:
categories: Python
---

# 迭代器Iterator

一个实现了`__iter__`方法的对象是可迭代的，一个实现了`next`方法的对象则是迭代器。调用`__iter__`方法会返回一个迭代器自身，然后利用迭代器的`next`方法会返回下一个值。如果已经迭代完成，迭代器没有值可以返回，就会引发一个`StopIteration`的异常。

迭代器的使用举例：

```python
#!/usr/bin/python

city = ['beijing', 'shanghai', 'tianjin', 'chongqing']
it = iter(city)

print type(it)

#方法一：使用for循环来使用迭代器
for x in it:
    print x

#方法二：使用next方法来使用迭代器
print it.next()
print it.next()
print it.next()
print it.next()
```

其中`iter()`方法获取了list的迭代器对象

自定义迭代器的举例：

```python
#!/usr/bin/python

class MyRange(object):
    def __init__(self, n):
        self.idx = 0
        self.n = n

    def __iter__(self):
        return self

    def next(self):
        if self.idx < self.n:
            val = self.idx
            self.idx += 1
            return val
        else:
            raise StopIteration()

myRange = MyRange(3)
for elem in myRange:
    print elem
```

# 生成器

一个包含了yield关键字的函数就是一个生成器，该函数也叫生成器函数。当生成器函数被调用时，在函数体中的代码不会被执行，而会返回一个迭代器。每次请求一个值，就会执行生成器中代码，直到遇到一个yield表达式或return语句。yield表达式表示要生成一个值，return语句表示要停止生成器。

换句话说，生成器是由两部分组成，生成器的函数和生成器的迭代器。生成器的函数是用def语句定义的，包含yield部分。生成器的迭代器是这个函数返回的部分。二者合起来叫做生成器。

几个需要注意的的点：

（1）调用生成器函数时，不会执行生成器函数的代码，而是直接返回一个迭代器iterator对象

（2）生成迭代器对象后，可以使用`iterator_obj.next()`或者`iterator_obj.send(None)`来执行，切记使用send函数第一次调用生成器时，参数必须是None，不然会抛出异常。

（3）`yield xxx`是表达式，不是python。yield xxx会将xxx值返回给send或者next函数。同时yield xxx也有返回值，返回值即为send函数中的参数。

生成器使用举例：

```python
#!/usr/bin/python

def repeater(value):
    while True:
        new = yield value
        if new is not None: value = new

it = repeater(42)

print type(it)
print it.next()  #亦可以使用print it.send(None)
print it.send('Hello, Gays!!!')
```

返回结果如下：

    <type 'generator'>
    42
    Hello, Gays!!!

备注：Python中可以使用生成器来实现Python协程编程。当然，还可以使用第三方的库来实现Python协程编程。
