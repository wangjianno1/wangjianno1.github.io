---
title: SpringBoot整合MyBatis访问RDBMS
date: 2019-03-04 12:27:07
tags:
categories: SpringBoot
---

# 引入MyBatis依赖

在SpringBoot中引入MyBatis的JAR包依赖，

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.1.1</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

该JAR包是MyBatis开发出来用来集成SpringBoot项目的MyBatis依赖JAR包，有了这个JAR包，在SpringBoot项目中使用MyBatis就好用多了。mybatis-spring-boot-starter在SpringBoot项目中主要有两种开发配置方案，一种是使用注解解决一切问题，一种是简化XML后的传统方式。两种方式各有特点，注解版适合简单快速的模式，非常适合现在流行的微服务架构模式。XML传统模式比适合大型项目，可以灵活的动态生成SQL，方便调整SQL，也有痛痛快快，洋洋洒洒的写SQL的感觉。

# 使用注解的方式

（1）在application.properties中添加如下配置

    mybatis.type-aliases-package=com.bat.entity
    spring.datasource.driverClassName = com.mysql.jdbc.Driver
    spring.datasource.url = jdbc:mysql://127.0.0.1:3306/testtable?useUnicode=true&characterEncoding=utf-8
    spring.datasource.username = sbdemo
    spring.datasource.password = sbdemo

SpringBoot会自动加载`spring.datasource.*`相关配置，数据源就会自动注入到sqlSessionFactory中，sqlSessionFactory会自动注入到Mapper中。

（2）在启动类中添加对mapper包扫描@MapperScan

```java
@SpringBootApplication
@MapperScan("com.bat.mapper")
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

或者直接在Mapper类上面添加注解@Mapper，建议使用第一种，不然每个Mapper类都需要加个@Mapper注解，也是比较麻烦的。

（3）开发Mapper类

```java
public interface UserMapper {
    @Select("SELECT * FROM users")
    @Results({
        @Result(property = "userSex",  column = "user_sex", javaType = UserSexEnum.class),
        @Result(property = "nickName", column = "nick_name")
    })
    List<UserEntity> getAll();

    @Select("SELECT * FROM users WHERE id = #{id}")
    @Results({
        @Result(property = "userSex",  column = "user_sex", javaType = UserSexEnum.class),
        @Result(property = "nickName", column = "nick_name")
    })
    UserEntity getOne(Long id);

    @Insert("INSERT INTO users(userName,passWord,user_sex) VALUES(#{userName}, #{passWord}, #{userSex})")
    void insert(UserEntity user);

    @Update("UPDATE users SET userName=#{userName},nick_name=#{nickName} WHERE id =#{id}")
    void update(UserEntity user);

    @Delete("DELETE FROM users WHERE id =#{id}")
    void delete(Long id);
}
```

其中，

    @Select是查询类的注解，所有的查询均使用这个
    @Result修饰返回的结果集，关联实体类属性和数据库字段一一对应，如果实体类属性和数据库属性名保持一致，就不需要这个属性来修饰
    @Insert插入数据库使用，直接传入实体类会自动解析属性到对应的值
    @Update负责修改，也可以直接传入对象
    @delete负责删除

（4）在Service层直接注入Mapper类，然后是用Mapper类来对数据进行操作

```java
@Autowired
private UserMapper UserMapper;
public void addSomeUsers() throws Exception {
    UserMapper.insert(new UserEntity("aa", "a123456", UserSexEnum.MAN));
    UserMapper.insert(new UserEntity("bb", "b123456", UserSexEnum.WOMAN));
    UserMapper.insert(new UserEntity("cc", "b123456", UserSexEnum.WOMAN));
}
```

# 使用简化XML配置的方式

简化XML版本保持映射文件的老传统，优化主要体现在不需要实现DAO的是实现层，系统会自动根据方法名在映射文件中找对应的SQL。

（1）在application.properties中添加如下配置

    mybatis.type-aliases-package=com.bat.entity
    spring.datasource.driverClassName = com.mysql.jdbc.Driver
    spring.datasource.url = jdbc:mysql://127.0.0.1:3306/testtable?useUnicode=true&characterEncoding=utf-8
    spring.datasource.username = sbdemo
    spring.datasource.password = sbdemo
    mybatis.config-locations=classpath:mybatis/mybatis-config.xml
    mybatis.mapper-locations=classpath:mybatis/mapper/*.xml

（2）新增MyBatis配置文件mybatis-config.xml

```xml
<configuration>
    <typeAliases>
        <typeAlias alias="Integer" type="java.lang.Integer" />
        <typeAlias alias="Long" type="java.lang.Long" />
        <typeAlias alias="HashMap" type="java.util.HashMap" />
        <typeAlias alias="LinkedHashMap" type="java.util.LinkedHashMap" />
        <typeAlias alias="ArrayList" type="java.util.ArrayList" />
        <typeAlias alias="LinkedList" type="java.util.LinkedList" />
    </typeAliases>
</configuration>
```

备注：这里还可以添加一些MyBatis基础的配置。

（3）添加User的映射文件

```xml
<mapper namespace="com.bat.mapper.UserMapper" >
    <resultMap id="BaseResultMap" type="com.bat.entity.UserEntity" >
        <id column="id" property="id" jdbcType="BIGINT" />
        <result column="userName" property="userName" jdbcType="VARCHAR" />
        <result column="passWord" property="passWord" jdbcType="VARCHAR" />
        <result column="user_sex" property="userSex" javaType="com.bat.enums.UserSexEnum"/>
        <result column="nick_name" property="nickName" jdbcType="VARCHAR" />
    </resultMap>
    <sql id="Base_Column_List" >
        id, userName, passWord, user_sex, nick_name
    </sql>
    <select id="getAll" resultMap="BaseResultMap"  >
       SELECT
       <include refid="Base_Column_List" />
       FROM users
    </select>
    <select id="getOne" parameterType="java.lang.Long" resultMap="BaseResultMap" >
        SELECT
       <include refid="Base_Column_List" />
       FROM users
       WHERE id = #{id}
    </select>
    <insert id="insert" parameterType="com.bat.entity.UserEntity" >
       INSERT INTO
            users
            (userName,passWord,user_sex)
        VALUES
            (#{userName}, #{passWord}, #{userSex})
    </insert>
    <update id="update" parameterType="com.bat.entity.UserEntity" >
       UPDATE
            users
       SET
        <if test="userName != null">userName = #{userName},</if>
        <if test="passWord != null">passWord = #{passWord},</if>
        nick_name = #{nickName}
       WHERE
            id = #{id}
    </update>
    <delete id="delete" parameterType="java.lang.Long" >
       DELETE FROM
             users
       WHERE
             id =#{id}
    </delete>
</mapper>
```

（4）编写Dao层的代码

```java
public interface UserMapper {
    List<UserEntity> getAll();
    UserEntity getOne(Long id);
    void insert(UserEntity user);
    void update(UserEntity user);
    void delete(Long id);
}
```

（5）在Service层直接注入Mapper类，然后是用Mapper类来对数据进行操作

同第一种方式。

学习资料参考于：
http://www.ityouknow.com/springboot/2016/11/06/spring-boo-mybatis.html
