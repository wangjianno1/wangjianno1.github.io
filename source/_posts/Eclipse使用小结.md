---
title: Eclipse使用小结
date: 2018-02-05 19:59:02
tags: JAVA工具
categories: JAVA技术栈
---

# Eclipse与MyEclipse

MyEclipse是基于Eclipse的一个开发工具，它整合了一些插件并做了一些自己的开发。 使用MyEclipse开发J2EE程序会更加方便些。但它不是免费的，不过费用不是很高。Eclipse是Java的集成开发环境（IDE），当然Eclipse也可以作为其他开发语言的集成开发环境，如C，C++，PHP，和Ruby等。

Eclipse是开源免费的软件，MyEclipse是收费软件。

# Eclipse的变更历程

从2006年起，Eclipse基金会每年都会安排同步发布。至今，同步发布主要在6月进行，并且会在接下来的9月及2月释放出SR1及SR2版本。具体如下所示：

![](/images/eclipse_1_1.png)

# Eclipse的安装

Eclipse是基于Java的可扩展开发平台，所以安装Eclipse前你需要确保你的电脑已安装JDK。

# Eclipse的透视图

Eclipse的透视图是一个包含一系列视图和内容编辑器的可视容器。

# Eclipse工程的JAVA构建路径（java build path）设置

Java构建路径用于在编译Java项目时找到依赖的类，包括以下几项：

（1）源码包

（2）项目相关的jar包及类文件

（3）项目引用的的类库

在JAVA项目工程右键菜单中选择“Build Path”，即可打开Java构建路径设置窗口，如下：

![](/images/eclipse_1_2.png)

引用jar包可以在Libraries选项卡中完成，在Libraries选项卡中我们可以通过点击`Add JARs`来添加Eclipse工作空间中存在的jar包或点击`External JARs`来引入其他文件中的jar包。
另外，在Libraries选项卡选择`Add Library`按钮，可以修改项目所使用的JRE版本哦。

# Eclipse插件安装

Eclipse插件安装有如下几种方式：

（1）点击Help菜单中的`Eclipse Marketplace`选项来查找插件，并安装。是在线安装。

（2）点击Help菜单上的`Install New Software`菜单项，输入插件的url地址即可安装插件。是在线安装。

（3）手动下载插件到本地并解压，压缩后得到两个文件夹（features和plugins），分别拷贝到%ECLIPSE_HOME%\目录下对应的features和plugins文件夹下，重新启动eclipse即可。

（4）手动下载插件到本地并解压，将解压后的文件直接拷贝到%ECLIPSE_HOME%\目录下dropins文件夹下。

# Eclipse快捷键设置及常用快捷键

打开`Windows -> Preferences -> General -> Keys`，即可设置Eclipse操作快捷键，另外可以使用`Ctrl+Shift+L`快速打开快捷键设置列表。常用的快捷键如下：

	Alt+/            #内容自动补全
	Ctrl+o           #显示类中方法和属性的大纲，能快速定位类的方法和属性
	Ctrl+/           #快速添加注释，能为光标所在行或所选定行快速添加注释或取消注释
	Ctrl+d           #删除当前行
	Ctrl+m           #窗口最大化和还原
	Ctrl+Shift+f     #格式化代码
	Ctrl+Shift+t     #查找工作空间（Workspace）构建路径中的可找到Java类文件
	Ctrl+Alt+UP/DOWN #复制当前行

# eclipse的python开发环境配置

（1）本机上安装Python，将Python配置到PATH环境变量中

（2）安装Eclipse，并安装PyDev插件即可

# eclipse中的一些闲杂知识

（1）点击Windows | Show View | Progress即可打开Eclipse Progress窗格，效果如下：

![](/images/eclipse_1_3.png)

在Eclipse Progress窗格中可以看到Eclipse当前正在处理的各种任务及任务状态。
