---
title: JAVA中多线程编程
date: 2019-03-03 18:16:20
tags:
categories: JAVA
---

# JAVA多线程简介

Java给多线程编程提供了内置的支持。 一条线程指的是进程中一个单一顺序的控制流，一个进程中可以并发多个线程，每条线程并行执行不同的任务。

一点说明，Java是单进程多线程模型，这个单进程就是JVM进程，在操作系统层面看到就是java或java.exe进程，Java貌似不能搞多进程编程，如果也可以通过`Runtime.getRuntime().exec("java xxx")`来创建新的进程，创建出来的也是JVM进程。

# JAVA中线程的生命周期

![](/images/java_thread_1_1.png)

# JAVA创建多线程编程的方法

Java提供了三种创建线程的方法。

## 通过实现Runnable接口的多线程

```java
class RunnableThread implements Runnable {
    @Override
    public void run() {  //需要实现接口中run()方法
        System.out.println("RunnableThread.run() method invoking.....");
    }
}

public class Test {
    public static void main(String[] args) {
        RunnableThread rt1 = newRunnableThread();
        RunnableThread rt2 = newRunnableThread();
        new Thread(rt1, "实现Runnable接口的线程1").start();
        new Thread(rt2, "实现Runnable接口的线程2").start();
    }
}
```

也可以有更飒的写法如下：

```java
// 匿名内部类
new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello");
        System.out.println("Jimmy");
    }
}).start();

// Lambda匿名函数
new Thread(() -> {
    System.out.println("Hello");
    System.out.println("Jimmy");
}).start();
```

RunnableThread类通过实现Runnable接口，使得该类有了多线程类的特征。run()方法是多线程的执行体，多线程的业务代码在run方法里面。Thread类实际上也是实现了Runnable接口的类。在启动的多线程的时候，需要先通过Thread类的构造方法Thread(Runnable target)构造出对象，然后调用Thread对象的start()方法来运行多线程代码。

实际上所有的多线程代码都是通过运行Thread的start()方法来运行的。因此，不管是扩展Thread类还是实现Runnable接口来实现多线程，最终还是通过Thread的对象的API来控制线程的，熟悉Thread类的API是进行多线程编程的基础。

## 通过继承Thread类本身的多线程

```java
class ThreadTest extends Thread {
    public void run() {  // 需要重新Thread类中的run()方法
        System.out.println("ThreadTest2.run() method invoking.....");
    }
}

public class Test {
    public static void main(String[] args) {
        ThreadTest tt1 = new ThreadTest();
        ThreadTest tt2 = new ThreadTest();
        tt1.start();
        tt2.start();
    }
}
```

## 通过Callable和Future创建多线程

```java
class CallableImpl implements Callable<Integer> {
    public Integer call() throws Exception {
        System.out.println("CallableImpl.call() invoking.....");
        return new Integer(11);
    }
}

public class Test {
    public static void main(String[] args) {
        CallableImpl call = new CallableImpl();
        FutureTask<Integer> ft = new FutureTask<>(call);
        new Thread(ft, "Callable & Future Thread 1").start();
        new Thread(ft, "Callable & Future Thread 2").start();
        try {
            Integer o = ft.get(); // 通过FutureTask对象获取到线程执行的返回值
            System.out.println(o);
        } catch (Exception e) {
            // to do sth.
        }
    }
}
```

Callable接口很像是Runnable接口的增强版，Callable接口提供了一个call()方法可以作为线程的执行体，但call()方法比run()方法功能更强大。强大的地方体现在：

    call()方法可以有返回值
    call()方法可以抛出异常

Callable接口是Java 5新增的接口，而且它不是Runnable接口的子接口，所以Callable对象不能直接作为Thread的target。Java 5提供了Future接口来代表Callable接口里call()方法的返回值，并为Future接口提供了一个FutureTask实现类，该实现类实现了Future接口，并实现了Runnable接口，所以使用FutureTask实现类的对象作为Thread类的target。

## 使用Executor框架中线程池来构建

参见《JAVA Executor框架》（待写）

# Thread类中start()/run()/join()区别

start()开启线程，start()是将线程从“新建状态”转换到“就绪状态”，就可以等待CPU来调度执行了。

run()方法会将线程体的代码当成普通函数调用啦，并不会创建线程并CPU调度哦。

join()方法，阻塞当前线程，一直等待直到该线程死亡，可以指定等待指定时间内线程死亡，否则，一直在循环判断线程是否结束。也就是，在线程B中调用了线程A的join()方法，则直到线程A执行完毕后，才会继续执行线程B。

# 多线程中的异常处理

（1）在run()方法内处理异常

我们知道Runnable和Thread的run()方法是不可以声明抛异常的，也就是线程中的代码抛出异常，就只能抛到run()方法，然后线程退出。

```java
try {
    ThreadTest tt = new ThreadTest();
    tt.start();
} catch(Exception e) {  // 此处是没有意义的，不会捕获到任何异常
    e.printStackTrace();
}
```

但是我们可以在run()里面通过try-catch-finally块来处理异常。

（2）Thread API来处理异常

在Thread API中提供了UncaughtExceptionHandle，它能检测出某个由于未捕获的异常而线程终结的情况。

```java
Thread.setDefaultUncaughtExceptionHandler(new  Thread.UncaughtExceptionHandler() {
        @Override
        public void uncaughtException(Thread t, Throwable e) {
            // 加入一些释放连接等善后的业务的业务代码
            logger.error("UnCaughtException", e);
        }
    });
}
```

该方法可以捕获到多线程中的一些未捕获的异常，然后进行一些善后的处理。
