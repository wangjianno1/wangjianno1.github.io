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

# Java中字符串比较

双等号`str1 == str2`表示比较两个字符串对象是否在内存中时同一个。`str1.equals(str2)`表示比较两个字符串的内容是否一样。

```java
String str1 = "Lee";
String str2 = "Lee";
str1 == str2        // true，因为他们在内存中是同一个对象
str1.equals(str2)   // true，因为str1和str2的字符串内容是一样的

String str1 = new String("Lee");
String str2 = new String("Lee");
str1 == str2        // false，因为他们在内存中不是同一个对象
str1.equals(str2)   // true，因为str1和str2的字符串内容是一样的
```
