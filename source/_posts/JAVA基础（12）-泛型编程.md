---
title: JAVA基础（12）_泛型编程
date: 2018-01-30 23:59:52
tags: JAVA基础
categories: JAVA技术栈
---

# 泛型简介

JAVA泛型是JDK 5中引入的一个新特性，泛型提供了编译时类型安全检测机制，该机制允许程序员在编译时检测到非法的类型。泛型的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数。

有许多原因促成了泛型的出现，而最引人注意的一个原因，就是为了创建容器类。

# 泛型方法

所有泛型方法声明都有一个类型参数声明部分（由尖括号分隔），该类型参数声明部分在方法返回类型之前（在下面例子中的<E>）。每一个类型参数声明部分包含一个或多个类型参数，参数间用逗号隔开。类型参数能被用来声明返回值类型，并且能作为泛型方法得到的实际参数类型的占位符。举例来说：

```java
public class Test {    
    public static void main(String[] args) {
        Integer[] intArray = { 1, 2, 3, 4, 5 };
        Double[] doubleArray = { 1.1, 2.2, 3.3, 4.4 };
        Character[] charArray = { 'H', 'E', 'L', 'L', 'O' };

        printArray(intArray);
        printArray(doubleArray);
        printArray(charArray);
    }
    
    public static <E> void printArray(E[] inputArray) {
        for (E element : inputArray) {
            System.out.printf("%s ", element);
        }
    }
}
```

备注：类型参数也可以是多个，具有多个类型参数的泛型方法形如：`public static <E, F> void printArray(E[] inputArray1, F[] inputArray2) {}`

# 泛型类

泛型类的声明和非泛型类的声明类似，除了在类名后面添加了类型参数声明部分。和泛型方法一样，泛型类的类型参数声明部分也包含一个或多个类型参数，参数间用逗号隔开。一个泛型参数，也被称为一个类型变量，是用于指定一个泛型类型名称的标识符。因为他们接受一个或多个参数，这些类被称为参数化的类或参数化的类型。举例如下：

```java
public class Box<T> {
    private T t;
    
    public void add(T t) {
        this.t = t;
    }
   
    public T get() {
        return t;
    }
    
    public static void main(String[] args) {
        Box<Integer> integerBox = new Box<Integer>();
        Box<String> stringBox = new Box<String>();
     
        integerBox.add(new Integer(10));
        stringBox.add(new String("菜鸟教程"));
     
        System.out.printf("整型值为 :%d\n\n", integerBox.get());
        System.out.printf("字符串为 :%s\n", stringBox.get());
    }
}
```

备注：泛型类也可以使用多个类型参数，形如：`public class Box<T, E> {}`

# 泛型接口

首先定义一个泛型接口Generator，如下：

```java
public interface Generator<T> {
    public T next();
}
```

然后再定义一个生成器类来实现这个接口，如下：

```java
public class FruitGenerator implements Generator<String> {
    private String[] fruits = new String[]{"Apple", "Banana", "Pear"};
	
    @Override
    public String next() {
        Random rand = new Random();
        return fruits[rand.nextInt(3)];
    }
}
```
