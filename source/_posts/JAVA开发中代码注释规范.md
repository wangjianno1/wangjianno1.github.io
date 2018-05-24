---
title: JAVA开发中代码注释规范
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
