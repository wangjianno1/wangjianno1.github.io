---
title: JAVA编程闲杂知识
date: 2018-01-31 00:25:20
tags: JAVA基础
categories: JAVA
---

# 省略花括号

当if或for控制语句的执行体，只有一行时，可以省略花括号。如下写法都是可以的：

```java
public static void testfunc() {
    for(int i = 0; i < 5; i++) System.out.println("aaaaa");
    for (int i = 0; i < 5; i++)
        System.out.println("aaaaa");
        
    int a = 3;
    if (a > 1) System.out.println("bbbbb");
    if (a > 1)
        System.out.println("bbbbb");
}
```
