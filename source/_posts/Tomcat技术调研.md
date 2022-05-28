---
title: Tomcat技术调研
date: 2018-02-05 15:54:22
tags: JAVA工具
categories: JAVA技术栈
---

# Tomcat简介

Java servlet容器。Tomcat的主要的目录结构如下：

    bin，存放tomcat的启停脚本等
    conf，Tomcat的全局配置文件
    lib，Tomcat依赖的jar文件
    webapps，WEB应用的部署目录
    logs，Tomcat输出日志的目录

# Tomcat一些配置文件

（1）server.xml

Tomcat的主配置文件，包含service、connectors、engine、realm、valve、hosts等组件。比如Tomcat监听的http端口就是该文件中配置的。

（2）web.xml

遵循Servlet规范标准的配置文件，用于配置Servlet，并为所有的Web应用程序提供包括MIME映射等默认配置信息。如下为web.xml中关于一个Servlet的配置举例：

```bash
<servlet>
    <servlet-name>ServletName</servlet-name>
    <servlet-class>xxxpackage.xxxServlet</servlet-class>
    <init-param>
        <param-name>参数名称</param-name>
        <param-value>参数值</param-value>
    </init-param>
</servlet>
<servlet-mapping>
    <servlet-name>ServletName</servlet-name>             
    <url-pattern>/aaa/xxx</url-pattern>
</servlet-mapping>
```

然后，在地址栏中输入`http://localhost:8080/web-App/aaa/xxx`就可以访问了。

备注：在webapps中部署WEB应用也有web.xml文件，即WEB-INF/web.xml文件。

（3）tomcat-user.xml

Realm认证时用到的相关角色、用户和密码等信息；Tomcat自带的manager默认情况下会用到此文件；在Tomcat中添加/删除用户，为用户指定角色等将通过编辑此文件实现。

（4）catalina.policy

Java相关的安全策略配置文件，在系统资源级别上提供访问控制的能力。

（5）catalina.properties

Tomcat内部package的定义及访问相关的控制，也包括对通过类装载器装载的内容的控制；Tomcat在启动时会事先读取此文件的相关设置。

（6）logging.properties

Tomcat通过自己内部实现的JAVA日志记录器来记录操作相关的日志，此文件即为日志记录器相关的配置信息，可以用来定义日志记录的组件级别以及日志文件的存在位置等。

（7）context.xml

所有host的默认配置信息。

# Tomcat的安装

前提声明，本次安装使用的是apache-tomcat-9.0.2和JDK 1.8。

（1）JDK环境配置

（2）Tomcat下载

选择Binary Distributions中Core目录下载即可。需要注意的是Full documenttion是文档，Deployer仅仅是一个发布器。

![](/images/tomcat_1_1.png)

（3）解压Tomcat的tarball即可，不需要编译安装的哦。

（4）启动Tomcat

```bash
cd ${TOMCAT_HOME} && ./bin/startup.sh         #启动tomcat
cd ${TOMCAT_HOME} && ./bin/catalina.sh start  #启动tomcat
cd ${TOMCAT_HOME} && ./bin/shutdown.sh        #关闭tomcat
cd ${TOMCAT_HOME} && ./bin/catalina.sh stop   #关闭tomcat
```

（5）访问测试

在浏览器中输入`http://127.0.0.1:8080/`即可。

备注：我们可以将自己开发的war包部署到${TOMCAT_HOME}/webapps目录下，tomcat会自动加载war包，然后在浏览器中输入`http://127.0.0.1/war_name/xxx`即可访问。

# 关于Tomcat的端口配置

Tomcat的端口是在`${TOMCAT_HOME}/conf/server.xml`中配置，在server.xml有多个地方配置端口，它们的含义各不相同，具体如下：

（1）Server元素中端口配置

如`<Server port="8005" shutdown="SHUTDOWN">`，port用来指定一个端口，这个端口负责监听关闭tomcat的请求；shutdown用来指定向端口发送的命令字符串。当我们kill tomcat进程时，就会向该端口发送shutdown指令。

（2）Connector元素中端口配置
<Connector>元素代表与客户程序实际交互的组件，它负责接收客户请求，以及向客户返回响应结果。一个server.xml会有多个<Connector>的配置，一般来说有：

```
<Connector port="8080" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />
<Connector executor="tomcatThreadPool" port="8080" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol" maxThreads="150" SSLEnabled="true" />
<Connector port="8443" protocol="org.apache.coyote.http11.Http11AprProtocol" maxThreads="150" SSLEnabled="true" />
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
```

备注：一般来说，可以通过protocol这个字段来判断这个Connector监听的端口是用来提供什么服务的。比如说`protocol="HTTP/1.1"`说明这个端口是用来提供HTTP服务的。

# Tomcat的WEB应用的部署方法

## 静态部署

静态部署有三种方法：

（1）直接将web应用放到webapps目录下

（2）通过`$TOMCAT_HOME/conf/server.xml`文件配置web应用的存放路径，此时web应用就不需要放到`$TOMCAT_HOME/webapps`中

（3）在`$TOMCAT_HOME/conf/`目录下新建`Catalina\localhost`目录，然后创建一个和web应用同名的xml文件，xml内容中指定web应用的存放路径

## 动态部署

通过Tomcat自动的管理平台来实现动态部署。

# Tomcat的闲杂知识

（1）tomcat不仅是非常受欢迎的Servlet容器，也同时为我们提供了很多非常实用组件，JDBC pool就是其中一个有用的组件。JDBC pool是非常实用且高效的JDBC连接池的实现。

