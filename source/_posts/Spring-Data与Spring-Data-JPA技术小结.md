---
title: Spring Data与Spring Data JPA技术小结
date: 2019-03-04 20:02:51
tags:
categories: SSM/SSH
---

# Spring Data简介

Spring Data是Spring平台中一个功能模块，主要用来和数据访问层相关的框架功能。其模块组织结构图如下：

![](/images/java_springdata_1_1.png)

# Spring Data JPA简介

Spring Data JPA是Spring Data的一个子模块，使用它可以非常简单地操作“关系型数据库”。Spring Data JPA是用来简化项目中数据访问层的逻辑。在以前的Spring应用项目中，我们需要编写DAO层接口和DAO层实现类，而这些接口或实现类有很多是重复类似的代码。若使用了Spring Data JPA子模块，那么我们只需要编写DAO层接口，Spring Data JPA会根据这些接口自动生成实现类，并由Spring容器管理以便再注入到service层。

如下为Spring Data JPA的周边技术关系图（可见使用Spring Data JPA时，具体使用哪种ORM框架是由用户自己决定的）：

![](/images/java_springdata_1_2.png)

# Spring Data JPA的使用

（1）引入Spring Data JPA的依赖包

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.data</groupId>
        <artifactId>spring-data-jpa</artifactId>
        <version>2.0.2.RELEASE</version>
    </dependency>
</dependencies>
```

（2）定义实体类Entity

```java
@Entity
public class Foo {
    @Id
    private Long id;
    private String name;
    // ...
}
```

备注：@Entity和@Id都是JAVA JPA中定义的注解，即javax.persistence.Entity和javax.persistence.Id等

（3）定义Repository接口

代码示例如下：

```java
public interface UserDao extends Repository<Foo, Long> {
    public AccountInfo save(Foo foo);
}
```

备注：Repository就是Spring Data JPA中的一个概念哦。开发者只需要定义一个继承了Repository或其子接口的接口即可。然后Spring Data JPA会帮我们自动生成实现类，开发者就不需要自己去实现该接口了。另外，不需要使用注解将UserDao定义Bean，Spring会自动将其视为Bean并管理，在Service层直接注入即可使用。

（4）Spring容器将Repository bean对象注入service层，用户在service层直接调用Repository bean对象即可。

```java
@Controller
public class FooController {
    @Autowired
    private FooRepository fooRepository;

    @RequestMapping("/")
    @ResponseBody
    Foo getFoo() {
        return fooRepository.findOne(1L); //look, you didn't need to write a DAO!
    }
}
```

备注：有一点一定需要了解哦，Spring Data JPA只是用来简化DAO层的开发，它并不是ORM框架哦，**像上面的例子中的ORM映射默认使用的是Hibernate框架**，因为我们引入的spring-data-jpa的依赖会默认引入Hibernate相关的依赖哦。

# Spring Data JPA中Repository接口及其子接口XXRepository的说明

（1）Repository

Repository接口是Spring Data的核心接口，该接口是一个空接口，没有声明任何的接口方法。其定义如下：

```java
public interface  Repository<T, ID extends Serializable>{}
```

（2）CrudRepository

CrudRepository继承了Repository接口，实现了CRUD相关的方法。

（3）PagingAndSortingRepository

PagingAndSortingRepository继承了CrudRepository接口，实现了分页排序相关的方法。

（4）JpaRepository

JpaRepository继承了PagingAndSortingRepository，实现了JPA规范相关的方法。

# Repository中方法名定义规则

在Repository中已经定了一些增删改查的方法，我们可以直接使用，不需要在Repository中定义或声明，如findOne、findAll以及delete等等。如果需要一些特殊的数据库操作需求，可以有两种方式，一种是Repository按照一定的规则声明一些方法名，Spring Data JPA会自动生成SQL语句，还有一种使用@query注解加上SQL语句来定制数据库操作需求。

（1）按一定规则来定义Repository中的方法名来满足定制化的数据库操作需求

在Repository中按照Spring Data JPA的规范来定义方法名，那么Spring Data JPA会根据方法名帮我们自动生成SQL语句。如下为具体的规则以及对应的SQL语句：

![](/images/java_springdata_1_3.png)

![](/images/java_springdata_1_4.png)

（2）使用@Query注解来实现复杂的数据库操作

使用@Query注解，就不需要按照上述的命名规则哦，方法名可以随意地定义，数据库的操作也可以根据需要来定义，是比较灵活的。使用@Query注解在工作中最常使用的方式。@Query annotation要注解到Repository的具体方法上即可。

（3）使用Query By Example技术

可以动态构造查询条件。

（4）使用Query By Specification技术

也是可以动态构造查询条件。

# JDBC/JPA/Spring-Data-JPA三者区别和联系

（1）JDBC是JDK中定义的数据驱动接口java.sql.Driver，但并没有具体的实现，具体的实现都是由不同的数据库厂商来提供的。主要是用在关系型数据库的场景。

（2）JPA是Java定义的ORM框架的规范，实现是Hibernate等产品。

（3）Spring Data JPA是对JPA ORM框架的进一步封装，让用户程序的DAO层开发更简单高效，只需要按照Spring Data JPA的规范书定义一些接口，然后Spring Data JPA会帮我们生产一些实现接口的具体方法。


参考资料来源于：
https://projects.spring.io/spring-data-jpa/
