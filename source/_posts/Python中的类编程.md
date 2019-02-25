---
title: Python中的类编程
date: 2019-02-24 01:22:37
tags:
categories: Python
---

# Python中类定义和使用

```python
class Shape:      #定义类Shape
    def draw(self):
        print "draw a shape"

    def setName(self, name):
        self.name = name

    def getName(self):
        print self.name

class Rectangle(Shape): #定义类Rectangle，并继承父类Shape
    def draw(self):     #覆写|重写draw方法
        print "darw a rectangle"

if __name__ == "__main__":
    shape = Shape()
    shape.setName("shape")
    shape.getName()
    shape.draw()
        
    rect = Rectangle()
    rect.setName("Rectangle")
    rect.getName()
    rect.draw()
```

备注：

（1）成员方法的第一个参数必须是`self`，表示对象自身。当在一个成员方法调用该类的成员变量或其他成员方法时，必须带上`self`关键字，这和JAVA中的this是有区别的，在JAVA中是可以带上this，也可以不带上this。

（2）Python支持多继承，书写形式为`class Rectangle(Shape, Color)`，表示Rectangle有两个父类（Shape和Color）。如果在Shape和Color有一个相同的成员，按照继承书写的先后顺序，前面的父类覆写后面的父类，即Shape类中的方法覆写Color类。

# 在Python的class声明中，几个需要注意的地方

（1）变量分为实例变量和类变量；方法分为实例方法、类方法和静态方法。

实例变量就是在方法被`self.xxx = xxoo`定义的变量；类变量是直接在类中声明的变量。实例方法就是普通方法；类方法是被`@classmethod`装饰的方法；静态方法是被`@staticmethod`装饰的方法。举例来说，

```python
class Foo:
    var = 12                #类变量

    def foo_1(self):        #实例方法
        print "draw a shape"

    @staticmethod
    def foo_2(self, name):  #静态方法
        self.kaka = name    #定义了一个实例变量kaka

    @classmethod
    def foo_3(self):        #类方法
        print self.name
```

（2）对于实例变量，只能通过实例来访问变量。而对于类变量，既可以通过实例来访问变量，也可以直接类来访问变量。

（3）对于实例方法，只能通过实例来访问。对于类方法，既可以通过实例，也可以直接通过类来访问。对于静态方法，既可以通过实例，也可以直接通过类来访问。

（4）在变量和方法的命名前加上双下划线，表示的是私有变量或私有方法。对外是不可以见的。

（5）在Python中，变量名类似`__xxx__`的，也就是以双下划线开头，并且以双下划线结尾的，是特殊变量，特殊变量是可以直接访问的，不是private变量。

# Python类中的几个特殊函数

（1）`__new__`函数是创建类的对象的函数，相当于C++中构造函数。

（2）`__init__`函数会在`__new__`之后被调用，用来初始化对象的。

（3）`__del__`函数是对象将要被销毁的时候被调用，用来将对象所占用的内存资源释放给操作系统，相当于C++中的析构函数。

# Python中私有成员的定义

在Python中如果将一个成员前面加上双下划线`__`，就表示该成员是私有成员，不能通过对象直接访问，需要通过对象的public接口间接地访问。

Python中私有成员和其他语言中的私有成员不太一样，Python中的私有成员通过一定的特殊方式还是可以访问的。这就和Python语言底层实现私有成员的方案有关。在Python中私有成员的其实是使用了“名称变化术”。具体说来，就是Python将类的内部定义的以双下划线`__`的成员“翻译”成前面加上单下划线和类型的形式。

例如在类Bird中有`def __talk(self):`成员方法，我们可以通过`obj._Bird__talk()`来访问。

# 新式类与旧式类

由于Python的版本变化，形成了新式类和老式类，有一些特性在老式类中是不支持的，因此在使用老式类已经没有必要了。因为在定义一个类的时候，需要注明使用新式类。标注类为新式类有两种方法：

法一（在模块文件的开头添加如下语句）：

```python
__metaclass__ = type   #使用新式类
```

法二（定义新类时，显式地继承object类）:

```python
class MyClass(object): #继承类object
```

# Python类中的装饰器`@staticmethod`和`@classmethod`

代码范例如下：

```python
class A(object):
    bar = 1

    def foo(self):
        print 'foo'

    @staticmethod
    def static_foo():
        print 'static_foo'
        print A.bar

    @classmethod
    def class_foo(cls):
        print 'class_foo'
        print cls.bar
        cls().foo()

A.static_foo()
A.class_foo()
```

程序输出结果为：

    static_foo
    1
    class_foo
    1
    foo

`@staticmethod`和`@classmethod`都可以直接`类名.方法名()`或者`实例名.方法名()`来调用。

![](/images/python_class_1_1.png)

（1）`@staticmethod`

不需要表示自身对象的`self`和自身类的`cls`参数，就跟使用函数一样。

（2）`@classmethod`

也不需要`self`参数，但第一个参数需要是表示自身类的`cls`参数。

如果在`@staticmethod`中要调用到这个类的一些属性方法，只能直接`类名.属性名`或`类名.方法名`。

而`@classmethod`因为持有`cls`参数，可以来调用类的属性，类的方法，实例化对象等，避免硬编码。
