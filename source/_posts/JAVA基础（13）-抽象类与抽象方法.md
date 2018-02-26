---
title: JAVA基础（13）_抽象类与抽象方法
date: 2018-01-31 00:06:08
tags: JAVA基础
categories: JAVA
---

# 抽象方法

在Java语言中，abstract关键字修饰的方法称为抽象方法，抽象方法只包含一个方法名，而没有方法体。在书写上，一定要注意，抽象方法名后面直接跟一个分号，而不是花括号。

# 抽象类的几个概念要点

（1）抽象类不能被实例化(初学者很容易犯的错)，如果被实例化，就会报错，编译无法通过。只有抽象类的非抽象子类可以创建对象。

（2）抽象类中不一定包含抽象方法，但是有抽象方法的类必定是抽象类。

（3）抽象类中的抽象方法只是声明，不包含方法体，就是不给出方法的具体实现也就是方法的具体功能。

（4）构造方法，类方法（用static修饰的方法）不能声明为抽象方法。

（5）抽象类的子类必须给出抽象类中的抽象方法的具体实现，除非该子类也是抽象类。

# 抽象类的定义和使用

```java
// 定义一个抽象类Employee，该抽象类有一个抽象方法computePay
public abstract class Employee {
    private String name;
    private String address;
    private int number;
   
    public abstract double computePay();
}
```

```java
// 定义一个类实现抽象类Employee，该类实现了computePay抽象方法
public class Salary extends Employee {
    private double salary; // Annual salary
  
    public double computePay() {
        System.out.println("Computing salary pay for " + getName());
        return salary/52;
    }
}
```

