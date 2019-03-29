---
title: Python Developer
date: 2019-03-22 15:07:45
tags:
categories: 职业拓展
---

# 大数据文件提取

（1）直接遍历

```python
file_obj = open('./data.log')
for line in obj:
    print line
```

（2）readline

```python
file_obj = open('data.txt', 'r')
while True:
    line = file_obj.readline()
    if not line: break
    process(line)
```

（3）生成器

```python
def read_in_chunks(filePath, chunk_size=1024*1024):
    """
    Lazy function (generator) to read a file piece by piece.
    Default chunk size: 1M
    You can set your own chunk size
    """
    file_object = open(filePath)
    while True:
        chunk_data = file_object.read(chunk_size)
        if not chunk_data:
            break
        yield chunk_data

if __name__ == "__main__":
    filePath = './path/filename'
    for chunk in read_in_chunks(filePath):
        process(chunk)
```

# 一个装饰器的简单例子

```python
def use_logging(func):
    def wrapper(*args, **kwargs):
        print "record logging start...."
        print "record logging end......"
        return func(*args, **kwargs)
    return wrapper

@use_logging
def foo(params):
    print params
    print "foo function..."
#上面相当于foo = use_logging(foo)

foo(23)
```

```python
def log1(func):  #不带参数的装饰器
    def wrapper(*args, **kw):
        print 'call %s():' % func.__name__
        return func(*args, **kw)
    return wrapper
 
def log2(text): #带参数的装饰器
    def decorator(func):
        def wrapper(*args, **kw):
            print '%s %s():' % (text, func.__name__)
            return func(*args, **kw)
        return wrapper
    return decorator
```

# 遍历目录

在Python中，遍历一个目录中包含说有的文件，以及只遍历深度小于depth的文件：

```python
import os

def traverse_dir(dirname):
    """遍历目录下的所有文件
    """
    for name in os.listdir(dirname):
        fullname = os.path.join(dirname, name)
        if os.path.isdir(fullname):
            traverse_dir(fullname)
        else:
            print fullname
 
def traverse_dir_with_depth(dirname, current_depth):
    """遍历指定深度的目录下所有文件
    """
    if current_depth >= MAX_DEPTH: return
    for name in os.listdir(dirname):
        fullname = os.path.join(dirname, name)
        if os.path.isdir(fullname):
            traverse_dir_with_depth(fullname, current_depth+1)
        else:
            print fullname
 
MAX_DEPTH = 3
if __name__ == '__main__':
    dirname = os.getcwd()
    print dirname
    print "++++++++++++++++++traverse_dir+++++++++++++++++++"
    traverse_dir(dirname)
    print "++++++++++++traverse_dir_with_depth++++++++++++++"

    traverse_dir_with_depth(dirname, 1)
```

# 链表

定义二叉树的节点，如下：

```python
class Node(object):
    def __init__(self, data, lchild, rchild):
        self.data = data
        self.lchild = lchild
        self.rchild = rchild
```

```python
class BinaryTree(object):
    def __init__(self, root):
        self.root = root

    def add_node(self, node):
        pass

    def del_node(self, node):
        pass
```

定义线性链表的节点，如下：

```python
class Node(object):
    def __init__(self, data, next):
        self.data = data
        self.next = next
```

```python
class LinkedList(object):
    def __init__(self, head):
        self.head = head

    def add_node(self, node):
        self.head.next = node
        pass

    def del_node(self, node):
        pass
```
