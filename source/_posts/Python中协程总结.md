---
title: Python中协程总结
date: 2019-02-24 02:27:26
tags:
categories: Python
---

# 协程coroutine的简介

协程的原理很简单，打个比方就能讲明白了。假设说有十个人去食堂打饭，这个食堂比较穷，只有一个打饭的窗口，并且也只有一个打饭阿姨，那么打饭就只能一个一个排队来打咯。这十个人胃口很大，每个人都要点5个菜，但这十个人又有个毛病就是做事情都犹豫不决，所以点菜的时候就会站在那里，每点一个菜后都会想下一个菜点啥，因此后面的人等的很着急呀。这样一直站着也不是个事情吧，所以打菜的阿姨看到某个人犹豫5秒后就开始吼一声，会让他排到队伍最后去，先让别人打菜，等轮到他的时候他也差不多想好吃啥了。这确实是个不错的方法，但也有一个缺点，那就是打菜的阿姨得等每个人5秒钟，如果那个人在5秒内没有做出决定吃啥，其实这5秒就是浪费了。一个人点一个菜就是浪费5秒，十个人每个人点5个菜可就浪费的多啦（菜都凉了要）。那咋办呢？这个时候阿姨发话了：大家都是学生，学生就要自觉，我以后也不主动让你们排到最后去了，如果你们觉得自己会犹豫不决，就自己主动点直接点一个菜就站后面去，等下次排到的时候也差不多想好吃啥了。这个方法果然有效，大家点了菜后想的第一件事情不是下一个菜吃啥，而是自己会不会犹豫，如果会犹豫那直接排到队伍后面去，如果不会的话就直接接着点菜就行了。这样一来整个队伍没有任何时间是浪费的，效率自然就高了。

这个例子里的排队阿姨的那声吼就是我们的CPU中断，用于切换上下文。每个打饭的学生就是一个task。而每个人自己决定自己要不要让出窗口的这种行为，其实就是我们协程的核心思想。

在用线程的时候，其实虽然CPU把时间给了你，你也不一定有活干，比如你要等IO、等信号啥的，这些时间CPU给了你你也没用呀。

在用协程的时候，CPU就不来分配时间了，时间由你们自己决定，你觉得干这件事情很耗时，要等IO啥的，你就干一会歇一会，等到等IO的时候就主动让出CPU，让别人上去干活，别人也是讲道理的，干一会也会把时间让给你。协程就是使用了这种思想，让编程者控制各个任务的运行顺序，从而最大可能的发挥CPU的性能。

# Python中的协程是用关键字yield来实现的

在Python中，包含yield表达式的函数是特殊的函数，叫做生成器函数(generator function)，被调用时将返回一个迭代器（iterator），调用时可以使用next或send(msg)。它的用法与return相似，区别在于它会记住上次迭代的状态，继续执行。如下用来说明生成器函数和普通的函数的区别：

```python
def func():
    return 1

def gen():
    yield 1

print(type(func))   #<class 'function'>
print(type(gen))    #<class 'function'>

print(type(func())) #<class 'int'>
print(type(gen()))  #<class 'generator'>
```

下面是使用协程的一个例子：

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def consumer():
    r = ''
    while True:
        n = yield r
        if not n:
            return
        print('[CONSUMER] Consuming %s...' % n)
        r = '200 OK'

c = consumer()
c.send(None)
n = 0
while n < 5:
    n = n + 1
    print('[PRODUCER] Producing %s...' % n)
    r = c.send(n)
    print('[PRODUCER] Consumer return: %s' % r)
c.close()
```

上面程序的输出结果为：

```text
[PRODUCER] Producing 1...
[CONSUMER] Consuming 1...
[PRODUCER] Consumer return: 200 OK
[PRODUCER] Producing 2...
[CONSUMER] Consuming 2...
[PRODUCER] Consumer return: 200 OK
[PRODUCER] Producing 3...
[CONSUMER] Consuming 3...
[PRODUCER] Consumer return: 200 OK
[PRODUCER] Producing 4...
[CONSUMER] Consuming 4...
[PRODUCER] Consumer return: 200 OK
[PRODUCER] Producing 5...
[CONSUMER] Consuming 5...
[PRODUCER] Consumer return: 200 OK
```

在上面中执行`c = consumer()`时，consumer函数并没用直接执行，而是直接返回一个迭代器并赋给变量c。当调用`c.send(None)`（或`c.next()`），就会触发consumer函数执行，执行到`yield r`后释放CPU控制权，返回调用处，并将`r`作为返回值传递给调用处。然后后面再执行`c.send(n)`时，就会再次进入到`yield r`代码处，此时不会执行`yield r`，而是将send函数的参数值直接作为`yield r`的返回值赋给变量n。

在consumer函数中`yield r`是一个表达式，当在consumer中执行到这个函数时，会将yield后面紧跟的值返回给调用者，并等待`send(msg)`中的msg值，将msg作为yield表达式的返回值。

备注：

如果一个函数中有yield表达式，那么这个函数就不是一个普通的函数，就是一个generator函数，即生成器函数。

生成器约等于迭代器。

执行到yield语句时，就是释放执行权。等下次调度时，再继续执行下去。

学习资料参考于：
http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001432090171191d05dae6e129940518d1d6cf6eeaaa969000#0
http://www.cnblogs.com/huxi/archive/2011/07/14/2106863.html
http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000/00138681965108490cb4c13182e472f8d87830f13be6e88000
http://blog.csdn.net/gzlaiyonghao/article/details/5397038
