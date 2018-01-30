---
title: JAVA基础（7）_接口
date: 2018-01-30 19:27:22
tags: JAVA基础
categories: JAVA技术栈
---

# 接口的概念

abstract关键字允许人们在类中创建一个或多个没有任何定义的方法，该方法只提供接口部分，但是没有提供任何相应的具体实现，这些实现由此类的继承者创建。而Java中有接口的概念，通过接口产生一个完全抽象的类，它根本就没有提供任何具体的实现。它允许创建者确定方法名、参数列表和返回类型，但是没有任何方法体。总之，接口只提供了形式，而未提供任何具体实现。

要想创建一个接口，需要用interface关键字来替代class关键字。接口的概念中有如下几个要点：

（1）接口中每一个方法也是隐式抽象的，接口中的方法会被隐式地指定为public abstract（只能是public abstract，其他修饰符都会报错）。

（2）接口中可以含有变量，但是接口中的变量会被隐式的指定为public static final变量（并且只能是public，用private修饰会报编译错误）。

（3）接口中的方法是不能在接口中实现的，只能由实现接口的类来实现接口中的方法。

# 接口的定义和使用举例

```java
//在Animal.java文件中定义Animal接口
interface Animal {
   public void eat();
   public void travel();
}
```

备注：接口还可以继承其他接口，如`public interface Animal extends Biology {}`，要注意的是这里是`extends`，而不是`implements`.

```java
//在MammalInt.java文件中定义MammalInt类，实现Animal接口
public class MammalInt implements Animal {
    public void eat() {
        System.out.println("Mammal eats");
    }
    public void travel() {
        System.out.println("Mammal travels");
    }
    public int noOfLegs() {
        return 0;
    }
    public static void main(String args[]) {
        MammalInt m = new MammalInt();
        m.eat();
        m.travel();
    }
}
```

# 抽象类与接口的区别

（1）抽象类中的方法可以有方法体，就是能实现方法的具体功能，但是接口中的方法不行

（2）抽象类中的成员变量可以是各种类型的，而接口中的成员变量只能是public static final类型的

（3）接口中不能含有静态代码块以及静态方法（用static修饰的方法），而抽象类是可以有静态代码块和静态方法

（4）一个类只能继承一个抽象类，而一个类却可以实现多个接口


