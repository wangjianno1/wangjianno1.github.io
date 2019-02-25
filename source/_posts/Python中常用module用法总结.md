---
title: Python中常用module用法总结
date: 2019-02-25 15:52:56
tags:
categories: Python
---

# sys

`sys.argv`用来获取执行Python脚本时，脚本的名称以及脚本参数，它是一个列表。`sys.argv[0]`即表示的是脚本的名称。

`sys.exit(arg)`表示退出当前的程序，arg可以指定一个返回码，或者是一个错误信息。

# sys.path

sys.path模块用来动态地改变Python搜索路径。如果Python中导入的package或module不在环境变量PATH中，那么可以使用sys.path将要导入的package或module加入到PATH环境变量中。

```python
import sys
sys.path.append('引用模块的地址')
```

或者

```python
import sys
sys.path.insert(0, '引用模块的地址')
```

sys.path是个列表，所以在末尾添加目录是很容易的，用sys.path.append就行了。当这个append执行完之后，新目录即时起效，以后的每次import操作都可能会检查这个目录。如同解决方案所示，可以选择用sys.path.insert(0, …)这样新添加的目录会优先于sys.path中的其他目录被import检查。

即使sys.path中存在重复，或者一个不存在的目录被不小心添加进来，也没什么大不了，Python的import语句非常聪明，它会自己应付这类问题。但是，如果每次import时都发生这种错误（比如，重复的不成功搜索，操作系统提示的需要进一步处理的错误），我们会被迫付出一点小小的性能代价。

程序向sys.path添加的目录只会在此程序的生命周期之内有效，其他所有的对sys.path的动态操作也是如此。

# os

`os.getcwd()`用来获取当前的工作目录，返回的是执行命令时所在的目录，而不是脚本本身所在的目录。

# os.path

```python
os.path.abspath(path)  #返回绝对路径
os.path.split(path     #将path分割成目录和文件名二元组返回
os.path.dirname(path)  #返回path的目录。其实就是os.path.split(path)的第一个元素
os.path.basename(path) #返回path最后的文件名
os.path.exists(path)   #如果path存在，返回True；如果path不存在，返回False
os.path.isabs(path)    #如果path是绝对路径，返回True
os.path.isfile(path)   #如果path是一个存在的文件，返回True。否则返回False
os.path.isdir(path)    #如果path是一个存在的目录，则返回True。否则返回False
os.path.getatime(path) #返回path所指向的文件或者目录的最后存取时间
os.path.getmtime(path) #返回path所指向的文件或者目录的最后修改时间 
s.path.join(path1[, path2[, ...]])  #将多个路径组合后返回，第一个绝对路径之前的参数将被忽略。
```

举例来说，

    >>> os.path.join('c:\\', 'csv', 'test.csv')
    'c:\\csv\\test.csv'
    >>> os.path.join('windows\temp', 'c:\\', 'csv', 'test.csv')
    'c:\\csv\\test.csv'
    >>> os.path.join('/home/aa','/home/aa/bb','/home/aa/bb/c')
    '/home/aa/bb/c'

# re

re模块是正则表达式处理的模块。
