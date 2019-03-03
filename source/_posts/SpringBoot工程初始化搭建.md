---
title: SpringBoot工程初始化搭建
date: 2019-03-04 00:32:12
tags:
categories: SpringBoot
---

# 官方初始化SpringBoot工程在线网站

使用SpringBoot在线配置网站初始化SpringBoot项目步骤如下：

（1）进入SpringBoot的在线配置网站`http://start.spring.io/`，定制自己的项目服务组件，然后下载Maven包到本地。

（2）在Eclipse中，通过`Import | Maven | Import Existing Maven Projects`，把Download的Maven包导入即可（如果导入的项目无法识别，请右键选择Maven Update）

# 使用Eclipse STS（Spring Tool Suite）插件来初始化SpringBoot工程项目

（1）安装Eclipse STS插件

通过菜单`Help | Eclipse Marketplace`，搜索Spring Tool Suite，如下：

![](/images/springboot_init_1_1.png)

安装STS之后，就可以利用STS插件创建SpringBoot项目工程，如下：

![](/images/springboot_init_1_2.png)

生成的SpringBoot项目的目录结构如下：

![](/images/springboot_init_1_3.png)

进入SpringBootDemoApplication类文件，右键选择`Run As Spring Boot App`即可运行SpringBoot应用了。

# 使用Eclipse创建Maven工程，再引入SpringBoot依赖

使用Eclipse直接创建Maven Project，然后在pom.xml中引入SpringBoot的核心jar包即可。具体参见[《第一个SpringBoot应用》](https://wangjianno1.github.io/2019/03/04/%E7%AC%AC%E4%B8%80%E4%B8%AASpringBoot%E5%BA%94%E7%94%A8/)

学习资料参考于：
http://blog.csdn.net/qq_19260029/article/details/77966154
