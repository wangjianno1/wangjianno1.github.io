---
title: Python中yaml模块的使用
date: 2019-02-24 02:12:22
tags:
categories: Python
---

# Python中yaml的模块的使用

（1）安装yaml模块到机器环境中

（2）编写yaml配置文件test.yaml

```yaml
name: Tom Smith
age: 37
spouse:
    name: Jane Smith
    age: 25
children:
  - name: Jimmy Smith
    age: 15
  - name1: Jenny Smith
    age1: 12
```

（3）编写解析yaml文件的Python程序test.py

```python
import sys
sys.path.insert(0, '/home/wahaha/coding/python')

import yaml
f = open('test.yaml')
x = yaml.load(f)  

print type(x)
print x
```

程序输出的结果为（yaml.load产出的是dict哦）：

    <type 'dict'>
    {'age': 37, 'spouse': {'age': 25, 'name': 'Jane Smith'}, 'name': 'Tom Smith', 'children': [{'age': 15, 'name': 'Jimmy Smith'}, {'age1': 12, 'name1': 'Jenny Smith'}]}


参考资料来源于：
[yaml文档编写格式](http://www.mutouxiaogui.cn/blog/?p=357)
