---
title: Jetty技术调研
date: 2018-02-05 16:07:04
tags: JAVA工具
categories: JAVA技术栈
---

# Jetty简介

Jetty是一个纯粹的基于Java的网页服务器和Java Servlet容器。从功能上看，Jetty和Tomcat是差不多的，都提供Http Server和Servlet容器功能。

# Jetty的目录结构

![](/images/jetty_1_1.png)


# Jetty的安装和使用

前提声明：

	系统：Red Hat Enterprise Linux Server release 6.8 (Santiago)
	JAVA：1.8.0
	jetty：jetty-9.4.8.v20171121

Jetty安装的步骤如下：

（1）配置JAVA环境

（2）官网上现在jetty tarball，并解压即可。不需要编译安装哦。

（3）启动jetty

方式一（前台启动）：`cd ${JETTY_HOME} && java -jar start.jar`
方式二（后台启动）：`cd ${JETTY_HOME} && ./bin/jetty.sh start`

备注：我们可以将自己开发的war包部署到${JETTY_HOME}/webapps目录下，jetty会自动加载war包，然后在浏览器中输入`http://127.0.0.1/war_name/xxx`即可访问。

# Jetty的一些常见配置修改

（1）修改默认http端口

修改${JETTY_HOME}/etc/jetty-http.xml配置文件中如下配置：

	<Set name="port"><Property name="jetty.http.port" deprecated="jetty.port" default="8086" /></Set>


学习资料参考于：
http://www.cnblogs.com/yiwangzhibujian/p/5832597.html
