---
title: Python应用中的一些小技巧
date: 2018-02-02 18:29:33
tags: Python实践
categories: Python
---

# 定位Python程序的性能

```bash
python -m cProfile xxx.py
python -m profile xxx.py
```

备注：建议使用cProfile就好了，cProfile会更高效，因为它是用C开发的。

# 使用pdb调试Python程序

```bash
python -m pdb xxx.py
```

详细内容参见[《Python中DEBUG调试模块PDB使用》](https://wangjianno1.github.io/2019/02/26/Python%E4%B8%ADDEBUG%E8%B0%83%E8%AF%95%E6%A8%A1%E5%9D%97PDB%E4%BD%BF%E7%94%A8/)

# 使用Python快速启动HTTP服务器

```bash
python -m SimpleHTTPServer
```

# 使用Python快速搭建FTP服务器

```bash
pip install pyftpdlib
python -m pyftpdlib  #启动一个可以匿名登录的FTP服务器
python -m pyftpdlib -u wahaha -P test  #启动一个需要使用账号wahaha，密码test登录的FTP服务器 
```

# 使用Python格式化输出json数据

```bash
cat data.json | python -m json.tool
python -m json.tool data.json
```

# 查看Python解释器的目录

```bash
whereis python
which python
```

# 查看Python的安装目录

```python
import sys
print sys.prefix
```

# 快速启动一个Python进程

```bash
echo 'while True: pass' | python &
```
