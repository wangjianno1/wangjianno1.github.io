---
title: Python中单元测试框架doctest|unittest
date: 2019-02-24 11:32:59
tags:
categories: Python
---

# doctest模块

通过在文件字符串中加入一些程序执行的例子，那么在执行Python脚本时，doctest测试框架会自动地去验证这些例子，如果有例子不通过，那么就会提示测试失败。具体使用例子如下：

```python
#my_math.py文件
#!/usr/bin/python
def my_square(x):
    ''' 
    square function
    >>> my_square(2)
    4
    >>> my_square(4)
    15
    '''
    return x*x
```

```python
#test.py文件
#!/usr/bin/python
if __name__=="__main__":
    import doctest, my_math
    doctest.testmod(my_math)
```

如果文档字符串中的例子通过，那么doctest测试通过。如果验证到文档字符串中有例子不通过，那么doctest测试框架会明显的提示失败的原因和位置。

# unittest模块

unitest是基于Java的测试框架Junit，它比doctest测试框架更灵活和强大。还以测试my_math模块中的my_square为例，看看使用unittest如何测试：

```python
#!/usr/bin/python

import unittest, my_math

class MyMathTestCase(unittest.TestCase):
    def testSquare(self):
        ret = my_math.my_square(2)
        self.failUnless(ret == 4, "test failed.")

if __name__ == '__main__':
    unittest.main()
```

备注：首先定义一个unittest.TestCase子类，其中定义一些以test开头的方法，方法名最好和要测试的方法名一样，比如`testsqrt()`，表示测试的是sqrt方法。

在上面的例子，执行`unittest.main()`方法时，unittest框架会实例化所有unittest.TestCase的子类，并且运行所有以test开头命名的方法。例子中使用的断言语句是failUnless，其实unittest框架中有很多的断言函数。

在测试类MyMathTestCase中，可以覆写父类中的`setUp()`和`tearDown()`函数，`setUp()`用于在测试用例执行前的初始化工作，与之相应的`tearDown()`用于测试用例执行后的善后工作。

# Python源代码检查工具

PyChecker和PyLint是两个可以检查python源代码的工具。它们都需要单独的安装。且有两种方式来使用它们，一种是将它们作为命令行工具来使用；一种是将它们嵌入到代码中进行检查。

# Python程序性能检测工具

Python标准库中有一个叫做profile的分析模块，可以在检查Python程序的执行性能。

备注：单元测试是让程序可以工作，源代码检查可以让程序更好，最后，分析工具可以让程序更快。
