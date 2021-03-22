---
title: Python中函数定义及形参实参使用
date: 2019-02-23 20:13:49
tags:
categories: Python
---


# Python中函数定义

Python中函数的定义形式：

```python
def func_name(parameter1, parameter2, ...):
    语句段
    return语句
```

例子：

```python
def print_hello(personname):
    return "Hello," + personname + "!"
```

# Python中位置参数与关键字参数

我的理解是，**位置参数与关键字参数都是指实参的传递形式，并非函数定义中的形参的形式哦**。

假设函数定义如下：

```python
def foo(familyname, givenname):   #调用foo函数时，参数的顺序是由严格顺序的
    return familyname + givenname

foo('wang', 'hao')   #是正确的，位置参数
foo('hao', 'wang')   #是错误的，位置参数

foo(familyname='wang', givenname='hao')   #是正确的，关键字参数
foo(givenname='hao', familyname='wang')   #是正确的，关键字参数
```

# Python中默认参数

定义函数时可以定义默认参数，形式如下：

```python
def foo(familyname='wang', givenname='hao'):
    return familyname + givenname
```

备注：对于默认形参，在调用函数时，可以不传递实参。

# Python中可变参数

（1）函数定义可变参数

形式1：

```python
def foo(*params):   #params在函数体内的类型是元组
    pass

foo(1, 4, 56)       #调用方式
```

形式2：

```python
def foo(**params):  #params在函数体内的形式是字典
    pass

foo(x=1, y=4, z=56) #调用方式
```

举一个普通参数，形式1（位置参数）和形式2（关键字参数）联合一起的复杂的例子，如下所示：

```python
def print_params(x, y, z=3, *pospar, **keypar):
    print x, y, z
    print pospar
    print keypar

if __name__ == '__main__':
    print_params(1, 2, 3, 5, 6, 7, foo=1, bar=2)
```

上述程序输出结果为：

    1 2 3
    (5, 6, 7)
    {'foo': 1, 'bar': 2}

我们通常用这两种可变参数来使函数收集参数，所有我们经常会见到一种函数的定义：

```python
def func(fargs, *args, **kwargs)  #其中fargs是普通参数，*args和**kwargs用来收集不定量的形参
    pass
```

# 实参两种特殊传递形式

（1）以元组作为实参

```python
def foo(familyname, givenname):
    print 'my familyname is ' + familyname
    print 'my givenname is ' + givenname

if __name__ == "__main__":
    username = ('wang', 'hao')
    foo(*username)
```

（2）以字典作为实参

```python
def foo(familyname, givenname):
    print 'my familyname is ' + familyname
    print 'my givenname is ' + givenname

if __name__ == "__main__":
    username = {'givenname': 'hao', 'familyname': 'wang'}
    foo(**username)
```

# 在函数体内修改参数内容会影响到函数外的对象的问题

如果数字、字符串或元组，本身就是不可变的，自然也不会影响到函数体外的对象

如果是列表或字典，那么函数内修改参数内容，就会影响到函数体外的对象。

备注：**这里的修改参数是修改参数对象内部的值，不是赋值哦**。即`var[1] = 'hello'`和`var = ['hello', 'world']`区别。即使是列表，在函数体内对参数重新赋值了，不会影响到函数体外的对象哦。注意和c++的比较。

# Python函数的嵌套

Python语言允许在定义函数的时候，其函数体内又包含另外一个函数的完整定义，这就是我们通常所说的嵌套定义。

实例1：

```python
def foo():         #定义函数foo()，
    m=3            #定义变量m=3;

    def bar():     #在foo内定义函数bar()
        n=4        #定义局部变量n=4
        print m+n  #m相当于函数bar()的全局变量

    bar()          #foo()函数内调用函数bar()
```

实例2：

```python
def bar(m):
    n=4
    print m+n

def foo()
    m=4
    bar(m)
```

实例2首先定义函数`bar()`，然后再次定义`foo()`函数，此时`bar()`和`foo()`完全独立的两个函数，再次`foo()`函数内调用`bar()`；
其实实例1和实例2中的嵌套作用是一样只是两种不同的表现形式。

# Python匿名函数

在Python中，关键字lambda是用来创建匿名函数的，其语法格式为：

    lambda [arg1[, arg2, ... argN]]: expression

使用举例：

```python
#法一
fun = lambda x,y:x+y
print fun(1,2)              #输出结果为3

#法二
print (lambda x,y:x+y)(1,2) #输出结果为3
 
#上面法一和法二相当于
def func_1(x, y):
    return x + y
print func_1(1, 2)
```
