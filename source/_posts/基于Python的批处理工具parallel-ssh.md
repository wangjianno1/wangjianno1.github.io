---
title: 基于Python的批处理工具parallel-ssh
date: 2018-02-03 17:20:28
tags: Python实践
categories: Python
---

# parallel-ssh

pssh是一个Python编写可以在多台服务器上执行命令的工具，同时支持拷贝文件，是同类工具中很出色的。为方便操作，使用前请在各个服务器上配置好密钥认证访问。parallel-ssh有pssh/pscp/pslurp/pnuke/prsync几个命令行工具。

项目地址: [parallel-ssh](https://code.google.com/p/parallel-ssh/)

# parallel-ssh安装

```bash
wget http://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz
tar zxvf pssh-2.3.1.tar.gz
cd pssh-2.3.1/
python setup.py install
```

# 命令使用举例

（1）pssh

```bash
#其中-h host.txt是从文件中读取机器列表，-i输出远程机器执行命令的输出结果
pssh -h host.txt -i "pwd"

#直接在命令行参数中指明目标机器
pssh -H 10.16.20.22 -H 10.16.20.30 -i 'pwd'
```

（2）pscp

pscp传输文件到多个hosts，类似scp。命令使用举例如下：

```bash
#将本地当前目录中的foo.txt文件，远程拷贝到目标主机的/home/work/目录下
pscp -h hosts.txt foo.txt /home/work/foo.txt
```

（3）pslurp

pslurp从多台远程机器拷贝文件到本地。

（4）pnuke

pnuke并行在远程主机杀进程 。命令使用举例如下：

```bash
pnuke -h hosts.txt -l irb2 java
```

（5）prsync

prsync使用rsync协议从本地计算机同步到远程主机 。命令使用举例如下：

```bash
prsync -r -h hosts.txt -l irb2 foo /home/irb2/foo
```

学习资料参考于：
http://kumu-linux.github.io/blog/2013/08/12/pssh/
