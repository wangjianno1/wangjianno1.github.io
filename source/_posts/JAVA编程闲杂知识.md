---
title: JAVA编程闲杂知识
date: 2018-01-31 00:25:20
tags: JAVA基础
categories: JAVA
---

# Java中字符串比较

双等号`str1 == str2`表示比较两个字符串对象是否在内存中是同一个。`str1.equals(str2)`表示比较两个字符串的内容是否一样。

```java
String str1 = "Lee";
String str2 = "Lee";
str1 == str2        // true，因为他们在内存中是同一个对象。正常来说，它们不相等才对的啊，实际上Java在对字符串常量初始化时，先看内存中是否已经有了字符串字面值常量，若已经有了，就直接将引入传给该字符串变量。在本例中，当定义字符串变量str2时，发现字符串字面值常量"Lee"在内存中已经存在了，因此将该引用直接赋值给str2啦，因此在JVM内存中，str1和str2其实是指向同一块内存
str1.equals(str2)   // true，因为str1和str2的字符串内容是一样的

String str1 = new String("Lee");
String str2 = new String("Lee");
str1 == str2        // false，因为他们在内存中不是同一个对象
str1.equals(str2)   // true，因为str1和str2的字符串内容是一样的
```

备注：`equals()`函数默认是用来比较两个对象的引用是否一样的，而在String类中应该是被覆写了，用来比较对象的内容是否一样啦。

# Java中问号表达式

```java
var = A ? B : C  // 如果A为真，返回B，否则返回C
```
