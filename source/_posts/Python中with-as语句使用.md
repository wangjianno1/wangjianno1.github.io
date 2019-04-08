---
title: Python中with-as语句使用
date: 2019-02-26 18:03:34
tags:
categories: Python
---

# with-as语句

从Python 2.6开始，with就成为默认关键字了。with是一个控制流语句，跟if/for/while/try等类似，with可以用来简化try-finally代码，看起来比try-finally更清晰，所以说with用很优雅的方式处理上下文环境产生的异常。with关键字的用法如下：

```python
with expression as variable:
    with block
```

该代码块的执行过程是： 

（1）先执行expression，然后执行该表达式返回的对象实例的`__enter__`函数，然后将该函数的返回值赋给as后面的变量。（注意，是将`__enter__`函数的返回值赋给变量）。

（2）然后执行with block代码块，不论成功，错误，异常，在with block执行结束后，会执行第一步中的实例的`__exit__`函数。

# with-as语句使用举例

（1）打开文件的例子

with-as语句最常见的一个用法是打开文件的操作，如下：

```python
with open("decorator.py") as file:
    print file.readlines()
```

（2）自定义

with语句后面的对象必须要有`__enter__`和`__exit__`方法，如下是一个自定义的例子：

```python
class WithTest():
    def __init__(self,name):
        self.name = name
        pass

    def __enter__(self):
        print "This is enter function"
        return self 

    def __exit__(self,e_t,e_v,t_b):
        print "Now, you are exit"

    def playNow(self):
        print "Now, I am playing"
   
print "**********"
with WithTest("coolboy") as test:
    print type(test)
    test.playNow() 
    print test.name
print "**********"
```

上述代码运行的结果如下：

    **********
    This is enter function
    <type 'instance'>
    Now, I am playing
    coolboy
    Now, you are exit
    **********

分析以上代码：  一二行，执行open函数，该函数返回一个文件对象的实例，然后执行了该实例的`__enter__`函数，该函数返回此实例本身，最后赋值给file变量。从456句可以印证。

自定义的类WithTest，重载了`__enter__`和`__exit__`函数，就可以实现with这样的语法了，注意在`__enter__`函数中，返回了self，在`__exit__`函数中，可以通过`__exit__`的返回值来指示with-block部分发生的异常是否需要reraise，如果返回false，则会reraise with block异常，如果返回ture，则就像什么也没发生。

# 上下文管理器contextlib模块对with-as的支持

contextlib模块提供了3个对象：装饰器contextmanager、函数nested上下文管理器closing。使用这些对象，可以对已有的生成器函数或者对象进行包装，加入对上下文管理协议的支持，避免了专门编写上下文管理器来支持with语句。

以contextlib的closing来说，closing帮助实现了`__enter__`和`__exit__`方法，用户不需要自己再实现这两个方法，但是被closing分装的对象必须提供close方法。contextlib.closing类的实现代码如下：

```python
class closing(object):
    # help doc here
    def __init__(self, thing):
        self.thing = thing
    def __enter__(self):
        return self.thing
    def __exit__(self, *exc_info):
        self.thing.close()
```

下面是一个使用contextlib.closing的例子：

```python
import contextlib
request_url = ('http://www.sina.com.cn/')
with contextlib.closing(urlopen(request_url)) as response:
    return response.read().decode('utf-8')
```

学习资料参考于：
http://www.choudan.net/2013/08/25/Python-With%E5%AD%A6%E4%B9%A0.html
