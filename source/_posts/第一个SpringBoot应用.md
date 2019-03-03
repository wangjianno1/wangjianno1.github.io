---
title: 第一个SpringBoot应用
date: 2019-03-04 00:38:12
tags:
categories: SpringBoot
---

# SpringBoot HelloWorld工程

（1）在Eclipse新建Maven Project，选择“maven-archetype-quickstart”新建一个Maven初始化工程。

（2）在pom.xml中引入SpringBoot的依赖，如下：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.9.RELEASE</version>
</parent>
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

（3）在Eclipse工程上右击，选择`Maven | Update Maven...`来刷新工程并下载依赖的jar包

（4）在`${PROJ_NAME}/src/main/java/xxx-package-name`中新建一个controller的Class（`com/sohu/sysadmin/sgwlogsys/SampleController.java`），内容如下：

```java
package com.sohu.sysadmin.sgwlogsys;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;

@Controller
@EnableAutoConfiguration
public class SampleController {
    @RequestMapping("/index")
    @ResponseBody
    String index() {
        return "Hello World!";
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(SampleController.class, args);
    }
}
```

（5）启动SpringBoot应用

在controller中，右键选择`Run AS Java Application`，该操作会在本地启动一个HTTP端口，默认为8080.  SpringBoot应用启动日志如下：

![](/images/springboot_fristapp_1_1.png)

（6）访问测试

在浏览器中输入`http://127.0.0.1:8080/index`即可访问到页面。
