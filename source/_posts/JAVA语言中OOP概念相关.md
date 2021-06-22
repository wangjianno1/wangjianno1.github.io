---
title: JAVA语言中OOP概念相关
date: 2018-01-30 19:24:01
tags: JAVA基础
categories: JAVA
---

# OOP中一些基本概念

```
多态
继承
封装
类
对象
成员变量/实例变量/成员属性
类变量/静态变量
成员方法/实例方法
类方法/静态方法
构造方法
重载overload
覆盖/覆写override
```

# 具体说明

## 构造方法

每个类都有构造方法。如果没有显式地为类定义构造方法，Java编译器将会为该类提供一个默认构造方法。在创建一个对象的时候，至少要调用一个构造方法。构造方法的名称必须与类同名，一个类可以有多个构造方法。举例来说：

```java
public class Puppy {
    public Puppy() {
    }
	
    public Puppy(String name) {
        // 这个构造器仅有一个参数：name
    }
}
```

## 成员变量/实例变量/成员属性

成员变量是定义在类中，方法体之外的变量。这种变量在创建对象的时候实例化。成员变量可以被类中方法、构造方法和特定类的语句块访问。

## 类变量/静态变量

类变量也声明在类中，方法体之外，但必须声明为static类型。

## 继承

```java
// 父类Animal
public class Animal { 
    private String name;  
    private int id; 

    public Animal(String myName, int myid) { 
        name = myName; 
        id = myid;
    } 

    public void eat(){ 
        System.out.println(name+"正在吃"); 
    }

    public void sleep(){
        System.out.println(name+"正在睡");
    }

    public void introduction() { 
        System.out.println("大家好！我是"         + id + "号" + name + "."); 
    } 
}
// 子类企鹅类
public class Penguin extends Animal { 
    public Penguin(String myName, int myid) { 
        super(myName, myid); 
    } 
}

// 子类老鼠类
public class Mouse extends Animal { 
    public Mouse(String myName, int myid) { 
        super(myName, myid); 
    } 
}
```

关于继承的一些知识点：

（1）继承可以使用extends关键字来实现继承，而且所有的类都是继承于java.lang.Object，当一个类没有extends关键字时，则默认继承Object（这个类在java.lang包中，所以不需要import）祖先类。Java Object类是所有类的父类，也就是说Java的所有类都继承了Object，子类可以使用Object的所有方法。Object类可以显式继承，也可以隐式继承，以下两种方式时一样的：

```java
// 显式继承
public class Runoob extends Object {
}

//隐式继承
public class Runoob {
}
```

（2）在Java中，类的继承是单一继承，也就是说，一个子类只能拥有一个父类，所以extends只能继承一个类。

（3）final关键字声明的类是不能被继承的，即最终类。

```java
final class 类名 {
    //类体
}
```

## 多态

所谓多态，同一行为或接口，在不同的对象中的表现内容是不一样的。

![](/images/java_oop_1_1.png)

