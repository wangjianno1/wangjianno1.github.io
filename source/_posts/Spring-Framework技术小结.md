---
title: Spring Framework技术小结
date: 2019-03-04 18:29:43
tags:
categories: SSM/SSH
---

# Spring Framework简介

通常来说，我们说的Spring指的是Spring Framework，其实它只是Spring家族中一个产品。

Spring Framework是使用基本的JavaBean代替EJB，通过容器来管理JavaBean的配置和生命周期，在此基础上实现了AOP、IoC的Spring核心功能，其他WEB框架组件在AOP、IoC的基础上工作，将JavaBean交给Spring来管理。简单来说，Spring是一个轻量级的控制反转（IoC）和面向切面（AOP）的容器框架。
Spring功能模块框架图如下：

![](/images/java_spring_1_1.png)

Spring Framework的主要子模块有IoC，AOP，Spring MVC，JMS，JMX等等。

# Spring Framework的几个核心概念

简单来说，Spring Framework是一个轻量级的控制反转IoC和面向切面AOP的容器框架。Spring Framework的核心模块有：

（1）Bean容器

Bean容器（Spring Framework的基础核心概念哦，Spring Bean容器存放的是一个个单例对象）。**相比于JAVA官方的EJB，Spring Bean容器更轻量级及简单易用（Spring Bean容器可以对标到EJB容器哦）**。也许正是因为这个核心功能，才让人们经常把Spring和EJB进行对标。

备注：Spring容器中的Bean默认都是单例的。

（2）IoC（和依赖注入DI是一个意思哦）

IoC，控制反转，即依赖对象的获得被反转了。控制反转有一个更容易理解的名字是“依赖注入（DI）”。许多复杂的应用都是由两个或多个类通过彼此的合作来实现业务逻辑的，这使得每个对象都获得与其合作的对象（也就是它所依赖的对象）的引用。如果这个获取过程是靠自身实现，那么将导致代码高度耦合并且难以测试。在Spring中，有了IoC或DI，它可以在对象生成或初始化时直接将数据注入到对象中，也可以通过将对象引用注入到对象数据域中的方式来注入对方法调用的依赖。这种依赖注入是可以递归的，对象被逐层注入，这样就简化了对象依赖关系的管理，在很大程度上简化了面向对象系统的复杂性。

其实，IoC的思想在不同的语言中都有很多实现。Spring IoC是JAVA世界中最著名的一个。

（3）AOP

IOC容器和AOP是Spring平台的核心内容，它们是Spring系统中其他组件模块和应用开发的基础。

![](/images/java_spring_1_2.png)

# Spring Bean容器

![](/images/java_spring_1_3.png)

![](/images/java_spring_1_4.png)

备注：如上是Spring这个庞大的框架的基础设施，其他的Spring功能模块是基于Bean管理之上的哦

**Spring对Bean的管理有两种方式，一种是基于XML配置文件（手动装配），一种是基于注解的方式（自动装配）**。

（1）基于XML配置文件

开发人员在spring-xxx.xml配置文件中，通过一些`<bean>...</bean>`标签来定义各个bean对象以及它们之间的依赖关系。然后应用程序通过`BeanFactory`或`ApplicationContext`获取到bean对象。这是传统的管理方式哦。举例来说：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans";
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance";
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">;
    <bean id="userDAO" class="com.bjsxt.DAO.impl.UserDAOImpl">
    </bean>
    <bean id="userService" class="com.bjsxt.service.UserService">
        <property name="userDAO" ref="userDAO" />
    </bean>
