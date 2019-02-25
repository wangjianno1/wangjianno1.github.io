---
title: Python开发者打包发布工具Distutils|setuptools
date: 2019-02-24 12:22:59
tags:
categories: Python
---

# Distutils

Distutils是Python标准库的一部分，其初衷是为开发者提供一种方便的打包方式， 同时为使用者提供方便的安装方式。

例如你创建了一个名为foo的包，包含一个foo.py文件，你想把它打包以便其它人使用。 这时候你需要写一个setup.py文件：

```python
from distutils.core import setup
setup(name='foo',
      version='1.0',
      py_modules=['foo'],
      )
```

然后运行命令:

```bash
python setup.py sdist
```

然后你发现当前目录下出现一个名为dist的文件夹，里面有一个foo-1.0.tar.gz的包。 这个包里有三个文件，foo.py, setup.py, PKG-INFO，前两个文件和我们之前提到的两个文件一样。 PKG-INFO是关于包的一些信息。然后你就可以把foo-1.0.tar.gz给别人安装了。

安装者要使用这个包时，只需要解压这个foo-1.0.tar.gz文件，再运行命令:

```bash
python setup.py install
```

这个包就会被自动安装到系统合适的位置。

其他的一些用法：

```bash
#1 build
python setup.py build
#2 安装
python setup.py install
#3 将程序文件打包
python setup.py sdist
#4 创建windows安装程序
python setup.py bdist --formats=wininst
```

将软件发布到PyPI上：

```bash
#1. 在http://pypi.python.org/pypi上注册一个账号
#2. 模块注册
cd /path/to/my_modulue && python setup.py register
#3. 上传模块
cd /path/to/my_modulue && python setup.py sdist upload
```

# setuptools

setuptools是对distutils的增强, 尤其是引入了包依赖管理。

setuptools可以为Python包创建egg文件，Python与egg文件的关系，相当于java与jar包的关系。

setuptools提供的easy_install脚本可以用来安装egg包。 另外，easy_install可以自动从PyPI上下载相关的包，并完成安装，升级。

easy_install提供了多种安装，升级Python包的方式，例如：

```bash
easy_install SQLObject
easy_install -f http://pythonpaste.org/package_index.html SQLObject
easy_install http://example.com/path/to/MyPackage-1.2.3.tgz
easy_install /my_downloads/OtherPackage-3.2.1-py2.3.egg
easy_install --upgrade PyProtocols
```

后来开发者们觉得setuptools开发的太慢了，fork出了Distribute项目，然后2013年8月，Distribute又合并回setuptools 0.7。

# pip

pip是安装，管理Python包的工具。它是对easy_install的一种增强。 同样可以从PyPI上自动下载，安装包。

在pip中，

（1）安装前所有需要的包都要先下载，所以不会出现安装了一部分，另一部分没安装的情况

（2）所有安装的包会被跟踪，所以你可以知道为什么他们被安装，同时可以卸载

（3）无需使用egg文件。但是pip有Wheel(`*.whl`)格式的包，`*.whl`文件有一点与`*.egg`文件相似，实际上它们都是“伪装”的`*.zip`文件。如果将`*.whl`和`*.egg`文件的扩展名修改为`*.zip`，你就可以使用zip应用程序打开它，并且可以查看它包含的文件和文件夹

使用方式简单：

```bash
pip install package_name     #安装python包
pip uninstall package_name   #卸载python包
pip search package_name      #搜索python包
pip download package_name        #下载python包，并下载package_name依赖的python包
pip freeze > requirements.txt    #将当前系统中所有通过pip安装的python包的名称及版本信息，到处到requirements.txt文件中
pip install -r requirements.txt  #pip根据文件requirements.txt列出的python包及版本，来安装python包
pip list            #查看系统中安装的python包列表
pip install -U pip  #升级pip自身
pip --proxy=http://10.16.20.12:3128 search django  #为pip设置代理
```

另外，可以使用-i选项从指定的PyPI源中下载并安装Python模块。

# 总结

（1）Distutils、setuptools以及Distribute都是Python中打包安装的模块，使用它们需要编写setup.py文件，通过`python setup.py ***`来完成打包、安装以及上传pypi等功能。easy_install以及pip都是一个脚本而已，他们可以从PyPI仓库中下载安装Python模块，它们与原始的`python setup.py install`相比，pip和easy_install将所有依赖的模块也一起安装了。

（2）一般我们在Python项目中，需要引入第三方模块，有两种方式（以yaml模块为例）：一种是使用`python setup.py install`或者`easy_install yaml`或者`pip install yaml`将yaml模块安装到Python缺省的第三方库安装路径lib/site-packages目录中。另一种是使用`python setup.py build`生成模块的构建文件，然后将build目录下生成的模块目录拷贝到项目目录中，这样将项目部署其他机器上时，就不用再去安装环境了。

参考学习资料：
http://blog.yangyubo.com/2012/07/27/python-packaging/
