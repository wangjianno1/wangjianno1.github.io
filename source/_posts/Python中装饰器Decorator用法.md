---
title: Python中装饰器Decorator用法
date: 2019-02-24 02:37:53
tags:
categories: Python
---

# 不带参数的装饰器

```python
@decorator
def func():
    pass
```

相当于：

```python
func = decorator(func)
```

# 多个装饰器

```python
@decorator_one
@decorator_two
def func():
    pass
```

相当于：

```python
func = decorator_one(decorator_two(func))
```

# 带参数的装饰器

```python
@decorator(arg1, arg2)
def func():
    pass
```

相当于：

```python
func = decorator(arg1, arg2)(func)  #这意味着decorator(arg1, arg2)这个函数需要返回一个“真正的decorator”
```

# 不带参数的类装饰器

```python
class myDecorator(object):
    def __init__(self, fn):
        print "inside myDecorator.__init__()"
        self.fn = fn
 
    def __call__(self):
        self.fn()
        print "inside myDecorator.__call__()"
 
@myDecorator
def aFunction():
    print "inside aFunction()"
 
print "Finished decorating aFunction()"
 
aFunction()

# 输出：
# inside myDecorator.__init__()
# Finished decorating aFunction()
# inside aFunction()
# inside myDecorator.__call__()
```

装饰器的地方相当于：

```python
aFunction = myDocorator(aFunction).__call__
```

# 带参数的类装饰器

```python
class myDecorator(object):
    def __init__(self, str):
        print "inside myDecorator.__init__()"
        self.str = str 
 
    def __call__(self, fn):
        print "inside myDecorator.__call__()"
        print "start", self.str
        print "end", self.str
        return fn
 
@myDecorator('aha')
def aFunction():
    print "inside aFunction()"
 
print "Finished decorating aFunction()"
 
aFunction()

# 输出
# inside myDecorator.__init__()
# inside myDecorator.__call__()
# start aha
# end aha
# Finished decorating aFunction()
# inside aFunction()
```

装饰器的地方相当于：

```python
aFunction = myDecorator('aha').__call__(aFunction)
```

学习资料参考于：
http://coolshell.cn/articles/11265.html
http://blog.jkey.lu/2013/03/15/python-decorator-and-functools-module/
http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000/001386819879946007bbf6ad052463ab18034f0254bf355000
