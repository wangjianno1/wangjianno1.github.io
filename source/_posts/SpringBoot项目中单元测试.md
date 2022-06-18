---
title: SpringBoot项目中单元测试
date: 2019-03-04 14:41:23
tags:
categories: SpringBoot
---

# 引入Junit依赖

在SpringBoot项目中引入org.Junit测试框架的JAR依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <scope>test</scope>
</dependency>
```

备注：使用的单元测试框架是JUnit啦。

# 测试service层方法

（1）在src/test/java目录中新建service层package，如com.bat.sbdemo.service

（2）在com.bat.sbdemo.service包下新建service测试类，如下：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class StudentServiceTest {
    @Autowired
    private StudentService studentService;
       
    @Test
    public void testGetAllStudent() {
        List<Student> allStudent = studentService.getAllStudent();
        Assert.assertNotNull(allStudent);
    }
}
```

（3）使用Junit运行测试

在测试方法名或测试类上右键选择`Run As >> JUnit Test`菜单项，然后在Junit窗体中查看单元测试结果：

![](/images/springboot_test_1_1.png)

备注：绿条表示测试用例通过，红条表示测试用例失败。

# 测试controller层方法

（1）在src/test/java目录中新建service层package，如com.bat.sbdemo.controller

（2）在com.bat.sbdemo.controller包下新建controller测试类，如下：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class StudentControllerTest {
       
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testGetAllStudent() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/student/all")).andExpect(MockMvcResultMatchers.status().isOk());
    }
}
```

（3）使用Junit运行测试

在测试方法名或测试类上右键选择`Run As >> JUnit Test`菜单项，然后在Junit窗体中查看单元测试结果。

# Junit中Assert断言的使用

Junit框架包下的Assert提供了多个断言方法，主用于比较测试传递进去的两个参数。常用的断言方法如下：

```java
Assert.assertEquals(T expected, T actual)   //比较expected和actual值是否相等，可以是各种基础数据类型，也可以是抽象数据类型
Assert.assertNotEquals(T expected, T actual)

Assert.assertSame(T expected, T actual)   //比较expected和actual值在内存中是否是同一个对象， expected == actual
Assert.assertNotSame(T expected, T actual)


Assert.assertTrue(boolean condition)
Assert.assertFalse(boolean condition)

Assert.assertNull(Object object)
Assert.assertNotNull(Object object)

Assert.assertArrayEquals(Object[] expected, Object[] actual) // 比较数组，如果数组长度相同，且每个对应的元素相同，则两个数组相等，否则不相等

......
```

# 闲杂知识

（1）src/test/java目录下的package结构要和src/main/java下的package结构一样。被测试类要和测试类保持一一对应。

（2）测试类的命名是被测试类类名加上Test，如被测试类为StudentService，则测试类为StudentServiceTest。测试方法名是被测试方法名前加上test前缀，如被测试方法名为getAllStudent，则测试方法名为testGetAllStudent。

（3）在测试方法名上`Run As >> JUnit Test`，只会测试该测试用例。如果想运行整个SpringBoot项目的测试用例，可以在项目名或src/test/java上右键鼠标，选择`Run As >> JUnit Test`菜单项，那么就会运行整个项目的测试用例啦。

（4）在使用`maven package`打包等命令时，maven会自动运行整个项目的测试用例。若想在打包时，跳过单元测试，可以使用`maven package -Dmaven.test.skip=true`即可。
