---
title: SpringMVC技术小结
date: 2019-03-04 18:49:27
tags:
categories: SSM/SSH
---

# SpringMVC简介

SpringMVC，全称为Spring Web MVC，是Spring Framework的一个模块，它是一个WEB MVC框架，它和Struts/Struts2解决的问题是一致的，可以直接代替Struts/Struts2，不过Struts作为一个非常成熟的MVC，功能上感觉还是比Spring强一点，不过SpringMVC已经足够用了。SpringMVC解决的问题有URL路由、Session、模板引擎、静态Web资源等等。

SpringMVC主要由DispatcherServlet、处理器映射、处理器(控制器)、视图解析器、视图组成，其核心组件为DispatcherServlet。SpringMVC实现了MVC模式，包括怎样与Web容器环境集成，Web请求的拦截、分发、处理和ModelAndView数据的返回，以及如何集成各种UI视图展现和数据表示。

本质上来说，SpringMVC是基于Servlet规范的MVC框架的实现，那么SpringMVC在Tomcat/JSP来看，其实就是一个Servlet。SpringMVC是Servlet的实现，在SpringMVC就是DispatchServlet，所有的http请求都是映射到这个Servlet上，请求进入到这个Servlet中之后，就算进入到了框架之中了，由这个Servlet来统一的分配http请求到各个Controller。

# SpringMVC运行原理

## SpringMVC常用组件

（1）DispatcherServlet

即前端控制器，由框架提供，不需要工程师开发。用来统一处理请求和响应，整个流程控制的中心，由它调用其它组件处理用户的请求。这个控件是SpringMVC最核心的一个控件，顾名思义其实他就是一个Servlet，是Spring框架写好的一个Servlet。

（2）HandlerMapping

即处理器映射器，由框架提供，不需要工程师开发。用来根据请求的url/method等信息来查找Handler，即控制器方法。

（3）Handler/Controller
即控制器，需要工程师开发，也就是开发中定义的各种xxController。用来在DispatcherServlet的控制下，Handler对具体的用户请求进行处理，即用来处理业务逻辑的类。

```java
@Controller
public class DataController {
    @RequestMapping("getData.form")
    public ModeAndView hello(String stationId) {
        System.out.println("hello");
        return new ModelAndView("hello")
    }
}
```

（4）HandlerAdapter

即处理器适配器，由框架提供，不需要工程师开发。当DispatcherServlet通过HandlerMapping找到具体的Handler，然后由HandlerAdapter去调用Handler方法。也就是HandlerAdapter是用来调用Handler的。

（5）ModelAndView

Mode用来绑定处理后所得的数据，View视图名，它保存了Handler执行完成之后所需要发送到前端的数据，以及需要跳转的路径，这些是DispatcherServlet需要用到的。
两种ModelAndView构造函数如下：

```java
ModelAndView(String viewName)
ModelAndView(String viewName, Map data)   // viewName就是view的名称，data是Model获取的数据
```

（6）ViewResolver

即视图解析器，由框架提供，不需要工程师开发。用来进行视图解析，得到相应的视图，例如ThymeleafView、InternalResourceView及RedirectView等。

（7）View

即视图，由框架或视图技术提供，不需要工程师开发。用来将模型数据通过页面展示给用户。

（8）HandlerInterceptor

Handler拦截器。DispatcherServlet把请求的url交给HandlerMapping, HandlerMapping根据请求查出对应的Handler/Controller来交给DispatcherServlet, 然后DispatcherServlet交给Controller执行就完事了？那就To young to native了，这其中还有一些小插曲。比如我们不能啥请求不管三七二十一都交给Handler执行吧，最起码要过滤一下不合理的请求，比如跳转页面的时候检查Session，如果用户没登录跳转到登录界面啊，以及一些程序的异常以统一的方式跳转等等，都需要对请求进行拦截。这部分工作就是交给HandlerInterceptor来处理。

有一点需要特别注意的是，在J2EE的Servlet中有个Filter，也可以完成请求拦截与过滤的功能。然后HandlerInterceptor是有差别的，HandlerInterceptor提供了更细粒度的拦截，因为Filter拦截的对象是Serlvet，而HandlerInterceptor拦截的则是Handler/Controller。下面一张图可以生动的表现出来：

![](/images/java_springmvc_1_4.png)

从图中我们可以看出HandlerInteceptor可以配置多个，其中任何一个返回false的话，请求都将被拦截，直接返回。

（9）HandlerExecutionChain

DispatherServlet求助HandlerMapping进行url与Handler/Controller的映射，但是DispatherServlet在将url交给特定的HandlerMapping之后，HandlerMapping在进行了一顿猛如虎的操作之后，返回给DispaterServlet的却不是一个可执行的Handler/Controller，而是一个HandlerExecutionChain对象。

