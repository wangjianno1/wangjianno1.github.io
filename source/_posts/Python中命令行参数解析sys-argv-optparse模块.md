---
title: Python中命令行参数解析sys.argv|optparse模块
date: 2019-02-25 15:39:38
tags:
categories: Python
---
# sys.argv

在Python脚本中使用sys.argv可以获取到一个列表，其中

    sys.argv[0]是脚本的名称
    sys.argv[n]是执行脚本时，命令行传入的第n个参数

代码举例如下：

```python
import sys

if __name__ == "__main__":
    print sys.argv[:]
    print sys.argv[0]
    print sys.argv[1]
    print sys.argv[2]
```

# optparse模块

使用范例代码如下，

```python
#!/usr/bin/python

from optparse import OptionParser

usage = "usage: %prog [options] arg1 arg2"  

parser = OptionParser(usage=usage)    #创建OptionParser对象

parser.add_option("-v", "--verbose",  #add_option增加选项
                  action="store_true", dest="verbose", default=True,
                  help="make lots of noise [default]")
parser.add_option("-q", "--quiet", action="store_false",
                  help="be vewwy quiet (I'm hunting wabbits)")
parser.add_option("-f", "--filename", dest="filename",
                  action="store", help="write output to FILE")
parser.add_option("-m", "--mode", dest="mode",
                  action="store", help="interaction mode")

(options, args) = parser.parse_args()  #解析选项

print options.filename   #获取命令行中filename参数
print options.mode       #获取命令行中mode参数
```

其中options中选项存储了选项参数，args存储其他的位置参数
