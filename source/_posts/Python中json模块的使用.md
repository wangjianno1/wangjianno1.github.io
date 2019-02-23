---
title: Python中json模块的使用
date: 2019-02-24 02:06:15
tags:
categories: Python
---

# Python中json的使用

（1）将Python数据类型转换json对象-encode

```python
json.dump()
json.dumps()
json.JSONEncoder()
```

其中，Python的数据类型转成json数据类型的映射表为：

![](/images/python_json_1_1.png)

（2）将json对象转换成python数据类型-decode

```python
json.load()
json.loads()
json.JSONDecoder()
```

其中，json的数据类型转成Python的数据类型的映射表为：

![](/images/python_json_1_2.png)

# dump/load与dumps/loads

json模块提供了一种很简单的方式来编码和解码JSON数据，其中两个主要的函数是`json.dumps()`和`json.loads()`，这也是我们经常使用的json模块中的函数。举例来说：

```python
import json

data = {
    'name' : 'ACME',
    'shares' : 100,
    'price' : 542.23
}

json_str = json.dumps(data)  #将python对象转换成json对象
data = json.loads(json_str)  #将json对象转换成python对象
```

如果你要处理的是文件而不是字符串，你可以使用`json.dump()`和`json.load()`来编码和解码JSON数据。举例来说：

```python
# Writing JSON data
with open('data.json', 'w') as f:
    json.dump(data, f)   #将python对象装换成json对象并持久化到文件中

# Reading data back
with open('data.json', 'r') as f:
    data = json.load(f)  #将文件中的json对象转换成python对象
```
