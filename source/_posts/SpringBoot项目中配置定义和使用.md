---
title: SpringBoot项目中配置定义和使用
date: 2019-03-04 12:11:06
tags:
categories: SpringBoot
---

# application.properties配置的定义和读取

在SpringBoot项目中，`resources/application.properties`或`resources/application.yml`是项目核心的配置文件，这两个文件也是SpringBoot项目默认的配置文件。读取`application.properties/application.yml`有两种方法：

（1）Environment方式读取

框架中有一个org.springframework.core.env.Environment类，可以读取application.properties中配置的值。用法如下，我们可以看到直接将Environment注入进来，然后就可以使用getProperty方法来获取配置的值了， 参数是配置的名称。

```java
@RestController
public class ConfigController {
    @Autowired
    private Environment env;

    @RequestMapping("/config/{key:.+}")
    Object getConfig(@PathVariable String key) {
        return env.getProperty(key);
    }
}
```

（2）`@Value`注解方式读取

通过注解的方式将要读取的值映射到这个字段上面，然后就可以直接使用了。代码示例如下：

```java
@RestController
public class ConfigController {
    @Value("${server.context-path}")
    private String contextPath;

    @RequestMapping("/config/contextpath")
    Object getConfigContextPath() {
        return contextPath;
    }
}
```

# SpringBoot项目中自定义配置文件

`application.properties/application.yml`是SpringBoot项目缺省的核心配置，配置了一些框架相关的参数。当然，我们也可以将业务方面的配置写入到`application.properties/application.yml`中，但是一般来说我们不建议这么做，这个时候就需要自定义配置文件了。在没用SpringBoot开发框架之前，我们一般先创建一个独立的配置文件，然后在里面配置好值，用工具类去读取。当然也可以用Spring提供的PropertiesFactoryBean去读取。在SpringBoot项目中有了更方便的操作方式。具体方法如下：

（1）在`src/main/resources/config`中新建配置文件，如`src/main/resources/config/es.properties`，内容如下：

    es.index.url=http://10.16.20.97:9200/_cat/indices?h=index,docs.count,health,pri.store.size&format=json

（2）定义一个配置类，将配置文件中内容映射到JAVA对象中，如com.xxoo.admin.xxoologsys.config.ElasticSearchConfig，内容如下：

```java
@Component
@PropertySource("classpath:/config/es.properties")
@ConfigurationProperties(prefix = "es.index")
public class ElasticSearchConfig {
    private String url;
    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
}
```

备注：通过自测，将`@Component`修改成`@Configuration`也是可以的。另外，如果将自定义的属性配置放到application.properties中，那么上面的`@PropertySource("classpath:/config/es.properties")`注解是不需要的。

（3）在需要使用自定义配置的地方注入ElasticSearchConfig对象，代码如下：

```java
@RestController
public class TestController {
    @Autowired
    private ElasticSearchConfig esConfig;

    @RequestMapping("/test")
    @ResponseBody
    public String test() throws Exception {
        String url = esConfig.getUrl();
        return url;
    }
}
```

# SpringBoot项目中多环境配置

## SpringBoot项目在不同环境中的配置派生

在SpringBoot项目中，项目的配置缺省是放到`${PROJ_NAME}/src/main/resources/application.properties`文件中。在实际开发项目中，可能会存在开发环境、测试环境以及生产环境。不同的部署环境，应用的配置是不一样的。我们可以在`${PROJ_NAME}/src/main/resources/`目录中分别创建application.properties，application-dev.properties，application-test.properties以及application-prod.properties，分别代表不同环境下的特殊配置。其中application.properties也要创建哦，所有环境的公共配置可以放到这里啦。

## 多环境配置的生成方法

多环境配置的生成有如下几种方法：

（1）在application.properties文件中通过`spring.profiles.active=xxx`来说明使用什么环境的配置。若`spring.profiles.active=test`，表示使用application-test.properties中配置来运行项目。若直接运行`java -jar xxxx.jar`，则会根据application.properties中的`spring.profiles.active=xxx`来决定以什么环境来启动SpringBoot应用。

（2）在我们启动项目时，可以通过`java -jar xxxx.jar --spring.profiles.active=prod`来运行不同的环境。

（3）也可以通过虚拟机参数指定，即通过`java -jar xxxx.jar -Dspring.profiles.active=prod`来运行prod环境。

备注：在application.properties中配置的属性，会在所有环境中有效哦。当application.properties和application-xxx.properties中有重复的配置项时，application-xxx.properties中的属性会覆盖掉application.properties中配置。另外，这需要与Maven pom.xml中多环境配置的区别要注意下哦。

学习资料参考于：
[关于自定义配置](https://surpass-wei.github.io/2017/02/24/spring-boot1.5%E4%BB%A5%E4%B8%8A%E7%89%88%E6%9C%AC@ConfigurationProperties%E5%8F%96%E6%B6%88location%E6%B3%A8%E8%A7%A3%E5%90%8E%E7%9A%84%E6%9B%BF%E4%BB%A3%E6%96%B9%E6%A1%88/)
