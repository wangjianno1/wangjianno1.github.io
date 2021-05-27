---
title: JAVA开发中一些日常编程规范
date: 2018-05-24 15:23:26
tags: JAVA基础
categories: JAVA
---

# 类注释

在import之后，class声明之前进行注释，格式如下：

```java
/**
 * 这个类是用来产生随机数
 * @author  zhangsan
 * @author  lisi
 * @see     java.lang.Object#toString()
 * @see     java.lang.StringBuffer
 * @version   1.2
 */
public class RandomNum {
}
```

# 方法注释

在方法定义之前进行注释说明，格式如下：

```java
public class RandomNum {
    /**
     * 该方法用来生成随机数
     * @param num The value to be squared. 
     * @return num squared. 
     */
    public String genRandomNum(double num) {
        return num * num;
    }
}
```

# 命名约定

Java中类名，方法名等使用的命名风格是“驼峰式”规范。

- 包名

包名全部小写，连续的单词只是简单地连接起来，不使用下划线。

```
com.baidu.ai.autodriven
com.sina.webo.as
```

- 类名

类名都以`UpperCamelCase`风格编写。类名通常是名词或名词短语，接口名称有时可能是形容词或形容词短语。现在还没有特定的规则或行之有效的约定来命名注解类型。

测试类的命名以它要测试的类的名称开始，以Test结束。例如，HashTest或HashIntegrationTest。

- 方法名

方法名都以`lowerCamelCase`风格编写。方法名通常是动词或动词短语。

- 常量名

常量名命名模式为`CONSTANT_CASE`，全部字母大写，用下划线分隔单词。

- 非常量字段名

非常量字段名以`lowerCamelCase`风格编写。这些名字通常是名词或名词短语。

- 参数名

参数名以`lowerCamelCase`风格编写。参数应该避免用单个字符命名。

- 局部变量名

局部变量名以`lowerCamelCase`风格编写，比起其它类型的名称，局部变量名可以有更为宽松的缩写。
