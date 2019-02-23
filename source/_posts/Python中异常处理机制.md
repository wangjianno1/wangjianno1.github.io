---
title: Python中异常处理机制
date: 2019-02-24 01:51:25
tags:
categories: Python
---

# 异常代码范例

```python
#!/usr/bin/env python
#coding=gbk

try:
    1/0
except NameError:              #捕获NameError异常
    print "NameError"
except ZeroDivisionError:      #捕获ZeroDivisionError异常
    print "ZeroDivisionError"
else:                          #如果except捕获不到异常，就执行这个分支
    print "That went well"
finally:                       #不管是否有异常，finally语句一定执行
    print "Cleaning up."
```

备注：

（1）在try-except结构中except语句可以写多个

（2）except语句的写法

```python
except (ZeroDivisionError, TypeError, NameError): #一个except语句可以多种类型的异常
except (ZeroDivisionError, TypeError) as ex:      #推荐此种写法
except Exception, ex:
except:
except Exception:
```

# raise抛出异常

（1）`raise Exception`

（2）`raise Exception("User's Error Message")`

# 用户自定义类

用户可以自定义异常类，自定义异常类要继承Exception或其子类
