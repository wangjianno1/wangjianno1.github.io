---
title: JAVA语言中异常处理机制
date: 2018-01-30 23:44:12
tags: JAVA基础
categories: JAVA
---

# JAVA的异常与错误

要理解Java异常处理是如何工作的，你需要掌握以下三种类型的异常：

（1）错误Error

Error表示由JVM所侦测到的无法预期的错误，由于这是属于JVM层次的严重错误 ，导致JVM无法继续执行，因此，这是不可捕捉到的，无法采取任何恢复的操作，顶多只能显示错误信息。 Error类体系描述了Java运行系统中的内部错误以及资源耗尽的情形。假如出现这种错误，除了尽力使程序安全退出外，在其他方面是无能为力的。例如Java 虚拟机运行错误（Virtual MachineError）、虚拟机内存不够错误(OutOfMemoryError)、类定义错误（NoClassDefFoundError）等 。这些异常发生时，Java 虚拟机（JVM）一般会选择线程终止。

（2）检查性异常Exception

检查性异常也就是我们经常遇到的IO异常，以及SQL异常等。对于这种异常，JAVA编译器强制要求我们必需对出现的这些异常进行catch。所以，面对这种异常不管我们是否愿意，只能自己去写一大堆catch块去处理可能的异常。

（3）运行时异常Exception

出现运行时Exception时，总是由虚拟机接管。比如，我们从来没有人去处理过NullPointerException异常，它就是运行时异常，并且这种异常还是最常见的异常之一。 出现运行时异常后，系统会把异常一直往上层抛，一直遇到处理代码。如果没有处理块，到最上层，如果是多线程就由Thread.run()抛出，如果是单线程就被main()抛出。抛出之后，如果是线程，这个线程也就退出了。如果是主程序抛出的异常，那么这整个程序也就退出了。运行时异常是Exception的子类，也有一般异常的特点，是可以被catch块处理的，只不过往往我们不对他处理罢了。也就是说，你如果不对运行时异常进行处理，那么出现运行时异常之后，要么是线程中止，要么是主程序终止。当然，如果需要，我们可以像检查性异常一样去对运行性异常进行catch并处理。

备注：简单来说，你的代码少了一个分号，那么运行出来的结果是提示java.lang.Error错误；如果你用System.out.println(11/0)，那么因为用0做了除数，会抛出 java.lang.ArithmeticException异常。值得注意的是，ERROR和Exception的一个重要区别是，ERROR是用户代码无法捕获并处理的问题；

而Exception，包括检查性异常和运行时异常。检查性异常必须被`try{}catch{}`语句块所捕获，或者在方法里通过throws子句声明，检查性异常命名为Checked Exception，是因为Java编译器要进行检查，Java虚拟机也要进行检查，以确保这个规则得到遵守，否则编译的时候就会报错。对于运行时异常，可以选择用try-catch捕获，或throws关键字抛出，当然也可以不做任何处理。

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

如果一个方法没有捕获一个检查性异常，那么该方法必须使用throws关键字来声明。throws关键字放在方法签名的尾部。也可以使用throw关键字抛出一个异常，无论它是新实例化的还是刚捕获到的。格式如下：

```java
import java.io.*;
public class className {
    public void deposit(double amount) throws RemoteException {
        // Method implementation
        throw new RemoteException();
    }
}
```
