---
title: SaltStack Python Client API小结
date: 2019-03-05 00:05:55
tags:
categories: SaltStack
---

# 获取Salt OPTS字典（salt-master端）

即获取salt-master的主配置文件/etc/salt/master的结构化数据，代码示例如下：

```python
import salt.config
master_opts = salt.config.client_config('/etc/salt/master')
print master_opts
```

备注：需要在salt-master所在机器上执行哦。

# 获取Salt OPTS字典（salt-minion端）

即获取salt-minion的主配置文件/etc/salt/minion的结构化数据，代码示例如下：

```python
import salt.config
minion_opts = salt.config.minion_config('/etc/salt/minion')
print  minion_opts
```

备注： 需要在salt-minion所在机器上执行哦。

# salt.client.LocalClient

代码示例如下：

```python
import salt.client
localClient = salt.client.LocalClient()
localClient.cmd('*', 'cmd.run', ['whoami'])
```

备注：需要在salt-master所在机器上执行哦。

# salt.client.Caller

该API类似于salt-minion上salt-call命令，用来在salt-minion端执行一些命令，代码示例如下：

```python
import salt.client
caller = salt.client.Caller()
caller.cmd('test.ping')
```

备注：需要在salt-minion所在机器上执行哦。

# salt.runner.RunnerClient

该API类似于salt-master上salt-run命令，用来在salt-master端执行一些命令，代码示例如下：

```python
import salt.runner
runnerClient = salt.runner.RunnerClient()
runnerClient.cmd('*', 'cmd.run', ['whoami'])
```

# salt.wheel.WheelClient

```python
import salt.config
import salt.wheel
opts = salt.config.master_config('/etc/salt/master')
wheel = salt.wheel.WheelClient(opts)
wheel.cmd('key.finger', ['jerry'])
```

# salt.cloud.CloudClient

待补充

# ssh.client.SSHClient

利用ssh协议来执行一些操作。

# salt-api

详细内容参见[《REST_CHERRYPY用户文档》](https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html)

学习资料参考于：
https://docs.saltstack.com/en/latest/ref/clients/index.html
