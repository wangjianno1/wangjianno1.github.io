---
title: SaltStack目标Target的指定
date: 2019-03-20 16:24:56
tags:
categories: SaltStack
---

# 通过minion-id来全局或正则表达式匹配

```bash
salt '*' test.ping
salt '*-wahaha' test.ping
salt 'wahaha-???' test.ping
salt '[a-z]-wahaha' test.ping
salt -E 'web\d+.(dev|qa|prod).loc' test.ping  #正则表达式时，需要加上-E选项
```

# 通过minion-id来列表匹配

有些我们只想匹配一个指定列表里面的主机并进行远程执行操作，这个时候全局匹配和正则表达式匹配就无法满足了。这时我们可以使用列表匹配，就需要用-L参数。

```bash
salt -L 'node2.51yuki.cn,node3.51yuki.cn' test.ping
```

# 通过Grains信息来确定target

Grains是描述salt-minion本身固有属性的静态数据（是在salt-minion启动的时候收集），如salt-minion端的操作系统版本、内存大小、硬盘及网卡信息等。如果salt-minion端的数据发生改变后，就必须要重启salt-minion，否则就不会生效。

```bash
salt -G 'roles:apache' cmd.run 'sudo systemctl restart httpd' #-G参数指定使用Grains来确定target
```

# 通过Pillar信息来确定target

Pillar数据同Grains相似，不同之处是Pillar数据可以定义为动态的。给特定的salt-minion指定特定的数据，只有指定salt-minion自己能看到自己的数据。

```bash
salt -I 'apache:httpd' cmd.run 'df -h' #-I参数指定使用Pillar来确定target
```

# 通过子网或IP来确定target

```bash
salt -S 10.2.11.228 cmd.run 'df -h'
salt -S 10.2.11.0/24 cmd.run 'df -h'
```

备注：使用-S参数来表明使用子网或IP来确定target

# 组合匹配

举例来说，

```bash
salt -C 'S@10.2.11.0/24 and G@os:CentOS' cmd.run 'df -h'  #-C表示使用组合匹配来确定target，本例是Grains信息和网段的组合来确定target
```

# NodeGroup

在salt-master的主配置文件/etc/salt/master中加入类似如下的分组信息：

    nodegroups:
        group1: 'L@foo.domain.com,bar.domain.com,baz.domain.com or bl*.domain.com'
        group2: 'G@os:Debian and N@group1'
        group3: 'E@test2(1[1-9]|3[1-2]).company.com'

然后使用-N来指定一个nodegroup来作为target，如：

```bash
salt -N group2 cmd.run 'df -h'
```
