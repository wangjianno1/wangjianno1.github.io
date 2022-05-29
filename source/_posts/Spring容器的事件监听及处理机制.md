---
title: Spring容器的事件监听及处理机制
date: 2022-05-29 16:21:26
tags:
categories: SSM/SSH
---

# Spring项目中容器的事件监听及处理机制简介

Spring容器有一套事件监听和处理机制，主要有如下三个组件：

（1）事件发布者（publisher）事件发生的触发者

（2）事件（event）可以封装和传递监听器中要处理的参数，如对象或字符串，并作为监听器中监听的目标。

（3）监听器（listener）具体根据事件发生的业务处理模块，这里可以接收处理事件中封装的对象或字符串。

即事件发布者，发布Event，然后监听器监听到Event，触发事件处理逻辑。

# Spring中事件监听机制使用

Spring中事件监听机制使用有两种方式，一种是实现ApplicationListener接口，一种使用注解@EventListener。

（1）使用实现ApplicationListener接口

使用方法很简单，就是实现一个ApplicationListener接口，并且将加入到容器中就行。

```java
@Component
public class MyApplicationListener implements ApplicationListener<ApplicationEvent> {

@Override
public void onApplicationEvent(ApplicationEvent event) {
    System.out.println("事件触发："+event.getClass().getName());
}
```

备注：ApplicationEvent就是Spring框架产生的一种事件。

然后启动自己的springboot项目：

```java
@SpringBootApplication
public class ApplicationListenerDemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApplicationListenerDemoApplication.class, args);
    }
}
```

可以看到控制台有输出：

    事件触发：org.springframework.context.event.ContextRefreshedEvent
    2021-01-24 22:09:20.113  INFO 9228 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
    事件触发：org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent
    2021-01-24 22:09:20.116  INFO 9228 --- [           main] c.n.ApplicationListenerDemoApplication   : Started ApplicationListenerDemoApplication in 1.221 seconds (JVM running for 1.903)
    事件触发：org.springframework.boot.context.event.ApplicationStartedEvent
    事件触发：org.springframework.boot.context.event.ApplicationReadyEvent

（2）使用@EventListener

除了通过实现接口，还可以使用@EventListener注解，实现对任意的方法都能监听事件。在任意方法上标注@EventListener注解，指定classes，即需要处理的事件类型，一般就是ApplicationEven及其子类，可以设置多项。

```java
@Configuration
public class Config {
    @EventListener(classes = {ApplicationEvent.class})
    public void listen(ApplicationEvent event) {
        System.out.println("事件触发：" + event.getClass().getName());
    }
}
```

启动项目，可以看到控制台和之前的输出是一样的：

    事件触发：org.springframework.context.event.ContextRefreshedEvent
    2021-01-24 22:39:13.647  INFO 16072 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
    事件触发：org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent
    2021-01-24 22:39:13.650  INFO 16072 --- [           main] c.n.ApplicationListenerDemoApplication   : Started ApplicationListenerDemoApplication in 1.316 seconds (JVM running for 2.504)
    事件触发：org.springframework.boot.context.event.ApplicationStartedEvent
    事件触发：org.springframework.boot.context.event.ApplicationReadyEvent

# Spring中一些标准事件

Spring提供以下标准事件，

![](/images/java_springevent_1_1.png)
