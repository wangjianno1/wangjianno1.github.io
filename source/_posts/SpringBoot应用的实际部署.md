---
title: SpringBoot应用的实际部署
date: 2019-03-04 11:56:09
tags:
categories: SpringBoot
---

# 将SpringBoot应用直接打成jar包，直接运行

（1）在项目的pom.xml添加spring-boot-maven-plugin插件，该插件会将SpringBoot项目本身及其依赖打包成一个可以独立运行的jar包，如下：

```xml
<build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
</build>
```

（2）在Eclipse工程右击，选择`Run As Maven build`，然后在Goals中输入`clean package`，并执行。执行后会在`${PROJ_NAEM}/target`目录下生成一个jar包文件。

（3）将jar拷贝到部署环境，直接执行`java -jar xxx-0.0.1.jar`

（4）通过`http://ip:port/index`即可访问

# 将SpringBoot应用部署到Jetty/Tomcat容器

在pom.xml配置文件中，将packaging修改为war，然后右键Eclipse项目，选择`Run As Maven build...`，在Goals输入框中输入`clean package`并运行，即可生成war包。再将生成的war包部署到Jetty或Tomcat Servlet容器中即可（其实这里打包生成的war包，是可执行的war包，即通过`java -jar ***.war`启动即可，但是不能直接部署到独立的tomcat/jetty容器中）。

非常重要的一点的是，若要将war部署在单独的tomcat/jetty等Servlet容器时，一定要让SpringBoot的启动类继承SpringBootServletInitializer类，并实现configure方法，效果如下：

```java
@SpringBootApplication
public class Application extends SpringBootServletInitializer { 
    @Override  
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {  
        return application.sources(Application.class);  
    }
    
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

然后再打包成war包部署到tomcat/jetty容器中即可。如我们打完的war包名称为wahaha-0.0.1-SNAPSHOT.war，将war包拷贝到容器的webapps目录中并启动tomcat/jetty容器。然后在浏览器输入`http://127.0.0.1:8080/wahaha-0.0.1-SNAPSHOT/api/test`即可访问。若将wahaha-0.0.1-SNAPSHOT.war重命名为ROOT.war后，可以直接在浏览器中输入`http://127.0.0.1:8080/api/test`进行访问。

备注：**这里之所以继承SpringBootServletInitializer并实现configure方法，相当于在web.xml中增加了Servlet的配置**。
