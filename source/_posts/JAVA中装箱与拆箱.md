---
title: JAVA中装箱与拆箱
date: 2018-12-07 15:12:32
tags: JAVA基础
categories: JAVA
---

# 自动装箱与自动拆箱

自动装箱就是Java自动将基础数据类型的值转换成对应的对象，比如将int的变量转换成Integer对象，这个过程叫做装箱。反之将Integer对象转换成int类型值，这个过程叫做拆箱。因为这里的装箱和拆箱是自动进行的，而非人为转换，所以就称作为自动装箱和拆箱。

简单一点来说，装箱就是自动将基本数据类型转换为包装器类型。拆箱就是自动将包装器类型转换为基本数据类型。如下是一些需要装箱拆箱的类型：

![](/images/java_box_1_1.png)

![](/images/java_box_1_2.png)

# 案例说明

```java
public class Main {
    public static void main(String[] args) {
        // 自动装箱
        Integer total = 99;
        // 自定拆箱
        int totalprim = total;
}
```

备注：当执行`Integer total = 99`这句代码时，其实JVM为我们执行了`Integer total = Integer.valueOf(99)`。当执行`int totalprim = total`这句代码时，其实JVM为我们执行了`int totalprim = total.intValue()`。
