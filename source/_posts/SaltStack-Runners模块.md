---
title: SaltStack Runners模块
date: 2019-03-04 23:55:57
tags:
categories: SaltStack
---

# SaltStack Runners模块简介

SaltStack Runners的写法和SaltStack的Execution Module的差不多。但是需要注意的是，Execution Module是在salt-minion上执行命令或脚本。而SaltStack Runners模块是在salt-master本地执行命令或脚本。

# SaltStack Runners模块的使用

（1）首先配置Runners模块的脚本存放路径

修改/etc/salt/master中runner_dirs的配置，即表示修改了Runners模块的脚本存放路径。

（2）编写Runners模块的自定义脚本

在runner_dirs指定的目录中编写Python脚本，举例来说：

```python
#root@salt-master:~# cat /srv/salt/_runners/lsdir.py
import re
import salt.client

def lsdir(directory):
    match = re.findall(r'^(/)',directory)
    if not match:
        directory = "/%s" % directory
    client = salt.client.LocalClient(__opts__['conf_file'])
    ret = client.cmd('*', 'cmd.run', ['/bin/ls /home'], timeout=1)
    for key,value in ret.items():
        value_list = value.split('\n')
        print "\033[31m%s\033[0m" % key
        for value in value_list:
            print "\033[32m%s\033[0m" % value
```

（3）使用salt-run命令执行

执行命令`salt-run lsdir.lsdir home`即可。其中lsdir.lsdir是Python模块名和函数名的拼接。
