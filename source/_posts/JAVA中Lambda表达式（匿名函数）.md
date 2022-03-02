---
title: JAVA中Lambda表达式（匿名函数）
date: 2018-05-24 15:21:17
tags: JAVA基础
categories: JAVA
---

# Lambda表达式简介

Lambda表达式，也可称为闭包，它是推动Java 8发布的最重要新特性。Lambda允许把函数作为一个方法的参数（函数作为参数传递进方法中）。使用Lambda表达式可以使代码变的更加简洁紧凑。Lambda表达式是一种匿名函数（对Java而言这并不完全正确，但现在姑且这么认为），简单地说，它是没有声明的方法，也即没有访问修饰符、返回值声明和名字。开发者可以将其当做一种速记，在你需要使用某个方法的地方写上它。当某个方法只使用一次，而且定义很简短，使用这种速记替代之尤其有效，这样，你就不必在类中费力写声明与方法了。

由于**Lambda表达式的结果就是被当成对象，因此程序中完全可以使用Lambda表达式进行赋值**。

Java中的Lambda表达式的书写格式如下：

```
(parameters) -> expression
(parameters) ->{ statements; }
```

关于格式有几点特性需要注意：

    可选类型声明：不需要声明参数类型，编译器可以统一识别参数值
    可选的参数圆括号：一个参数无需定义圆括号，但多个参数需要定义圆括号
    可选的大括号：如果主体包含了一个语句，就不需要使用大括号
    可选的返回关键字：如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值

# Lambda表达式的简单例子

```java
// 1. 不需要参数,返回值为 5
() -> 5

// 2. 接收一个参数(数字类型),返回其2倍的值
x -> 2 * x

// 3. 接受2个参数(数字),并返回他们的差值
(x, y) -> x – y

// 4. 接收2个int型整数,返回他们的和
(int x, int y) -> x + y

// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)
(String s) -> System.out.print(s)

(int a, int b) -> { return a + b; }

(String s) -> { System.out.println(s); }

() -> { return 3.1415 };
```

# Lambda表达式实践

```java
// Java 7中编写线程的代码 -- 匿名内部类
new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello");
        System.out.println("Jimmy");
    }
}).start();

// Java 8中编写线程的代码 -- 匿名函数，Lambda表达式
new Thread(() -> {
    System.out.println("Hello");
    System.out.println("Jimmy");
}).start();
```

```java
//Java 7中当我们对一个集合进行排序时
List<Integer> list = Arrays.asList(1, 2, 3);
Collections.sort(list, new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
        return o1.compareTo(o2);
    }
});

//Java 8中当我们对一个集合进行排序时
Collections.sort(list, (Integer o1, Integer o2) -> {
    return o1.compareTo(o2);
});
Collections.sort(list, (o1, o2) -> {
    return o1.compareTo(o2);
});
```
