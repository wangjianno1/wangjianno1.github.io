---
title: JAVA基础（5）_各种修饰符modifier
date: 2018-01-30 19:19:56
tags: JAVA基础
categories: JAVA
---

# 修饰符简介

像其他语言一样，Java可以使用修饰符来修饰类中方法和属性。比如在Java类中定义方法：

![](/images/java_syntax_5_1.png)

# JAVA中修饰符的类别

主要有两类修饰符如下：

（1）访问控制修饰符

a）default

即缺省，什么也不写，在同一包内可见，不使用任何修饰符。修饰目标有类、接口、变量、方法。

b）public

对所有类可见，修饰目标有类、接口、变量、方法。

c）protected

对同一包内的类和所有子类可见，修饰目标有变量、方法。 但是不能修饰类（外部类）。

d）private

在同一类内可见，修饰目标有变量、方法。 但是不能修饰类（外部类）。

（2）非访问控制修饰符

a）static

修饰方法，使之成为类方法/静态方法；修饰变量，使之成为类变量/静态变量。

b）final

修饰变量，使之成为常量；修饰方法，使之XXX；修饰类，使之XXX

c）abstract

修饰类，使之成为抽象类；修饰方法，使之成为抽象方法

d）synchronized

e）transient

f）volatile

