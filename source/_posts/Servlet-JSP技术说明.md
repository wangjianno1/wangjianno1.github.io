---
title: Servlet/JSP技术说明
date: 2019-03-04 18:20:45
tags:
categories: SSM/SSH
---

# Servlet简介

Java Servlet是运行在Web服务器或应用服务器上的程序，它是作为来自Web浏览器或其他HTTP客户端的请求和HTTP服务器上的数据库或应用程序之间的中间层。

使用Servlet，可以收集来自网页表单的用户输入，呈现来自数据库或者其他源的记录，还可以动态创建网页。Java Servlet通常情况下与使用CGI（Common Gateway Interface，公共网关接口）实现的程序可以达到异曲同工的效果。

Servlet可以使用javax.servlet和 javax.servlet.http包创建，它是Java企业版的标准组成部分，Java企业版是支持大型开发项目的Java类库的扩展版本。

# Servlet架构

Servlet的架构如下所示：

![](/images/java_servlet_1_1.png)

备注：这里的HTTP Server可以是Tomcat/Jetty等。

# Java Servlet HelloWorld程序

（1）编写HelloWorld Servlet程序

```java
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
 
public class HelloWorld extends HttpServlet {
    private String message;

    public void init() throws ServletException {
        message = "Hello World";
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>" + message + "</h1>");
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("do nothing...");
    }
  
    public void destroy() {
        // 什么也不做
    }
}
```

（2）在tomcat中配置做Servlet的映射

按如下内容修改tomcat web.xml配置：

```xml
<web-app>      
    <servlet>
        <servlet-name>HelloWorld</servlet-name>
        <servlet-class>HelloWorld</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>HelloWorld</servlet-name>
        <url-pattern>/HelloWorld</url-pattern>
    </servlet-mapping>
</web-app>
```

（3）启动tomcat并测试

在浏览器中输入`http://127.0.0.1/HelloWorld`即可访问。如下：

![](/images/java_servlet_1_2.png)

# Servlet的生命周期

![](/images/java_servlet_1_3.png)

# JAVA Servlet WEB应用程序部署规范

根据J2EE Servlet规范，WEB应用程序有特定的目录结构，将Servlet应用程序部署到Servlet容器（Tomcat/Jetty等）时必须按照这样的目录结构部署，具体结构如下：

![](/images/java_servlet_1_4.png)

当我们使用Eclipse等IDE工具创建WEB工程时，IDE会自动在webapp目录下按照这样的目录结构给开发者组织WEB应用。

需要注意的是，JAVA Web应用部署到容器后，/WEB-INF/classes/和/WEB-INF/lib/目录都属于CLASSPATH中一部分，JAVA Web应用可以直接使用这些目录中jar包中的类。

# 其他闲杂知识

（1）Listener

监听器Listener，它是实现了javax.servlet.ServletContextListener接口的服务器端程序，它是随web应用的启动而启动，只初始化一次，随web应用的停止而销毁。主要作用是做一些初始化的内容添加工作、设置一些基本的内容、比如一些参数或者是一些固定的对象等等。在Servlet被Servlet容器初始化之前，可以向Servlet容器注册一些Listener来执行一些前置的工作逻辑，该Listener需要继承自javax.servlet.ServletContextListener。比如Spring 框架的监听器ContextLoaderListener会在服务器启动的时候实例化我们配置的bean对象、hibernate的session的监听器会监听session的活动和生命周期，负责创建，关闭session等活动。

（2）Filter

Filter是一个可以复用的代码片段，可以用来转换HTTP请求、响应和头信息。Filter不像Servlet，它不能产生一个接收请求或者响应请求，它只是修改对某一资源的请求，或者修改对某一资源的响应。Servlet/JSP规范中的过滤器Filter是实现了javax.servlet.Filter接口的服务器端程序，主要的用途是过滤字符编码、做一些业务逻辑判断等。
