---
title: SaltStack Grains组件
date: 2019-03-04 23:45:38
tags:
categories: SaltStack
---

# Grains组件简介

Grains是SaltStack组件中非常重要的组件之一，因为我们在做配置部署的过程中会经常使用它，Grains是SaltStack记录salt-minion的一些静态信息的组件，我们可以简单地理解为Grains里面记录着每台salt-minion的一些常用属性，比如操作系统、主机名、CPU、内存、磁盘、网络信息等，我们可以通过grains.items查看某台salt-minion的所有Grains信息，salt-minion的Grains信息是salt-minion启动的时候采集汇报给salt-master的，在实际应用环境中我们需要根据自己的业务需求去自定义一些Grains。

简单来说，Grains就是在salt-minion端去配置一些元信息，然后在salt-master端可以读取及使用这些信息。

# Grains组件的使用

Grains信息时需要在salt-minion端来配置，既可以在主配置文件/etc/salt/minion中配置，也可以在/etc/salt/grains中配置。下面分别举例来说明：

（1）在/etc/salt/minion中配置Grains信息

我们可以在salt-minion的配置文件/etc/salt/minion中去配置grains，如下：

```
grains:
  roles:
    - webserver
    - memcache
  deployment: datacenter4
  cabinet: 13
  cab_u: 14-15
```

（2）在/etc/salt/grains中配置Grains信息

如果想将Grains信息从/etc/salt/minion中独立出来，那么可以在/etc/salt/grains中配置即可。举例来说：

```
username:
  wahaha
password:
  abc1234
```

需要注意的是，/etc/salt/grains不需要grains这个最上层的key。若/etc/salt/minion和/etc/salt/grains存在相同的Grains Key，则只会生效/etc/salt/minion中的信息。

通过上面的配置，就可以在salt-master端通过`salt 'minion_id' grains.items`来查看指定salt-minion的Grains信息。另外，可以通过Grains定义的属性来识别满足条件的机器，如`salt -G roles:webserver cmd.run 'hostname'`在所有的Grains role为nginx的机器上执行hostname命令。若salt-minion上Grains信息变更了，需要在salt-master执行`salt '*' saltutil.refresh_modules`使之生效。
