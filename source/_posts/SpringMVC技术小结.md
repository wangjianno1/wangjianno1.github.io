---
title: SpringMVC技术小结
date: 2019-03-04 18:49:27
tags:
categories: SSM/SSH
---

# SpringMVC简介

SpringMVC是Spring Framework的一个模块，它是一个WEB MVC框架，它和Struts/Struts2解决的问题是一致的，可以直接代替Struts/Struts2，不过Struts作为一个非常成熟的MVC，功能上感觉还是比Spring强一点，不过SpringMVC已经足够用了。SpringMVC解决的问题有URL路由、Session、模板引擎、静态Web资源等等。

SpringMVC主要由DispatcherServlet、处理器映射、处理器(控制器)、视图解析器、视图组成，其核心组件为DispatcherServlet。SpringMVC实现了MVC模式，包括怎样与Web容器环境集成，Web请求的拦截、分发、处理和ModelAndView数据的返回，以及如何集成各种UI视图展现和数据表示。

本质上来说，SpringMVC是基于Servlet规范的MVC框架的实现，那么SpringMVC在Tomcat/JSP来看，其实就是一个Servlet。SpringMVC是Servlet的实现，在SpringMVC就是DispatchServlet，所有的http请求都是映射到这个Servlet上，请求进入到这个Servlet中之后，就算进入到了框架之中了，由这个Servlet来统一的分配http请求到各个Controller。

# SpringMVC整体架构

![](/images/java_springmvc_1_1.png)

其请求详细过程如下：

（1）发起请求到前端控制器(DispatcherServlet)

（2）前端控制器请求HandlerMapping查找Handler，可以根据xml配置、注解进行查找

（3）处理器映射器HandlerMapping向前端控制器返回Handler

（4）前端控制器调用处理器适配器去执行Handler

（5）处理器适配器去执行Handler

（6）Handler执行完成给适配器返回ModelAndView

（7）处理器适配器向前端控制器返回ModelAndView(是springmvc框架的一个底层对象，包括Model和View)

（8）前端控制器请求视图解析器去进行视图解析，根据逻辑视图名称解析真正的视图(jsp...)

（9）视图解析器向前端控制器返回View

（10）前端控制器进行视图渲染，视图渲染就是将模型数据(在ModelAndView对象中)填充到request域中

（11）前端控制器向用户响应结果

# SpringMVC与Spring创建的Bean容器

![](/images/java_springmvc_1_2.png)

在SpringMVC+Spring的WEB应用中，SpringMVC DispatcherServlet会创建一个Bean容器，即Servlet WebapplicationContext。Spring也会创建一个Bean容器，即Root WebApplicationContext。且Servlet WebapplicationContext是Root WebApplicationContext的子容器，它们管理的Bean不同，Servlet WebapplicationContext管理和WEB相关的Bean，如Controller、ViewResolver等，Root WebApplicationContext则管理一些公共基础的Bean，如Services、Repositories以及DAO等等。

备注：在tomcat/jetty容器启动时，是先初始化Spring容器，再初始化SpringMVC容器哦。

# 使用了SpringMVC框架的项目的web.xml

使用SpringMVC框架的项目，首先要做的将DispatcherServlet配置到WEB引用的web.xml，如下所示：

```xml
<!-- 配置DispatchcerServlet -->
<servlet>
    <servlet-name>springDispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!-- 配置Spring mvc下的配置文件的位置和名称 -->
    <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>springDispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```