这里就涉及到设计模式中的责任链设计模式，HandlerExecutionChain将HandlerInterceptor与Handler串成一个执行链的形式，首先请求会被第一个HandlerInterceptor拦截，如果返回false，那么直接短路请求，如果返回true，那么再交给第二个HandlerInterceptor处理，直到所有的HandlerInterceptor都检查通过，请求才到达Handler/Controller，交由Handler正式的处理请求，执行完成之后再逐层的返回。

也就是DispatcherServlet拿到的就是这样一个串联好的HandlerExecutionChain，然后顺序的执行请求。

## SpringMVC的处理过程

![](/images/java_springmvc_1_1.png)

![](/images/java_springmvc_1_3.png)

其请求详细过程如下：

（1）发起请求到前端控制器(DispatcherServlet)

（2）前端控制器请求HandlerMapping查找Handler，可以根据xml配置、注解进行查找

（3）处理器映射器HandlerMapping向前端控制器返回Handler

（4）前端控制器调用处理器适配器去执行Handler

（5）处理器适配器去执行Handler

（6）Handler执行完成给适配器返回ModelAndView

（7）处理器适配器向前端控制器返回ModelAndView(是SpringMVC框架的一个底层对象，包括Model和View)

（8）前端控制器请求视图解析器去进行视图解析，根据逻辑视图名称解析真正的视图(jsp...)

（9）视图解析器向前端控制器返回View

（10）前端控制器进行视图渲染，视图渲染就是将模型数据(在ModelAndView对象中)填充到request域中

（11）前端控制器向用户响应结果

# SpringMVC与Spring创建的Bean容器

![](/images/java_springmvc_1_2.png)

在SpringMVC+Spring的WEB应用中，SpringMVC DispatcherServlet会创建一个Bean容器，即Servlet WebapplicationContext。Spring也会创建一个Bean容器，即Root WebApplicationContext。且Servlet WebapplicationContext是Root WebApplicationContext的子容器，它们管理的Bean不同，Servlet WebapplicationContext管理和WEB相关的Bean，如Controller、ViewResolver等，Root WebApplicationContext则管理一些公共基础的Bean，如Services、Repositories以及DAO等等。

备注：在tomcat/jetty容器启动时，是先初始化Spring容器，再初始化SpringMVC容器哦。

# SpringBoot项目自动SpringMVC配置

WebMvcAutoConfiguration是Spring Boot针对SpringMVC的自动配置机制，其效果等同于开发人员自己使用@EnableWebMvc进行的SpringMVC配置。
WebMvcAutoConfiguration的启用是有条件的，它在如下条件都满足时才会起作用：

    （1）必须是Servlet Web应用环境
    （2）在classpath上必须有Servlet，DispatcherServlet，WebMvcConfigurer这三个类或者接口的存在
    （3）必须在Bean WebMvcConfigurationSupport没有被定义的情况下
    注意 : 这个条件决定了自动配置机制WebMvcAutoConfiguration的优先级低于开发人员使用@EnableWebMvc进行的自定义配置机制，因为开发人员使用@EnableWebMvc进行配置时，最终会注册一个Bean WebMvcConfigurationSupport。

另外，WebMvcAutoConfiguration自动配置机制的执行必须发生在以下自动配置机制之后:

    DispatcherServletAutoConfiguration
    TaskExecutionAutoConfiguration
    ValidationAutoConfiguration

# SpringBoot项目自定义SpringMVC配置

用过Spring Boot的小伙伴都知道，我们只需要在项目中引入spring-boot-starter-web依赖，SpringMVC的一整套东西就会自动给我们配置好，但是，真实的项目环境比较复杂，系统自带的配置不一定满足我们的需求，往往我们还需要结合实际情况自定义配置。自定义配置就有讲究了，由于Spring Boot的版本变迁，加上这一块本身就有几个不同写法，很多小伙伴在这里容易搞混。

我们需要明确，跟自定义SpringMVC相关的类和注解主要有如下四个：

    WebMvcConfigurerAdapter
    WebMvcConfigurer
    WebMvcConfigurationSupport
    @EnableWebMvc

这四个中，除了第四个是注解，另外三个两个类一个接口，里边的方法看起来好像都类似，但是实际使用效果却大不相同。

（1）WebMvcConfigurerAdapter

WebMvcConfigurerAdapter，这个是在Spring Boot 1.x中我们自定义SpringMVC时继承的一个抽象类，这个抽象类本身是实现了WebMvcConfigurer接口，然后抽象类里边都是空方法，我们来看一下这个类的声明：

