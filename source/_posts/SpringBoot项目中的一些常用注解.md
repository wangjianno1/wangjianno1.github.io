---
title: SpringBoot项目中的一些常用注解
date: 2019-03-04 15:00:46
tags:
categories: SpringBoot
---

# @Controller|@Service|@Repository|@Component

事实上，@Controller|@Service|@Repository|@Component这几个注解并没有任何功能上的区别，可以把这些当做是分类标签，目的是为了让你的代码可读性更强。在Annotaion配置注解中用@Component来表示一个通用注解，用于说明一个类是一个被Spring容器管理的bean，即该类已经拉入到Spring的管理中了。而@Controller, @Service, @Repository是对@Component的细化，这三个注解比@Component带有更多的语义，它们分别对应了控制层、服务层、持久层的类。详细如下：

    @Repository：用于标注数据访问组件，即DAO组件
    @Service：用于标注业务层组件
    @Controller：用于标注控制层组件（如struts中的action）
    @Component：泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注

# @RestController

Spring4之后新加的注解，表示controller返回给浏览器json格式的结果。此前控制器返回json结果，需要@ResponseBody配合@Controller一起。如果单独使用@Controller，那么需要配合模板引擎给浏览器返回html页面。即`@RestController=@Controller+@ResponseBody`。

# 设置路由映射及请求方法_@RequestMapping|@GetMapping|@PostMapping|@PutMapping|@DeleteMapping

都是用来配置url路由映射（即请求url映射到controller方法上）以及HTTP请求方法设定。@GetMapping、@PostMapping、@PutMapping以及@DeleteMapping除了配置url路由外，还指定了HTTP请求的Method，如@GetMapping代表的是Get请求。举例来说：

    @GetMapping("/hello")    #映射到http://xxx/hello请求路径上，HTTP请求方法是GET请求
    @RequestMapping(value="/hello", method = RequestMethod.POST)  #映射到http://xxx/hello请求路径上，HTTP请求方法是POST请求

# 获取HTTP请求参数_@PathVariable|@RequestParam|@RequestBody

（1）@PathVariable

获取url中的数据，如`@PathVariable("id") int id`，获取`@RequestMapping(value="/searchListById/{id}",method = RequestMethod.POST)`中的id
    
（2）@RequestParam

获取url问号后参数，如`@RequestParam(value="name",required = true)`，name表示问号参数的key，`?name=xxxx`

（3）@RequestBody

将请求体中内容映射到Java中对象上，如`@RequestBody TbUserModel user`，获取POST请求中请求body中的json数据，`{"id":1,"userId":1,"pwd":"123","name":"123","pwd":"123","headPortait":"123","isEnable":"123","createDate":"2015-05-12","lastLogin":"2015-05-12"}`

# @EnableAutoConfiguration

@EnableAutoConfiguration注解，用来告诉SpringBoot框架帮我们自动生成一些配置，也就是依据我们依赖的jar包（pom.xml）这个线索帮我们自动生成需要的配置。

# @Autowired

@Autowired自动装配。

当Spring容器启动时，AutowiredAnnotationBeanPostProcessor将扫描Spring容器中所有Bean。当发现Bean中拥有@Autowired注释时，就找到和其匹配（默认按类型匹配）的Bean，并注入到对应的地方中去。

**@Autowired可以注解到私有成员变量、构造方法、成员方法上**。当@Autowired对方法或构造函数进行标注时，Spring会将构造函数或成员方法的参数所对应的对象以Spring Bean的形式注入进去。

# @EnableScheduling|@Scheduled

@EnableScheduling表示开启Spring的定时调度任务功能，在SpringBoot项目上要实现定时调度任务，必须在项目入口类上加上该注解。@Scheduled是用来设定具体的调度策略，如`@Scheduled(cron = "0 0 8,20 * * ?")`表示每天的8点和20点执行一下该任务。

# @Resource

@Resource和@Autowired的功能是类似的，也是用来自动装配的。只是@Resource这个注解是JDK自带的，Spring对@Resource也是支持的。而@Autowired是Spring自带的注解。

# @Configuration

@Configuration注解标注一个类是配置类，Spring框架在扫到这个注解时自动加载这个类相关的功能。@Configuration标注在类上，相当于把该类作为Spring的XML配置文件中的<beans>，即其作用为配置Spring容器的应用上下文。例如：

```java
package com.test.spring.support.configuration;

@Configuration
public class TestConfiguration {
    public TestConfiguration(){
        System.out.println("spring容器启动初始化。。。");
    }

    @Bean
    public Foo foo() {
        return new Foo();
    }
}
```

