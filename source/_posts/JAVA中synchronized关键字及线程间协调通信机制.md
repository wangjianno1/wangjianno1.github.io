---
title: JAVA中synchronized关键字及线程间协调通信机制
date: 2021-05-19 01:30:10
tags: JAVA基础
categories: JAVA
---

# synchronized关键字简介

JAVA中synchronized关键字是用来增加和释放排他锁的，这把锁可以是Java中的一些对象，比如this，变量以及Class对象等等。只有获取到了这把锁才可以去修改多线程/进程中的共享变量。举例来说，

```java
synchronized(lock) {
    n = n + 1;
}
```

其中lock是锁对象，n是多任务的共享变量。锁和共享对象也可以是同一个东东，应该是没问题的。

```javaa
synchronized(lock) {
   lock.n = lock.n + 1;
}
```

需要注意的，synchronized关键字不仅仅是修饰代码块，最主要有以下3种应用方式：

（1）修饰实例方法，作用于当前实例加锁，进入同步代码前要获得当前实例的锁，相当于synchronized(this)，锁是实例本身。

（2）修饰静态方法，作用于当前类对象加锁，进入同步代码前要获得当前类对象的锁，相当于synchronized(XXX.class)，锁是该类的类对象。

（3）修饰代码块，指定加锁对象，对给定对象加锁，进入同步代码块前要获得给定对象的锁。`synchronized(param)`中param会指定加锁的对象，可以是this，也可以是一个ArrayList对象等，锁可以是自定义的任何obj。

我们来概括一下如何使用synchronized：

    （1）找出修改共享变量的线程代码块
    （2）选择一个实例作为锁
    （3）使用`synchronized(lockObject) { … }`

# synchronized和wait/notify/notifyAll配合使用

在多任务/线程操作共享对象时，有两个问题需要处理。一个是共享对象的操作安全问题，即共享对象加锁的机制的；另一个是多任务/线程之间地协调问题，即线程/进程间通信问题（比如生产者生产了内容，需要通知消费者获取内容消费）。synchronized关键字是解决第一个问题的，第二个问题需要wait/notify/notifyAll来解决。

（1）wait/notify/notifyAll是基类Object类中的方法，也就是Java中所有对象都有这几个方法

（2）wait/notify/notifyAll必须用在synchronized修饰的代码块或方法中，否则JVM会被java.lang.IllegalMonitorStateException:current thread not owner错误。且需要调用synchronized的锁对象的wait/notify/notifyAll方法。比如synchronized(this){}，那就是this.wait/notify/notifyAll；比如synchronized(obj){}，那就是obj.wait/notify/notifyAll方法

（3）调用obj.wait首先会把当前线程挂起，且释放synchronized的锁对象，其他线程可以抢占锁对象了，然后等待obj.notify/notifyAll来唤醒，唤醒之后重新抢占锁对象，获取到锁对象后，接着之前的挂起的语句继续执行

（4）obj.notify唤醒一个被obj.wait挂起的线程，并释放锁对象，当前线程不会挂起

（5）obj.notifyAll唤醒所有被obj.wait挂起的线程，并释放锁对象，当前线程不会挂起

代码举例如下：

```java
public class Runoob {
    private List linkedList;
    private byte[] lock = new byte[0];

    public Runoob() {
        this.linkedList = new LinkedList<String>();
    }

    // 删除共享池中的元素
    public String removeElement() throws InterruptedException {
        synchronized (lock) {
            // 列表为空就等待
            while (linkedList.isEmpty()) {
                System.out.println("List is empty...");
                lock.wait();
                System.out.println("Waiting...");
            }
            String element = (String) linkedList.remove(0);
            return element;
        }
    }

    // 向共享池中添加元素
    public void addElement(String element) {
        System.out.println("Opening...");
        synchronized (lock) {
            // 添加一个元素，并通知元素已存在
            linkedList.add(element);
            System.out.println("New Element:'" + element + "'");
            lock.notifyAll();
            System.out.println("notifyAll called!");
        }
        System.out.println("Closing...");
    }

    public static void main(String[] args) {
        final Runoob demo = new Runoob();
        Runnable runA = new Runnable() {
            public void run() {
                try {
                    String item = demo.removeElement();
                    System.out.println("" + item);
                } catch (InterruptedException ix) {
                    System.out.println("Interrupted Exception!");
                } catch (Exception x) {
                    System.out.println("Exception thrown.");
                }
            }
        };
        Runnable runB = new Runnable() {
            // 执行添加元素操作，并开始循环
            public void run() {
                demo.addElement("Hello!");
            }
        };
        try {
            Thread threadA1 = new Thread(runA, "Google");
            threadA1.start();
            Thread.sleep(500);
            Thread threadA2 = new Thread(runA, "Runoob");
            threadA2.start();
            Thread.sleep(500);
            Thread threadB = new Thread(runB, "Taobao");
            threadB.start();
            Thread.sleep(1000);
            threadA1.interrupt();
            threadA2.interrupt();
        } catch (InterruptedException x) {
        }
    }
}
```

# JAVA中的线程安全

如果一个类被设计为允许多线程正确访问，我们就说这个类就是“线程安全”的（thread-safe）。

```java
public class Counter {
    private int count = 0;
    public void add(int n) {
        synchronized(this) {
            count += n;
        }
    }
    public void dec(int n) {
        synchronized(this) {
            count -= n;
        }
    }
    public int get() {
        return count;
    }
}
```

上面的Counter类就是线程安全的。Java标准库的`java.lang.StringBuffer`也是线程安全的。还有一些不变类，例如String，Integer，LocalDate，它们的所有成员变量都是final，多线程同时访问时只能读不能写，这些不变类也是线程安全的。最后，类似Math这些只提供静态方法，没有成员变量的类，也是线程安全的。除了上述几种少数情况，大部分类，例如ArrayList，都是非线程安全的类，我们不能在多线程中修改它们。但是，如果所有线程都只读取，不写入，那么ArrayList是可以安全地在线程间共享的。

一般来说，没有特殊说明时，一个类默认是非线程安全的。

