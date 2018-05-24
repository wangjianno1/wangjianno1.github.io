---
title: JAVA中Lambda表达式（匿名函数）
date: 2018-05-24 15:21:17
tags: JAVA基础
categories: JAVA
---

Lambda表达式是Java 8的重要更新，也是一个被广大开发者期待的特性。Lambda表达式支持将代码作为方法参数，Lambda表达式允许使用更简介的代码来创建只有一个抽象方法的接口（这种接口被称为函数式接口）的实例。

Lambda表达式是一种匿名函数（对 Java 而言这并不完全正确，但现在姑且这么认为），简单地说，它是没有声明的方法，也即没有访问修饰符、返回值声明和名字。开发者可以将其当做一种速记，在你需要使用某个方法的地方写上它。当某个方法只使用一次，而且定义很简短，使用这种速记替代之尤其有效，这样，你就不必在类中费力写声明与方法了。

由于Lambda表达式的结果就是被当成对象，因此程序中完全可以使用Lambda表达式进行赋值。

Java中的Lambda表达式通常使用`(argument) -> (body)`语法书写，例如：

```
(arg1, arg2...) -> { body }
(type1 arg1, type2 arg2...) -> { body }
```

以下是一些 Lambda 表达式的例子：

```java
(int a, int b) -> { return a + b; }
() -> System.out.println("Hello World");
(String s) -> { System.out.println(s); }
() -> 42
() -> { return 3.1415 };
```
