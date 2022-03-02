---
title: SpringBoot项目中日志管理
date: 2019-03-04 14:24:47
tags:
categories: SpringBoot
---

# SpringBoot日志简介

默认情况下，SpringBoot会用Logback来记录日志，并用INFO级别输出到控制台。但是默认配置也提供了对常用日志的支持，如Java Util Logging，Log4J，Log4J2和Logback。每种Logger都可以通过配置使用控制台或者文件输出日志内容。默认输出日志的格式如下：

    2016-04-13 08:23:50.120 INFO 37397 --- [ main] org.hibernate.Version : HHH000412: Hibernate Core {4.3.11.Final}

各个字段说明如下：

    时间日期 — 精确到毫秒
    日志级别 — ERROR, WARN, INFO, DEBUG or TRACE
    进程ID
    分隔符 — 标识实际日志的开始
    线程名 — 方括号括起来（可能会截断控制台输出）
    Logger名 — 通常使用源代码的类名
    日志内容

# SpringBoot日志的输出位置

SpringBoot默认配置只会输出到控制台，并不会记录到文件中，但是我们通常生产环境使用时都需要以文件方式记录日志。若要增加文件输出，需要在application.properties中配置logging.file或logging.path属性。需要注意的是，二者不能同时使用，如若同时使用，则只有logging.file生效。默认情况下，日志文件的大小达到10MB时会切分一次，产生新的日志文件，默认级别为ERROR、WARN、INFO。

（1）logging.file，设置文件，可以是绝对路径，也可以是相对路径。如logging.file=sbdemo.log会在当前目录生成一个sbdemo.log的日志文件

（2）logging.path，设置目录，会在该目录下创建spring.log文件，并写入日志内容，如logging.path=/var/log会在/var/log/下生成一个spring.log的日志文件

具体配置实例如下：

    #logging.path=D:\\apache-tomcat-9.0.8\\logs
    logging.file=D:\\apache-tomcat-9.0.8\\logs\\sbdemo.log

# SpringBoot应用的日志级别控制

SpringBoot应用的日志级别控制有如下几种配置：

（1）配置SpringBoot框架自身输出日志的级别在SpringBoot中默认配置了ERROR、WARN和INFO级别的日志输出到控制台。我们可以通过如下两种方式切换不同的日志级别，如切换到DEBUG日志级别，可以有如下两种方法：

    A).在运行命令后加入--debug标志，如java -jar myapp.jar --debug
    B).在application.properties中配置debug=true，该属性置为true的时候，核心Logger（包含嵌入式容器、hibernate、spring）会输出更多内容，但是你自己应用的日志并不会输出为DEBUG级别

备注：上述配置的日志级别是针对SpringBoot框架自身的日志级别，开发者在代码中logger.xxx并不会依据该级别输出日志。

（2）配置开发者自己代码输出的日志

我们可以在controller、service以及repository层定义Logger，然后使用Logger输出不同级别的日志，代码如下：

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private final Logger logger = LoggerFactory.getLogger(StudentController.class); //参数一定要是当前类的类对象，将会在日志中有体现
logger.info("info log print~~~");
logger.debug("debug log print~~~");
```

如需要在静态工具类中打印日志，可以使用`private final static Logger logger = LoggerFactory.getLogger(ResultUtil.class)`即可。

在application.properties中做如下配置可以控制输出的日志级别：

    logging.level.com.bat=WARN #格式为logging.level.*=LEVEL，其中*表示包名，表示对该包下的所有类的日志输出定义一个日志级别

（3）配置SpringBoot的root Logger的日志级别

配置SpringBoot的root Logger的日志级别，对框架自身以及开发者自己输出的日志都是有效的，配置如下：

    logging.level.root=DEBUG

# 定义日志的格式

在application.properties中通过如下配置可以定义日志的格式：

    logging.pattern.console=%d - %msg%n
    logging.pattern.file=%d - %msg%n

其中logging.pattern.console表示输出到控制台的日志格式，logging.pattern.file表示输出到文件的日志格式。

# 开发者自定义日志输出

（1）在src/main/resources下创建日志配置文件，如logback-spring.xml，log4j-spring.xml，log4j2-spring.xml或logging.properties等

（2）在application.properties中指定日志配置文件的位置logging.config=classpath:log4j-spring.xml

学习资料参考于：
https://blog.csdn.net/Inke88/article/details/75007649