就相当于如下的Spring XML配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"; xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance";
    xmlns:util="http://www.springframework.org/schema/util"; xmlns:task="http://www.springframework.org/schema/task"; xsi:schemaLocation="
http://www.springframework.org/schema/beanshttp://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/taskhttp://www.springframework.org/schema/task/spring-task-4.0.xsd"; default-lazy-init="false">
    <bean id="foo" class="com.test.Foo">
</beans>
```

备注：其中@Bean相当于定义了一个Bean对象，具体见下面对@Bean注解的描述。

# @Bean

@Bean标注在某个方法上（该方法需要返回某个实例对象），这就相当于在Spring的XML配置文件中添加了一个`<bean>`的配置。说白了，@Bean和@Component等一样，定义了一个被Spring管理的Bean对象，只是@Bean是将某个方法返回的实例对象作为Bean让Spring去管理。

备注：使用@Configuration和@Bean注解来代替传统的XML配置文件，这种方式称为Spring JavaConfig（Java Configuration）方式哦，记住这个名词。

# @ConfigurationProperties

将自定义配置文件中内容映射到JAVA对象中，具体参见[《SpringBoot项目中配置定义和使用》](https://wangjianno1.github.io/2019/03/04/SpringBoot%E9%A1%B9%E7%9B%AE%E4%B8%AD%E9%85%8D%E7%BD%AE%E5%AE%9A%E4%B9%89%E5%92%8C%E4%BD%BF%E7%94%A8/)。

# @Value

将resources/application.properties中的配置内容注入到类的成员变量上，具体参见[《SpringBoot项目中配置定义和使用》](https://wangjianno1.github.io/2019/03/04/SpringBoot%E9%A1%B9%E7%9B%AE%E4%B8%AD%E9%85%8D%E7%BD%AE%E5%AE%9A%E4%B9%89%E5%92%8C%E4%BD%BF%E7%94%A8/)。

# @SpringBootApplication

很多SpringBoot开发者总是使用@Configuration，@EnableAutoConfiguration和@ComponentScan注解他们的main类。由于这些注解被如此频繁地一块使用，Spring Boot提供一个方便的@SpringBootApplication选择。该@SpringBootApplication注解等价于以默认属性使用@Configuration，@EnableAutoConfiguration和@ComponentScan。值得注意的是，使用了@SpringBootApplication注解后，在该启动Main类所在的package下的所有子package都会被Spring扫描，若使用了@Service、 @Repository或@Component等注解的类，都会被Spring容器纳入管理。一定要注意的是，使用@SpringBootApplication注解只会扫描启动所在package下及其子package的类，如果满足@Service、 @Repository或@Component等注解才会纳入Spring容器管理。因此，如果需要SpringBoot中Spring能管理第三方包中的Bean，则在@SpringBootApplication的基础上再加上@ComponentScan注解，指明要扫描的包名。

# @ResponseBody

该注解用于将Controller的方法返回的对象通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区。因此，当我们Controller方法返回的数据不是html格式的页面，而是其他某种格式的数据时，如json、xml等，就需要使用到@ResponseBody注解。

# @Transactional
在和数据库做相关操作时，我们可以通过@Transactional注解来达到事务功能。@Transactional注解可以作用到类上，也可以作用到方法上。假设@Transactional作用到某个方法上，那么在一次客户端请求过程中，如果该方法中任何地方抛出异常（不管是数据库相关的异常，还是其他的异常），则回滚所有数据库相关的变更操作。如果@Transactional作用到类上，那么相当于该类中所有方法上都使用了@Transactional注解。需要注意的是，一般我们将@Transactional注解到Service层的类名或Service层的方法上，注解到Service的类上，则该类中所有方法都有事务性，注解到方法上则只有该方法有事务性。

备注：@Transactional注解的完整包路径是`org.springframework.transaction.annotation.Transactional`，是属于Spring Framework框架中的。

# @Async

“异步调用”对应的是“同步调用”，同步调用指程序按照定义顺序依次执行，每一行程序都必须等待上一行程序执行完成之后才能执行；异步调用指程序在顺序执行时，不等待异步调用的语句返回结果就执行后面的程序。

SpringBoot项目中在方法上标注@Async，既让该方法变成一个异步方法，调用方调用后，不等待该异步方法的结果，然后继续执行后面的逻辑。需要注意的是，还需要在SpringBoot的主程序中配置@EnableAsync才能生效。
