---
title: SpringBoot项目中访问关系型数据库
date: 2019-03-04 12:21:00
tags:
categories: SpringBoot
---

# JdbcTemplate

（1）引入JdbcTemplate相关的jar包依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

（2）定义数据源DataSource，在application.properties中添加如下配置

    spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.datasource.url=jdbc:mysql://127.0.0.1:3306/sbdemo
    spring.datasource.username=sbdemo
    spring.datasource.password=sbdemo

（3）定义与数据库表对应的POJO实体类

```java
public class Student {
    private Integer id;
    private String name;
    private Integer age;
    private String sex;
    private Integer score;
    
    public Student() {
    }
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
    public String getSex() {
        return sex;
    }
    public void setSex(String sex) {
        this.sex = sex;
    }
    public Integer getScore() {
        return score;
    }
    public void setScore(Integer score) {
        this.score = score;
    }
}
```

（4）编写Dao层类

```java
@Repository
public class StudentDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;  //直接注入JdbcTemplate模板类

    public List<Student> getAllStudent() {
        String sql = "select * from student";
        List<Student> allStudents = jdbcTemplate.query(sql, new RowMapper<Student>(){
            @Override
            public Student mapRow(ResultSet rs, int rowNum) throws SQLException {
                Student stu = new Student();
                stu.setId(rs.getInt("id"));
                stu.setName(rs.getString("name"));
                stu.setAge(rs.getInt("age"));
                stu.setSex(rs.getString("sex"));
                stu.setScore(rs.getInt("score"));
                return stu;
            }
                     
        });
        return allStudents;
    }
}
```

（5）在service业务逻辑层直接注入Dao层类，并使用Dao层类的方法。

# Spring Data JPA

使用Spring Data JPA子项目来访问关系型数据库，需要引入spring-boot-starter-data-jpa依赖，该依赖会引入如下核心JAR包：

    Hibernate
    Spring Data JPA
    Spring ORMs

所以说，在SpringBoot项目中使用Spring Data JPA，使用到的JPA ORM框架是Hibernate。

（1）引入Spring Data JPA相关的jar包依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

（2）定义数据源DataSource，在application.properties中添加如下配置

    spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.datasource.url=jdbc:mysql://127.0.0.1:3306/sbdemo
    spring.datasource.username=sbdemo
    spring.datasource.password=sbdemo
     
    spring.jpa.hibernate.ddl-auto=update
    spring.jpa.show_sql=true

（3）依据JPA的规范定义Entity类

```java
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
@Entity
public class Student {
    @Id
    @GeneratedValue
    private Integer id;
    private String name; 
    private Integer age;
    private String sex;
    private Integer score;

    public Student() {
    }
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
    public String getSex() {
        return sex;
    }
    public void setSex(String sex) {
        this.sex = sex;
    }
    public Integer getScore() {
        return score;
    }
    public void setScore(Integer score) {
        this.score = score;
    } 
}
```

（4）编写Repository层接口

```java
public interface StudentRepository extends JpaRepository<Student, Integer> {
}
```

备注：Repository层只需要定义一个继承自Repository/JpaRepository/CrudRepository相关接口的接口即可，该接口中不需要声明任何方法，除非你有特殊的数据库操作，在默认的Repository/JpaRepository/CrudRepository接口中不支持。另外，如果有非常复杂的数据库操作，那么可以在Repository层接口类中声明一个方法，且在该方法上使用@Query注解，该@Query注解的参数就是需要操作的SQL语句。使用@Query注解的代码举例如下：

```java
@Query("FROM IpInfo i " +
       "LEFT JOIN FETCH i.machine im " +
       "WHERE i.ipNum =:ipNum"
) 
public List<IpInfo> getIpInfoByIpNumOnlyMachine(@Param("ipNum") Long ipNum);
```

（5）在service业务逻辑层直接注入Repository层接口作为Bean，并调用其中的方法来实现数据库的操作。

# SpringBoot整合MyBatis

参见文章[《SpringBoot整合MyBatis访问RDBMS》](https://wangjianno1.github.io/2019/03/04/SpringBoot%E6%95%B4%E5%90%88MyBatis%E8%AE%BF%E9%97%AERDBMS/)
