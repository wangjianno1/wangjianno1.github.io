---
title: Sublime Text 3的安装和使用
date: 2018-07-07 20:34:32
tags:
categories: IDE
---

# Sublime Text3的安装

（1）安装Sublime Text 3

官网`http://www.sublimetext.com/3`下载最新的程序包，然后解压即可使用。

（2）安装Package Control

Sublime Text编辑器支持很多插件，安装创建有两种方式：一种是直接安装，先下载安装包解压缩到Sublime Text的Packages目录，然后在`preferences | Browse Packages`中选择插件即可。另一种是通过Package Control来在线安装插件，我们要使用Package Control就需要先安装Package Control。

打开ST3，点击菜单`View | Show Console`，会在底部出现一个命令输入框，然后将下面的命令拷贝到输入框中，回车，等待，安装成功。命令如下：

```python
import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

安装方法官方指导：https://sublime.wbond.net/installation

（3）安装支持中文编码的插件ConvertToUTF8

ConvertToUTF8是支持GBK，BIG5，EUC-KR，EUC-JP，Shift_JIS等编码的插件。使用`Ctrl+Shift+P`打开PackageControl，然后输入Install Package安装插件窗口，然后输入ConvertToUTF8即可安装。

备注：其他的插件的安装方法也是类似的。

# Sublime Text3中一些常用的快捷键

（1）Ctrl+Shift+P

用来打开PackageControl，然后输入Install Package，既可以选择安装自己需要的插件。

（2）Ctrl+P

根据文件名来快速查找文件。

（3）Ctrl+R

在源文件中查找定位方法。

（4）Ctrl+D

可以多出编译同一个变量等。

（5）Ctrl+F

在源文件中查找指定的关键词。

（6）F12

代码跳转快捷键，非常好用。

（7）F11

全屏沉浸式编码。

# Sublime Text3中一些其他的技巧

（1）语法提示

在View菜单中选择Syntax中为源文件指定语言类型，就会有语法提示和语法高亮效果。当语法提示出备选目标时，移动到目标位置，然后输入Tab键选中。

（2）在Sublime Text中出创建工程Project

- 打开一个新的Sublime Text
- 选择`Project | Add Folder to Project`，将我们的项目文件加加入工程中
- 选择`Project | Save Project As…`，将工程保存下来
- 选择`Project | Close Project`关闭工程，然后重复ABC可以创建其他的工程

之后我们就可以直接打开这些Project来进行工作，选择`Project | Quick Swith Project…`来切换工程Project。

（3）为Sublime Text3设置隐藏文件

选择`Preferences | Settings`，然后在Preferences.subline-settings-User中添加如下的语句：

```
"file_exclude_patterns":
[
    ".*.sw*",
    ".*.un~",
    "*.pyc"
],
```

上述表示过滤了三种特殊的文件格式，这样的文件将不会显示到Sublime Text左边的目录树中。