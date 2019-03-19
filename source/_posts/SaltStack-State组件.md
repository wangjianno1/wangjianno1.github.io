---
title: SaltStack State组件
date: 2019-03-04 23:38:06
tags:
categories: SaltStack
---

# SaltStack State机制简介

state，中文为状态，可以简单理解为，我们希望salt-minion要达到什么样的状态，比如说装什么软件、配置成什么样、服务是该运行还是该停止等等。我们定义了state，然后让所有的salt-minion去执行，则我们的salt-minion就会成为我们在state中定义的那个状态了。

简单来说，salt-master指导salt-minion干活，无外乎两种方式。一种是通过远程执行命令，另外一种方式就是saltstack state了。saltstack state可以理解为按照一定的逻辑把命令组织成脚本，就像Linux里面的shell脚本一样。显而易见，有组织有纪律的state干起活来肯定比远程执行一个命令要高效得多。

# `*.sls`文件

`*.sls`是saltstack State的核心，我们将状态规则定义到sls文件中，然后让salt-minion去执行才能达到这个效果。举一个sls文件例子如下：

```
install_network_packages:
  pkg.installed:
    - pkgs:
      - rsync
      - lftp
      - curl
```

上面的sls就表示，需要salt-minion去安装rsysc/lftp/curl这三个包。

Salt States文件（`*.sls`文件）的存放位置默认在salt-master的/srv/salt目录下，当然可以通过修改salt-master的主配置文件/etc/salt/master来修改这个位置，配置如下：

```
file_roots:
  base:
    - /opt/salt/sls
```

当然saltstack State也支持多环境的配置，

```
file_roots:
  base:
    - /srv/salt/base
  dev:
    - /srv/salt/dev
  test:
    - /srv/salt/test
  prod:
    - /srv/salt/prod
```

# SaltStack State的使用

SaltStack State有两种方式执行，一种是手动执行state方式；另一种是highstate的方式。详细如下：

（1）手动执行state的方式

例如我们编写一个/srv/salt/nettools.sls，内容如下：

```
install_network_packages:
  pkg.installed:
    - pkgs:
      - rsync
      - lftp
      - curl
```

然后执行`salt 'minion2' state.apply nettools`或`salt 'minion2' state.sls nettools`将上述nettools.sls生效到minion2这台机器上。

（2）highstate的方式

其实是使用top.sls作为SaltStack state的入口文件，top.sls文件是SaltState的默认sls文件。下面以一个例子来说明，新建top.sls文件，内容如下：

```
base:
  '*':
    - webserver
```

然后编写top.sls中引用的webserver.sls文件，内容如下：

```
httpd:
   pkg:
     - installed
   service:
     - running
     - require:
       - pkg: httpd
```

然后执行`salt '*' state.highstate`即可。
