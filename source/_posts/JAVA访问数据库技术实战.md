---
title: JAVA访问数据库技术实战
date: 2019-03-04 19:59:10
tags:
categories: SSM/SSH
---

# 使用JDBC来访问数据库

```java
package com.bat.testmaven;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCTest {
    //JDBC驱动名及数据库URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/hostnames";
    //数据库的用户名与密码，需要根据自己的设置
    static final String USER = "root";
    static final String PASS = "test123";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        try {
            //注册JDBC驱动
            Class.forName("com.mysql.jdbc.Driver");
            //打开连接
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            //执行查询
            stmt = conn.createStatement();
            String sql = "SELECT * FROM record";
            ResultSet rs = stmt.executeQuery(sql);
            //展开结果集数据库
            while (rs.next()) {
                //通过字段检索
                int id = rs.getInt("id");
                String host = rs.getString("host");
                String destination = rs.getString("destination");
                //输出数据
                System.out.println("ID: " + id);
                System.out.println("host: " + host);
                System.out.println("destination: " + destination);
            }
            //完成后关闭
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException se) {
            //处理JDBC错误
            se.printStackTrace();
        } catch (Exception e) {
            //处理Class.forName错误
            e.printStackTrace();
        } finally {
            //关闭资源
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException se2) {
            } // 什么都不做
            try {
                if (conn != null)
                    conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
```

# 使用Spring Framework中的JDBC子模块来访问数据库（JdbcTemplate）

（1）在pom.xml中添加Spring JDBC的依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.hsqldb</groupId>
    <artifactId>hsqldb</artifactId>
    <scope>runtime</scope>
</dependency>
<!-- 数据库驱动的jar包依赖-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.45</version>
</dependency>
```

（2）在src/main/resources/application.properties中配置数据源

    spring.datasource.url=jdbc:mysql://127.0.0.1/hostnames
    spring.datasource.username=root
    spring.datasource.password=test123
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver

（3）编写Dao层，让Spring容器注入jdbcTemplete

```java
@Component
public class HostNameDaoImpl implements HostNameDao {
    @Autowired
    private final JdbcTemplate jdbcTemplate = null;
    
    @Override
    public int getRecordCount() {
        String q_sql = "select count(*) from record";
        int count = jdbcTemplate.queryForObject(q_sql, Integer.class);
        return count;
    }
}
```

（4）在sevice层直接使用Dao层实现类即可

备注：使用JdbcTemplate模式是没有对象关系映射ORM的功能。

# 使用Hibernate等符合JPA规范的ORM框架

参见[《Hibernate技术小结》](https://wangjianno1.github.io/2019/03/04/Hibernate%E6%8A%80%E6%9C%AF%E5%B0%8F%E7%BB%93/)

# 使用Spring Data JPA

参见[《Spring Data与Spring Data JPA技术小结》](https://wangjianno1.github.io/2019/03/04/Spring-Data%E4%B8%8ESpring-Data-JPA%E6%8A%80%E6%9C%AF%E5%B0%8F%E7%BB%93/)

