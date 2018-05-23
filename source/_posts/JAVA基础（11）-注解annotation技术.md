---
title: JAVA基础（11）_注解annotation技术
date: 2018-01-30 23:54:37
tags: JAVA基础
categories: JAVA
---

# annotation注解简介

注解是JDK1.5新增新技术。很多框架为了简化代码，都会提供一些注解。可以理解为插件，是代码级别的插件，在类的方法上写@XXX，就是在代码上插入了一个插件。注解不会也不能影响代码的实际逻辑，仅仅起到辅助性的作用。

注解分为内置注解（也称为元注解，JDK自带注解）和自定义注解（各种框架自带的注解或用户自定义的注解）。

备注：需要注意的是，注解本身做不了任何事情，和XML一样，只起到配置的作用。而主要在于背后的处理器 ，也就是注解使用方的解析和处理逻辑。

# JAVA语言内置的元注解

JAVA内置了三种标准注解和四种元注解。

三种标准注解如下：

（1）@Override

表示当前的方法定义将覆盖超类中的方法。如果不小心拼写错误，或者方法签名对不上被覆盖的方法，编译器就会发出错误提示。

（2）@Deprecated

如果程序员使用了被@Deprecated注解的元素，编译器会发出警告信息。

（3）@SuppressWarnings

使用@SuppressWarnings可以关闭不当的编译器警告信息。举例来说：

- 抑制单类型的警告，如`@SuppressWarnings("unchecked")`表示只抑制无检查的警告
- 抑制多类型的警告，如`@SuppressWarnings(value={"unchecked", "rawtypes"})`表示抑制无检查和rawtypes的警告
- 抑制所有类型的警告，即使用`@SuppressWarnings("all")`表示抑制所有的告警

备注：还有其他很多种的警告类型，如unused、restriction以及deprecation等等。

JAVA还提供了四种元注解，专门用来的负责创建新注解的注解。如下：

（1）@Target

@Target表示该注解可以用于什么地方，可能的ElementType参数包括，

```
CONSTRUCTOR：构造器的声明
FIELD：域声明
LOCAL_VARIABLE：局部变量声明
METHOD：方法声明
PACKAGE：包声明
PARAMETER：参数声明
TYPE：类、接口或enum声明
```

（2）@Retention

表示在什么级别下保存该注解信息，可选的RetentionType参数有：

```
SOURCE：只在源代码阶段保存注解信息。代码编译时，注解会被编译器丢弃
CLASS：在class字节码阶段依然保存注解信息。代码执行时，会被JVM丢弃
RUNTIME：JVM在代码运行期也保留注解，因此可以通过反射机制读取注解的信息
```

（3）@Documented

将此注解包含在JAVA DOC文档中。

（4）Inherited

允许子类继承父类中的注解。

# 自定义注解

如下定义了一个名称为WaHaHa的注解（使用@interface关键字）：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface WaHaHa {
}
```
