---
title: SpringBoot介绍
date: 2019-03-04 00:22:50
tags:
categories: SpringBoot
---

# SpringBoot简介

SpringBoot是这几年微服务概念流行后，Pivotal团队开发的一套快速开发Spring应用的框架。它本身并不提供Spring框架的核心特性以及扩展功能，只是用于快速、敏捷地开发新一代基于Spring框架的应用程序。也就是说，它并不是用来替代Spring的解决方案，而是和Spring框架紧密结合用于提升Spring开发者体验的工具。同时它集成了大量常用的第三方库配置（例如Jackson，JDBC,，Mongo，Redis及Mail等等），SpringBoot应用中这些第三方库几乎可以零配置的开箱即用（out-of-the-box），大部分的SpringBoot应用都只需要非常少量的配置代码，开发者能够更加专注于业务逻辑。从概念上说，SpringBoot需要使用到Spring框架的各个部分，并且对它们进行了大量的默认约定配置。

简单来说，SpringBoot是Spring技术的全家桶哦。也就是说，SpringBoot是为了简化Spring开发而生，主要思想是降低Spring的入门，使得新手可以以最快的速度让程序在Spring框架下跑起来。

另外，SpringBoot与SpringMVC二者没有必然关系，SpringBoot在WEB MVC这块使用的还是SpringMVC框架。

# SpringBoot的特点

SpringBoot主要特点有化繁为简，简化配置；下一代框架，技术迭代趋势；构建微服务入门级框架。

核心思想是“**约定大于配置**”。

# 学习SpringBoot的前置知识

    Maven构建工具的使用
    Spring注解
    RESTful API
    不需要学习SpringMVC

# SpringBoot项目的目录结构

若使用Maven构建工具，SpringBoot项目的目录结构如下：

![](/images/springboot_info_1_1.png)

备注：controller是控制层，用来接收并响应http请求。service是业务逻辑层。dao是数据访问层，主要用来访问数据库等。entity是数据库中ORM的实体层。

# SpringBoot项目中的一些Maven库依赖说明

（1）spring-boot-maven-plugin插件的使用

Maven项目的pom.xml中，添加了org.springframework.boot:spring-boot-maven-plugin插件后，当运行`mvn package`命令进行打包时，会将SpringBoot应用打包成一个可以直接运行的JAR文件，即使用`java -jar`命令就可以直接运行。

一般的Maven项目的打包命令，不会把依赖的jar包也打包进去的，只是会放在jar包的同目录下，能够引用就可以了，但是spring-boot-maven-plugin插件，会将依赖的jar包全部打包进去。比如下面这个jar包的`BOOT-INF/lib`目录下面就包含了所有依赖的jar包：

![](/images/springboot_info_1_2.png)

（2）spring-boot-starter-web

SpringBoot WEB项目的主要框架，其中包括了SpringMVC且内置了tomcat作为了缺省的容器服务器。spring-boot-starter-web是SpringBoot项目的非常核心的依赖。

（3）`spring-boot-starter-*`

SrpingBoot开发框架中，提供了很多以`spring-boot-starter-*`为开头的starter，我们可以在pom.xml中引入这些依赖。举例来说，若我们的SpringBoot应用需要与ElasticSearch交互，那么可以引入spring-boot-starter-data-elasticsearch，这样SpringBoot会帮我们管理相关的依赖库和配置。

# SpringBoot支持的模板引擎

模板引擎，一种很好的解释是，将动态页面静态化。SpringBoot支持的模板引擎非常多，主要有如下几种：

    Thymeleaf（Spring官方的提供的模板引擎）
    freemmarker
    Velocity
    Groovy
    Mustache

备注：SpringBoot项目避免使用JSP哦。
