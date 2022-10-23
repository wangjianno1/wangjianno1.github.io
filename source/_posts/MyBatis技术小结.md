---
title: MyBatis技术小结
date: 2019-03-04 22:43:00
tags:
categories: SSM/SSH
---

# MyBatis简介

MyBatis本是Apache的一个开源项目iBatis，2010年这个项目由Apache Software Foundation迁移到了Google Code，并且改名为MyBatis。iBATIS一词来源于“internet”和“abatis”的组合，是一个基于Java的持久层框架。iBATIS提供的持久层框架包括SQL Maps和Data Access Objects（DAO）。MyBatis是iBatis的升级版，用法有很多的相似之处，但是MyBatis进行了重要的改进。

MyBatis是一款优秀的持久层框架，它支持定制化SQL、存储过程以及高级映射。MyBatis避免了几乎所有的JDBC代码和手动设置参数以及获取结果集。MyBatis可以使用简单的XML或注解来配置和映射原生信息，将接口和Java的POJOs（Plain Old Java Objects，普通的 Java对象）映射成数据库中的记录。

备注：Hibernate比较重，Mybatis比较轻，简单易用。

# MyBatis的架构和原理

MyBatis的架构图如下：

![](/images/java_mybatis_1_1.png)

MyBatis应用程序根据XML配置文件创建SqlSessionFactory，SqlSessionFactory再根据配置，配置来源于两个地方，一处是配置文件，一处是Java代码的注解，获取一个SqlSession。SqlSession包含了执行sql所需要的所有方法，可以通过SqlSession实例直接运行映射的SQL语句，完成对数据的增删改查和事务提交等，用完之后关闭SqlSession。

# MyBatis框架中的一些基础框架

    SqlSessionFactoryBuilder
    SqlSessionFactory
    SqlSession()
    Mapper

# MyBatis使用

（1）引入Maven依赖

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>x.x.x</version>
</dependency>
```

（2）编写mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <environments default="development">
    <environment id="development">
      <transactionManager type="JDBC"/>
      <dataSource type="POOLED">
        <property name="driver" value="${driver}"/>
        <property name="url" value="${url}"/>
        <property name="username" value="${username}"/>
        <property name="password" value="${password}"/>
      </dataSource>
    </environment>
  </environments>
  <mappers>
    <mapper resource="com/bat/BlogMapper.xml"/>
  </mappers>
</configuration>
```

（3）编写实体类

比如实体类Blog，如下：

```java
public class Blog {
    private int id;
    private String title;
    private String content;

    public Blog(int id, String title, String content) {
        this.id = id;
        this.title = title;
        this.content = content;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
```

备注：在MyBatis中定义实体类时，好像就不需要JPA中的@Entity/@Table/@Column等等注解，待确认一下哦？？

（4）编写SQL到实体类的映射配置Mapper文件

比如BlogMapper.xml文件内容如下：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.bat.BlogMapper">
  <select id="selectBlog" resultType="Blog">
    select * from Blog where id = #{id}
  </select>
</mapper>
```

备注：这里`id="selectBlog"`是给这条SQL语句命个名字，然后就可以在代码中调用，从而执行这条SQL语句。

（5）编写Mapper接口

如BlogMpper.java的文件内容如下：

```java
public interface BlogMapper {
  Blog selectBlog(int id);
}
```

需要特别注意的是，MyBatis也支持使用注解代替xml Mapper文件方法，若定义Mapper接口时，在接口的方法使用MyBatis的一些注解来定义SQL语句，则第（4）步骤定义xml Mapper配置文件可以省略掉，举例如下：

```java
public interface BlogMapper {
  @Select("SELECT * FROM blog WHERE id = #{id}")
  Blog selectBlog(int id);
}
```

（6）生成SqlSessionFactory

```java
String resource = "org/mybatis/mybatis-config.xml";
InputStream inputStream = Resources.getResourceAsStream(resource);
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
```

（7）获取数据库SqlSession并进行CRUD操作

```java
try (SqlSession session = sqlSessionFactory.openSession()) {
  BlogMapper mapper = session.getMapper(BlogMapper.class);
  Blog blog = mapper.selectBlog(101);
}
```

# MyBatis优势

相对于JPA/Hibernate来说，MyBatis主要优势有：

    SQL语句可以自由控制，更灵活，性能较高
    SQL与代码分离，易于阅读和维护
    提供XML标签，支持编写动态SQL语句

相对于MyBatis来说，JPA/Hibernate主要优势有：

    JPA移植性比较好（JPQL），若换了底层数据库，不用修改代码，只需修改一些数据库的配置信息即可
    提供了更多的CRUD方法，开发效率高
    对象化程度更高

学习资料参考于：
http://www.mybatis.org/mybatis-3/zh/index.html