</beans>
```

然后，可以通过Spring的Application Context来获取指定的bean对象，如下：

```java
String[] locations = {"spring-xxx.xml"};
ApplicationContext ctx = new ClassPathXmlApplicationContext(locations);
UserService userService = (UserService)ctx.getBean("userService");
System.out.println(userService);
```

备注：**在Spring中XXXApplicationContext是一个很重要的东东哦，通过它可以拿到Spring管理的各种Bean对象哦**。常用的XXXApplicationContext有：

    ClassPathXmlApplicationContext
    XmlWebApplicationContext
    AnnotationConfigApplicationContext
    AnnotationConfigWebApplicationContext
    ......

BeanFacotry是Spring中比较原始的Factory，如XMLBeanFactory就是一种典型的BeanFactory。原始的BeanFactory无法支持Spring的许多插件，如AOP功能、WEB应用等。ApplicationContext接口，它由BeanFactory接口派生而来，因而提供BeanFactory所有的功能。ApplicationContext以一种更向面向框架的方式工作以及对上下文进行分层和实现继承，ApplicationContext包还提供了以下的功能：  

    MessageSource, 提供国际化的消息访问
    资源访问，如URL和文件
    事件传播
    载入多个（有继承关系）上下文 ，使得每一个上下文都专注于一个特定的层次，比如应用的web层 

（2）基于注解的方式

通过JAVA的注解来定义bean，而不是XML配置文件，从而将Spring配置信息的载体由XML文件转移到了JAVA类中，最终简化了Spring配置的繁琐性哦。常用的Spring Bean注解有：

    @Component是一个通用的bean注解，可用于任何bean
    @Repository通常用于注解DAO类，即持久层的bean
    @Service通常用于注解Service类，即服务层的bean
    @Controller通常用于注解Controller类，即控制层的bean

即被@Component、@Repository，@Service以及@Controller等注解，注解过的对象，就会被Spring自动识别为Bean并予以管理哦。

备注：其实Spring框架中的很多模块的使用，即可以使用XML配置文件，也可以使用注解的方式。

# AOP技术

（1）AOP简介

AOP，Aspect Oriented Programming，中文为面向切面的编程，通过预编译方式或运行期动态代理实现程序功能的统一维护的一种技术。AOP能够将那些与业务无关，却为业务模块所共同调用的逻辑或责任封装起来，便于减少系统的重复代码，降低模块间的耦合度，并有利于未来的可拓展性和可维护性，主要的功能有日志记录、性能统计、安全控制、事务处理以及异常处理等等。举例来说：

![](/images/java_spring_1_5.png)

（2）AOP技术的实现方式

AOP技术的实现方式有两种，一个是以AspectJ等为代表的预编译方式，一个是以Spring AOP，JbossAOP等为代表的运行期动态代理（JDK动态代理、CGLib动态代理）。

Spring AOP是基于动态代理的，如果要代理的对象，实现了某个接口，那么Spring AOP会使用JDK Proxy，去创建代理对象，而对于没有实现接口的对象，就无法使用JDK Proxy去进行代理了，这时候Spring AOP会使用Cglib，这时候Spring AOP会使用Cglib生成一个被代理对象的子类来作为代理，如下图所示：

![](/images/java_spring_1_7.png)

（3）AOP技术中的一些基本概念

![](/images/java_spring_1_6.png)

（4）Spring AOP的配置

```xml
<aop:config><aop:aspect></aop:aspect></aop:config>
```

# Spring HelloWorld程序

（1）在Eclipse新建Maven Project，且在pom.xml中引入Spring框架的核心依赖，如下：

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>4.3.10.RELEASE</version>
</dependency>
```

（2）新建一个将要被Spring容器管理的Bean类

新建一个名称为HelloWorld的Bean类，如下：

```java
public class HelloWorld {
    private String message;

    public void setMessage(String message) {
        this.message = message;
    }

    public void getMessage() {
        System.out.println("Your Message : " + message);
    }
}
```

（3）在XML中配置HelloWorld Bean

新建一个`src/main/resources/beans.xml`文件（文件的名称可任意），XML配置文件内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans";
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance";
    xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">;
   <bean id="helloWorld" class="com.sohu.sysadmin.spring_learning.bean.HelloWorld">
       <property name="message" value="Hi,Guys~~~"/>
   </bean>
</beans>
```

（4）Spring依据beans.xml配置生成Spring ApplicationContext，代码如下：

```java
public class MainApp {
    public static void main(String[] args) {
        // 普通方式
        HelloWorld hw_1 = new HelloWorld();
        hw_1.getMessage();

        // Spring使用方式一__使用BeanFactory获取Bean对象
        XmlBeanFactory factory = new XmlBeanFactory(new ClassPathResource("Beans.xml"));
        HelloWorld hw_2 = (HelloWorld) factory.getBean("helloWorld");
        hw_2.getMessage();

        // Spring使用方式二__使用ApplicationContext获取bean对象
        ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        HelloWorld hw_3 = (HelloWorld) context.getBean("helloWorld");
        hw_3.getMessage();
    }
}
```

（5）直接运行测试

# Tomcat中Spring的初始化

使用了Spring框架的Java Web应用，必须需要在/WEB-INF/web.xml中配置如下内容：

```xml
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/applicationContext.xml classpath:resources/services.xml</param-value>
</context-param>
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
```

其中contextConfigLocation配置了Spring的配置文件，ContextLoaderListener是Spring框架实现了javax.servlet.ServletContextListener接口的Listener，它会读取contextConfigLocation指定的Spring配置文件，并加载和初始化Spring管理的各种Bean对象啦。

# 其他闲杂知识

（1）Spring MVC对标Struts，Spring JDBC对标Hibernate。

学习资料参考于：
[《Spring技术的前世今生》](http://mp.weixin.qq.com/s/uhDCppoDTvs_WdGTdyuVdg)
