---
title: Python中virtualenv和virtualenvwrapper工具介绍和使用
date: 2018-10-10 18:38:58
tags:
categories: Python
---

# virtualenv工具介绍

在我们日常Python项目开发中，比如除了基于Flask的项目外，还会有其他项目用到Python。当项目越来越多时就会面对使用不同版本的Python的问题，或者至少会遇到使用不同版本的Python库的问题。摆在你面前的是：库常常不能向后兼容，更不幸的是任何成熟的应用都不是零依赖。如果两个项目依赖出现冲突，就会比较麻烦。

而virtualenv就可以用来解决Python多版本环境的问题。它的基本原理是为每个项目安装一套Python，多套Python并存。但它不是真正地安装多套独立的Python拷贝，而是使用了一种巧妙的方法让不同的项目处于各自独立的环境中。
 
# virtualenv的使用

（1）virtualenv的安装

执行`pip install virtualenv`或`easy_install virtualenv`或`apt-get install python-virtualenv`（Ubuntu系统中）命令即可安装virtualenv。

（2）virtualenv的使用

执行`virtualenv my-env`创建一个名称为my-env的Python虚拟环境。

执行`source my-env/bin/activate`命令激活my-env Python虚拟环境，并进入Python虚拟环境，然后可以干各种操作。注意这时终端提示符有变化，但是可以切换到任何目录中执行，而不局限于在my-env目录中。

执行`deactivate`命令，即可退出my-env Python虚拟环境，需要注意的是，virtualenv虚拟环境退出后，在虚拟环境中启动的服务进程，并不会退出哦。

备注：

我们在创建Python虚拟环境时，可以指定虚拟环境要使用的Python版本，命令如下（使用-p参数指明Python解释器的路径就好了）：

```bash
virtualenv -p /usr/bin/python2.7 ENV2.7  #创建python2.7的虚拟环境
virtualenv -p /usr/bin/python3.4 ENV3.4  #创建python3.4的虚拟环境
```

# virtualenvwrapper工具介绍

virtualenvwrapper是virtualenv的扩展管理包，用于更方便管理虚拟环境，它可以做：

（1）将所有虚拟环境整合在一个目录下

（2）管理（新增，删除，复制）虚拟环境

（3）切换虚拟环境

与virtualenv相比，virtualenvwrapper将虚拟环境创建出现的文件统一管理，对用户更友好。而且virtualenvwrapper提供了更多好用的工具，如workon。在virtualenv中，我们需要切换到虚拟环境的目录并执行`source env-name/bin/activate`命令，才能进入虚拟环境。而使用virtualenvwrapper，我们可以在任意目录下执行`workon env-name`就可以激活或进入到虚拟环境中。

# virtualenvwrapper的安装配置和使用

（1）执行`pip install virtualenv virtualenvwrapper`命令安装virtualenv和virtualenvwrapper工具。

（2）配置virtualenvwrapper

在`~/.bashrc`中添加下列内容：

```bash
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

接着执行`source ~/.bashrc`命令使之生效。最终利用virtualenvwrapper创建的虚拟环境相关的文件目录都放入到WORKON_HOME这个环境变量所指定的目录中。

（3）virtualenvwrapper的常用工具命令

```bash
mkvirtualenv [环境名] #创建基本环境，也可以通过-p /usr/bin/python3.4等参数来指定虚拟环境中python版本
rmvirtualenv [环境名] #删除环境
workon [环境名]       #激活环境
deactivate           #退出环境
workon 或者 lsvirtualenv -b  #列出所有环境
```
