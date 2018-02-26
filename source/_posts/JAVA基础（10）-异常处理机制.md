---
title: JAVA基础（10）_异常处理机制
date: 2018-01-30 23:44:12
tags: JAVA基础
categories: JAVA
---

# JAVA的异常与错误

要理解Java异常处理是如何工作的，你需要掌握以下三种类型的异常：

（1）检查性异常Exception

最具代表的检查性异常是用户错误或问题引起的异常，这是程序员无法预见的。例如要打开一个不存在文件时，一个异常就发生了，这些异常在编译时不能被简单地忽略。

（2）运行时异常Exception

运行时异常是可能被程序员避免的异常。与检查性异常相反，运行时异常可以在编译时被忽略。

（3）错误Error

错误不是异常，而是脱离程序员控制的问题。错误在代码中通常被忽略。例如，当栈溢出时，一个错误就发生了，它们在编译也检查不到的。

简单来说，你的代码少了一个分号，那么运行出来结果是提示是错误 java.lang.Error；如果你用System.out.println(11/0)，那么你是因为你用0做了除数，会抛出 java.lang.ArithmeticException的异常。

# JAVA的异常或错误的类层级图

JAVA的异常或错误的类层级图如下：

![](/images/java_syntax_10_1.png)

备注：IOException和RuntimeException是Exception最主要的两个子类，Exception还有非常多的子类哦。

# JAVA中的异常处理

（1）简单的try-catch结构

```java
try {
    // 程序代码
} catch(ExceptionName e1) {
    //Catch 块
}
```

（2）多重捕获块

```java
try {
    // 程序代码
} catch(异常类型1 异常的变量名1) {
    // 程序代码
} catch(异常类型2 异常的变量名2) {
    // 程序代码
} catch(异常类型2 异常的变量名2) {
    // 程序代码
}
```

（3）try-catch-finally块

```java
try {
    // 程序代码
} catch(异常类型1 异常的变量名1) {
    // 程序代码
} catch(异常类型2 异常的变量名2) {
    // 程序代码
} finally {
    // 程序代码
}
```

# 自定义异常

在Java中你可以自定义异常。编写自己的异常类时需要记住下面的几点：

（1）所有异常都必须是Throwable的子类

（2）如果希望写一个检查性异常类，则需要继承Exception类

（3）如果你想写一个运行时异常类，那么需要继承RuntimeException类

通常来说，我们可以按照如下格式来自定义异常类：

```java
class MyException extends Exception {
}
```

# 使用throws/throw关键字

如果一个方法没有捕获一个检查性异常，那么该方法必须使用throws关键字来声明。throws关键字放在方法签名的尾部。也可以使用 throw关键字抛出一个异常，无论它是新实例化的还是刚捕获到的。格式如下：

```java
import java.io.*;
public class className {
    public void deposit(double amount) throws RemoteException {
        // Method implementation
        throw new RemoteException();
    }
}
```
