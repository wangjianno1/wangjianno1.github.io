---
title: Python中DEBUG调试模块PDB使用
date: 2019-02-26 16:30:57
tags:
categories: Python
---

# pdb简介

pdb是Python自带的一个包，为Python程序提供了一种交互的源代码调试功能，主要特性包括设置断点、单步调试、进入函数调试、查看当前代码、查看栈片段、动态改变变量的值等。

pdb提供了一些常用的调试命令，见下表：

命令 | 解释
---- | -----
break 或 b 设置断点 | 设置断点
continue 或 c | 继续执行程序
list 或 l | 查看当前行的代码段
step 或 s | 进入函数
return 或 r | 执行代码直到从当前函数返回
exit 或 q | 中止并退出
next 或 n | 执行下一行
pp | 打印变量的值
help | 帮助

# pdb使用方法

使用pdb DEBUG模式启动Python程序有两种方法：

（1）在Python程序中加入`pdb.set_trace()`代码，然后直接执行Python程序就可以进入Python的DEBUG模式。举例如下：

```python
import pdb

a = "aaa"
pdb.set_trace()

b = "bbb"
c = "ccc"
final = a + b + c
print final
```

（2）使用`python -m pdb *.py`的方式执行Python程序，也可以进入Python的DEBUG模式。

学习资料参考于：
https://www.ibm.com/developerworks/cn/linux/l-cn-pythondebugger/
