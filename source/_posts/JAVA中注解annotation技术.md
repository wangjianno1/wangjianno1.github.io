---
title: JAVA中注解annotation技术
date: 2018-01-30 23:54:37
tags: JAVA基础
categories: JAVA
---

# annotation注解简介

注解是JDK1.5新增新技术。很多框架为了简化代码，都会提供一些注解。可以理解为插件，是代码级别的插件，在类的方法上写@XXX，就是在代码上插入了一个插件。注解不会也不能影响代码的实际逻辑，仅仅起到辅助性的作用。

注解其实就是一种标记，可以在程序代码中的关键节点（类、方法、变量、参数、包）上打上这些标记，然后程序在编译时或运行时可以检测到这些标记从而执行一些特殊操作。因此可以得出自定义注解使用的基本流程：

    （1）定义注解——相当于定义标记
    （2）配置注解——把标记打在需要用到的程序代码中
    （3）解析注解——在编译期或运行时检测到标记，并进行特殊操作

注解分为内置注解（也称为元注解，JDK自带注解）和自定义注解（各种框架自带的注解或用户自定义的注解）。

备注：需要注意的是，注解本身做不了任何事情，和XML一样，只起到配置的作用。而主要在于背后的处理器 ，也就是注解使用方的解析和处理逻辑。

# JAVA语言内置的元注解

JAVA内置了三种标准注解和四种元注解。

三种标准注解如下：

（1）`@Override`

表示当前的方法定义将覆盖超类中的方法。如果不小心拼写错误，或者方法签名对不上被覆盖的方法，编译器就会发出错误提示。

（2）`@Deprecated`

如果程序员使用了被@Deprecated注解的元素，编译器会发出警告信息。

（3）`@SuppressWarnings`

使用@SuppressWarnings可以关闭不当的编译器警告信息。举例来说：

- 抑制单类型的警告，如`@SuppressWarnings("unchecked")`表示只抑制无检查的警告
- 抑制多类型的警告，如`@SuppressWarnings(value={"unchecked", "rawtypes"})`表示抑制无检查和rawtypes的警告
- 抑制所有类型的警告，即使用`@SuppressWarnings("all")`表示抑制所有的告警

备注：还有其他很多种的警告类型，如unused、restriction以及deprecation等等。

JAVA还提供了四种元注解，专门用来的负责创建新注解的注解。如下：

（1）`@Target`

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

（2）`@Retention`

表示在什么级别下保存该注解信息，可选的RetentionType参数有：

```
SOURCE：只在源代码阶段保存注解信息。代码编译时，注解会被编译器丢弃
CLASS：在class字节码阶段依然保存注解信息。代码执行时，会被JVM丢弃
RUNTIME：JVM在代码运行期也保留注解，因此可以通过反射机制读取注解的信息
```

（3）`@Documented`

将此注解包含在JAVA DOC文档中。

（4）`@Inherited`

允许子类继承父类中的注解。

# annotation作用

（1）编译检查

具有“让编译器进行编译检查的作用”。例如，@SuppressWarnings，@Deprecated和@Override都具有编译检查作用。

（2）在反射中使用annotation

在反射的Class/Method/Field中的函数中，有许多关于annotation相关的接口。这也意味着，我们可以在反射中解析并使用annotation，这一块很重要，很多annotation的功能就通过反射来实现。

（3）根据annotation生成帮助文档

通过给annotation注解加上@Documented标签，能使该annotation标签出现在javadoc中。

# 自定义注解

注解使用@interface关键字来声明。在底层实现上，所有定义的注解都会自动继承java.lang.annotation.Annotation接口。根据我们日常定义类或接口的经验，在类中无非是要定义构造方法、属性或一般方法。但是，在自定义注解中，其只能定义一个东西，注解类型元素（annotation type element），当然不需要的话，也可以不定义。

如下定义了一个名称为WaHaHa的注解（没有注解类型元素）：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface WaHaHa {
}
```

如下定义了一个名称为WaHaHa2的注解（定义了name/age/hobbies/address四个注解类型元素）：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface WaHaHa2 {
    String name();
    int age();
    String[] hobbies();
    String address() default "China";
}
```

关于注解类型元素的语法很奇怪，如下一些点补充：

（1）注解类型元素的语法非常奇怪，即又有属性的特征（可以赋值），又有方法的特征（打上了一对括号）。但是这么设计是有道理的，因为注解在定义好了以后，使用的时候操作元素类型像在操作属性，解析的时候操作元素类型像在操作方法。

（2）注解类型元素的类型只能是基本数据类型、String、Class、枚举类型、注解类型（体现了注解的嵌套效果）以及上述类型的一位数组。

（3）注解类型元素的名称一般定义为名词，如果注解中只有一个注解类型元素，请把名字起为value（后面使用会带来便利操作，可以直接使用`@注解名(注解值)`，其等效于`@注解名(value = 注解值)`），若value有默认值，且没有其它注解类型元素时，那么在使用注解的时候，可以直接`@注解名`。

（4）注解类型元素后面的()不是定义方法参数的地方，也不能在括号中定义任何参数，仅仅只是一个特殊的语法。

（5）default代表默认值，值必须和第2点定义的类型一致。有了默认值时，我们在注解的时候，可以不用再给属性赋值，使用默认的即可，当然赋值也没问题。

（6）如果注解类型元素没有默认值，代表后续使用注解时必须给该类型元素赋值。
