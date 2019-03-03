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

# Eclipse工程的JAVA构建路径Build Path

Build Path是指定Java工程所包含的资源属性集合。在一个成熟的Java工程中，不仅仅有自己编写的源代码，还需要引用系统运行库（JRE）、第三方的功能扩展库、工作空间中的其他工程，甚至外部的类文件，所有这些资源都是被这个工程所依赖的，并且只有被引用后，才能够将该工程编译成功，而Build Path就是用来配置和管理对这些资源的引用的。Build Path一般包括：

    JRE运行库
    第三方的功能扩展库（`*.jar`格式文件）
    其他的工程
    其他的源代码或Class文件

`右键点击项目>>Properties>>Java Build Path`即可打开Java构建路径设置窗口，如下：

![](/images/eclipse_1_2.png)

其中，

    Source选项，指定工程自身的源代码文件或配置文件。
    Projects选项，可以添加、编辑、移除当前项目所依赖的项目。
    Libraries选项，可以添加、编辑、移除当前项目所依赖的库文件。
    Order and Export选项，可以为当前项目已经添加进来的库进行排序，也可以设置当前项目导出时，库文件是否也跟随项目导出。

例如引用jar包可以在Libraries选项卡中完成，在Libraries选项卡中我们可以通过点击`Add JARs`来添加Eclipse工作空间中存在的jar包或点击`External JARs`来引入其他文件中的jar包。

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

# Eclipse的Project Facets设定

在项目上右击点击Properties，选择Project Facets选项，会出现Project Facets设定界面如下：

![](/images/eclipse_1_4.png)

Project Facets可理解为项目的特性，主流 IDE (Eclipse IDEA) 都提供了facet的配置。在Eclipse中，新建的Java Project都有一个默认的Java facet，那么Eclipse就只提供JavaSE项目支持，当你需要将该项目升级为Java web项目时，可以为项目添加Dynamic Web Module（就是一个支持Web的facet），这样Eclipse就会将项目结构调整为带有WebContent or WebRoot目录的标准结构且添加 deployment descriptor（web.xml）并调整默认的classpath，同时，如果你要用到javascript，可以对应地添加javascript facet，这样Eclipse就会为项目添加JavaScript相关的支持（构建、校验、提示等等），如果你的项目用到了Hibernate，则可以添加Jpa facet来让Eclipse提供对应的功能支持等等。尤其在Eclipse中创建Maven的web项目时，常会用到上面的配置，给项目添加动态web功能。

# Eclipse Problems试图

点击`Windows->Show View->Problems`会打开Eclipse的Problems窗体，如下：

![](/images/eclipse_1_5.png)

当我们Eclipse中的工程上出现“红叉”，但是又没有明确地提示错误信息时，我们就可以打开Eclipse的Problems窗体，查看详细的错误信息。

# Maven WEB应用部署到本地Tomcat的方式

（1）将webapps中的文件收到copy到Tomcat的webapps目录

（2）使用Eclipse的export功能，导出为WAR包，并将WAR包copy到webapps目录

（3）使用MyEclipse插件自动部署到本地Tomcat中

# Eclipse的Python开发环境配置

（1）本机上安装Python，将Python配置到PATH环境变量中

（2）安装Eclipse，并安装PyDev插件即可

# Eclipse中的一些闲杂知识

（1）点击Windows | Show View | Progress即可打开Eclipse Progress窗格，效果如下：

![](/images/eclipse_1_3.png)

在Eclipse Progress窗格中可以看到Eclipse当前正在处理的各种任务及任务状态。
