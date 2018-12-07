---
title: JAVA中枚举Enum的介绍和使用
date: 2018-12-07 15:12:46
tags: JAVA基础
categories: JAVA
---

# 枚举Enum类型简介

枚举类型是Java 5中新增特性的一部分，它是一种特殊的数据类型，之所以特殊是因为它既是一种类(class)类型却又比类类型多了些特殊的约束，但是这些约束的存在也造就了枚举类型的简洁性、安全性以及便捷性。

# 枚举的定义和使用

在没有枚举变量之前，开发者一般会按照如下的方式定义项目常量：

```java
class Week {
    public static final int MONDAY = 1;
    public static final int TUESDAY = 2;
    public static final int WEDNESDAY = 3;
    public static final int THURSDAY = 4;
    public static final int FRIDAY = 5;
    public static final int SATURDAY = 6;
    public static final int SUNDAY = 7;
}
```

有了枚举Enum类型之后，我们可以定义枚举来取代如上的方式，如下：

```java
enum Week {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

public class Test {
    public static void main(String[] args) {
        System.out.println(Week.FRIDAY instanceof Week); //Week.FRIDAY是Week的实例
        System.out.println(Week.FRIDAY.name()); //Week.FRIDAY.name()是实例的名称
    }
}
```

更复杂一点的定义和用法如下：

```java
enum Week {
    MONDAY("星期一", 1), TUESDAY("星期二", 2), WEDNESDAY("星期三", 3), THURSDAY("星期四", 4), FRIDAY("星期五", 5), SATURDAY("星期六", 6), SUNDAY("星期日", 7);
       
    private String name;
    private int num;
       
    private Week(String name, int num) {
        this.name = name;
        this.num = num;
    }

    public String getName() {
        return name;
    }

    public int getNum() {
        return num;
    }
}

public class Test {
    public static void main(String[] args) {
        System.out.println(Week.FRIDAY instanceof Week);
        System.out.println(Week.FRIDAY.name());
        System.out.println(Week.FRIDAY.getName());
        System.out.println(Week.FRIDAY.getNum());
    }
}
```

# 枚举类型实现的原理

实际上，在使用关键字enum创建枚举类型并编译后，编译器会为我们生成一个相关的类，这个类继承了Java API中的`java.lang.Enum`类，也就是说通过关键字enum创建枚举类型在编译后事实上也是一个类类型而且该类继承自`java.lang.Enum`类。
举例来说，我们新建Week.java文件，其中定义了Enum类型Week，如下：

```java
public enum Week {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}
```

然后使用javac编译Week.java文件后，生成Week.class文件，经过反编译后，我们发现Week.class的实际内容大概如下：

```java
final class Week extends Enum {
    // ..... 具体内容在此省略 .....
}
```