```java
public abstract class WebMvcConfigurerAdapter implements WebMvcConfigurer {
    //各种SpringMVC配置的方法
}
```

也就是说，在Spring Boot 1.x的时代，如果我们需要自定义SpringMVC配置，直接继承WebMvcConfigurerAdapter类即可。

（2）WebMvcConfigurer

小伙伴们已经明白了，WebMvcConfigurer是我们在Spring Boot 2.x中实现自定义配置的方案。WebMvcConfigurer是一个接口，接口中的方法和WebMvcConfigurerAdapter中定义的空方法其实一样，所以用法上来说，基本上没有差别，从Spring Boot 1.x切换到Spring Boot 2.x，只需要把继承类改成实现接口即可。

（3）WebMvcConfigurationSupport

我们自定义SpringMVC的配置是可以通过继承WebMvcConfigurationSupport来实现的。但是继承WebMvcConfigurationSupport这种操作我们一般只在Java配置的SSM项目中使用，Spring Boot中基本上不会这么写，为什么呢？小伙伴们知道，Spring Boot中，SpringMVC相关的自动化配置是在WebMvcAutoConfiguration配置类中实现的，那么我们来看看这个配置类的生效条件：

```java
@Configuration
@ConditionalOnWebApplication(type = Type.SERVLET)
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class, WebMvcConfigurer.class })
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class, TaskExecutionAutoConfiguration.class,
ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {
}
```

我们从这个类的注解中可以看到，它的生效条件有一条，就是当不存在WebMvcConfigurationSupport的实例时，这个自动化配置才会生生效。因此，如果我们在Spring Boot中自定义SpringMVC配置时选择了继承WebMvcConfigurationSupport，就会导致Spring Boot中SpringMVC的自动化配置失效。

Spring Boot给我们提供了很多自动化配置，很多时候当我们修改这些配置的时候，并不是要全盘否定Spring Boot提供的自动化配置，我们可能只是针对某一个配置做出修改，其他的配置还是按照Spring Boot默认的自动化配置来，而继承WebMvcConfigurationSupport来实现对SpringMVC的配置会导致所有的SpringMVC自动化配置失效，因此，一般情况下我们不选择这种方案。

（4）@EnableWebMvc

@EnableWebMvc注解，这个注解很好理解，它的作用就是启用WebMvcConfigurationSupport。可以看到，加了这个注解，就会自动导入WebMvcConfigurationSupport，所以在Spring Boot中，我们也不建议使用@EnableWebMvc注解，因为它一样会导致Spring Boot中的SpringMVC自动化配置失效。

总结一下：

Spring Boot 1.x中，自定义SpringMVC配置可以通过继承WebMvcConfigurerAdapter来实现。

Spring Boot 2.x中，自定义SpringMVC配置可以通过实现WebMvcConfigurer接口来完成。

如果在Spring Boot中使用继承WebMvcConfigurationSupport来实现自定义SpringMVC配置，或者在Spring Boot中使用了@EnableWebMvc注解，都会导致Spring Boot中默认的SpringMVC自动化配置失效。

在纯Java配置的SSM环境中（指的是没有使用SpringBoot的项目，使用SpringMVC+Spring+Mybatis搭建的项目），如果我们要自定义SpringMVC配置，有两种办法，第一种就是直接继承自WebMvcConfigurationSupport来完成SpringMVC配置。还有一种方案就是实现WebMvcConfigurer接口来完成自定义SpringMVC配置，如果使用第二种方式，则需要给SpringMVC的配置类上额外添加@EnableWebMvc注解，表示启用WebMvcConfigurationSupport，这样配置才会生效。换句话说，在纯Java配置的SSM中，如果你需要自定义SpringMVC配置，你离不开WebMvcConfigurationSupport，所以在这种情况下建议通过继承WebMvcConfigurationSupport来实现自动化配置。

# 使用了SpringMVC框架的项目的web.xml

使用SpringMVC框架的项目，首先要做的将DispatcherServlet配置到WEB应用的web.xml，如下是SpringMVC+Spring的web.xml的配置，前面的部分是给Spring Framework配置一个监听器，这个监听器主要是用来初始化Spring Bean容器和初始化Bean的，即初始化Spring的ApplicationContext和Bean对象。后面的部分是配置SpringMVC的核心DispatcherServlet和路径映射的。

```xml
<web-app>
    <!-- 配置Spring Framework的监听器-->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/app-context.xml</param-value>
    </context-param>

    <!-- 配置SpringMVC DispatchcerServlet -->
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
</web-app>
```

学习资料参考于：
https://mp.weixin.qq.com/s/rtCLRqsaXPSGHui4AUuKfg
