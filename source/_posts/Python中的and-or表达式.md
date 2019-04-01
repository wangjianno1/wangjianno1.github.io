---
title: Python中的and|or表达式
date: 2019-02-23 19:42:14
tags:
categories: Python
---

# Python中的and|or布尔逻辑演算说明      

在Python中`0`、`''`、`[]`、`()`、`{}`、`None`在布尔上下文中为假，其它任何东西都为真。默认情况下，布尔上下文中的类实例为真，但是你可以在类中定义特定的方法使得类实例的演算值为假。

`and|or`的布尔逻辑演算的格式为：

```python
xxx and yyy and ccc
xxx or yyy or ccc
```

使用and时，在布尔上下文中从左到右演算表达式的值。如果布尔上下文中的所有值都为真，那么and返回最后一个值。如果布尔上下文中的某个值为假，则and返回第一个假值。

使用or时，在布尔上下文中从左到右演算值，就像and一样。如果有一个值为真，or立刻返回该值。如果所有的值都为假，or返回最后一个假值。

举例如下：

    >>> 'a' and 'b'
    'b'
    >>> '' and 'b'
    ''
    >>> 'a' and 'b' and 'c'
    'c'
    >>> 'a' or 'b'
    'a'
    >>> '' or 'b'
    'b'
    >>> '' or [] or {}
    {}

# Python中的and|or布尔逻辑演算的使用方式

Python中的and|or布尔逻辑演算有两种使用方式：

（1）作为表达式来为变量赋值

举例说明如下，

    >>> var = 'a' and 'b' and 'c'
    >>> print var
    c

（2）作为if/while的表达式

    >>> if 'a' and 'b' and '':
    ...     print 'haha'
    ... else:
    ...     print 'xixi'       
    ... 
    xixi

备注：其实and|or语句在Python中就是一个表达式，这个表达式会计算出来一个值。这个值可以直接用，也可以转换成布尔类型的值。

学习资料参考于：
http://blog.sina.com.cn/s/blog_3fe961ae0100nuzg.html
