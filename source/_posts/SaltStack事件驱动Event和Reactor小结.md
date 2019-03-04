---
title: SaltStack事件驱动Event和Reactor小结
date: 2019-03-05 00:00:15
tags:
categories: SaltStack
---

# Event和Reactor

SaltStack的内部组件之间的通信是通过发送和监听事件实现的。在SaltStack中，几乎所有的变动都会产生事件，如salt-minion连接salt-master、密钥被接受或拒绝、发送作业、从minion返回作业结果、心跳包发送，甚至是salt命令行接口使用事件系统都会产生事件。

Event对SaltStack里面的每一个事件进行了记录，比Job更加底层，Event可以记录Minion连接Master、Key认证、job等。Reactor是基于每个Event事件做相应的操作，Reactor监听Event，触发一些States操作。

在Salt-Master上执行命令`salt-run state.event pretty=True`，然后可以看到Salt-Master上产生的所有Event事件。例如我们重启某台salt-minion的进程，然后通过`salt-run state.event pretty=True`命令可以看到salt-master上产生了如下的一些Event：

![](/images/saltstack_1_6.png)

其中每个Event包括tag和data两部分，如salt/auth表示事件Event的tag，花括号{}中的内容是事件Event的data。

# Event和Reactor的使用

Reactor模块用来匹配指定规则的Salt Event，然后触发相应的动作。Reactor的具体使用如下：

（1）首先Reactor的主要配置文件在/etc/salt/master.d/reactor.conf中，举例来说：

```
reactor:
  - 'salt/auth':
    - /opt/salt/reactor/test1.sls
  - 'salt/minion/*/start':
    - /opt/salt/reactor/test2.sls
```

上述表示，若匹配到salt/auth的Event，就执行/opt/salt/reactor/test1.sls中定义的动作。若匹配到salt-minion重启的Event（`salt/minion/*/start`），则执行`/opt/salt/reactor/test2.sls`中定义的动作。

（2）定义具体匹配Event后要执行的动作，也即上面的/opt/salt/reactor/test1.sls和/opt/salt/reactor/test1.sls。

# 常见的SaltStack事件Event

（1）`salt/auth`

salt-minion向salt-master发送了公钥，并请求salt-master进行认证。

（2）`salt/minion/*/start`

某台salt-minion启动了，如salt/minion/6000006049/start代表了minion id为6000006049的salt-minion启动了。
