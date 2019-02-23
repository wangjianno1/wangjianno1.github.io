---
title: Python中的module|package概念以及包路径查找机制
date: 2019-02-24 01:34:53
tags:
categories: Python
---

# Python中的module和package

Python的程序由包（package）、模块（module）、类以及函数组成。包是由一系列模块组成的集合。模块是处理某一类问题的函数和类的集合。如下图所示：

![](/images/python_pkg_1_1.png)

Python中的module和package是Python模块编程的体现，以及实现命名空间的隔离。

（1）Python中一个module就是一个`*.py`文件，模块名称就是文件的名称。

（2）Python中的package在文件系统中表现出来的就是一个目录，这个目录中可以包含众多的module以及其他的子package。而且这个目录中一定要有一个`__init__.py`文件，这个文件的存在才意味着该目录是Python中的一个package。

备注：`__init__.py`可以是空文件，也可以有一些初始化的代码。

# import导入package或module的过程

当执行`import package_name.module_name`时，会执行package_name目录下的`__init__.py`以及module_name文件。

# import导入函数|类|module|package

```python
import module_name     #module_name.foo()表示调用module_name中foo函数
import package_name    #如果package_name中__init__.py文件中导入了具体模块module_name,那么可以用package_name.module_name来使用module_name中的功能，否则是不行的
import package_name.module_name          #package_name.module_name.foo()  表示使用module_name中的foo函数
from package_name import module_name     #module_name.foo()表示使用module_name的foo函数
from package_name.module_name import foo #直接使用foo()就可以啦
```

备注：`import module_name.foo`是非法的。

# module和package中的一些特殊的变量

（1）module中的`__main__`变量

当使用import导入module时，该变量就是模块名或文件名（不带后缀哦）；当直接执行module的.py文件时，`__main__`变量就是`__main__`。

（2）package中的`__init__`变量

`__init__`变量是一个元组，我们可以给这个变量赋值，如`__all__ = ['Module1', 'Module2', 'Package2']`，当我们使用`from package_name import *`会执行`__init__.py`，这时就会导入`__all__`元组中定义的module或子package啦

# Python中包的查找机制

（1）绝对路径引入

当我们在Python代码中使用`from package_name import module`等形式来以绝对路径的方式来导入其他模块或包时，Python的查找顺序为：

    查看python的内置模块或包中是否存在
    根据sys.path这个列表中的路径按顺序依次查找

备注：当我们使用`python /home/work/test.py`或`cd home && python work/test.py`，都会将test.py文件所在的路径/home/work加入到sys.path列表中，且该路径在列表的最前面。所以在Python中，查找当前目录是早于Python中其他默认的第三方包路径。

![](/images/python_pkg_1_2.png)

（2）相对路径引入

所谓相对路径的引入，是针对一个包内部模块间相互依赖的导入方法。例如：

```text
sound/                #Top-level package
    __init__.py       #Initialize the sound package
    formats/          #Subpackage for file format conversions
        __init__.py
        wavread.py
        wavwrite.py
        aiffread.py
        aiffwrite.py
        auread.py
        auwrite.py
        ...
    effects/          #Subpackage for sound effects
        __init__.py
        echo.py
        surround.py
        reverse.py
        ...
    filters/          #Subpackage for filters
        __init__.py
        equalizer.py
        vocoder.py
        karaoke.py
        ...
```

在surround.py中通过`from . import echo`来引入echo模块；

在surround.py中通过`from .. import formats`来引入formats子包；

在surround.py中通过`from ..filters import equalizer`来引入filters包的equalizer模块；

像如上通过`./../...`等以相对路径的方式引入包内的其他模块或子包，是直接在包里面去查找模块或包的，就不是按照绝对路径的那种方式去查找。

[相对地址引入包参考](https://docs.python.org/2/tutorial/modules.html#intra-package-references)
