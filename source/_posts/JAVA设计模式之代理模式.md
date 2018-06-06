---
title: JAVA设计模式之代理模式
date: 2018-06-06 14:34:03
tags:
categories: Design Pattern
---

# 代理模式定义

为被代理对象提供一种代理，以控制对这个对象的访问。使用代理模式，可以对某些类进行增强或扩展的功能，Spring AOP实现的核心基础就是代理模式的运用。

# Java中代理模式的实现

在Java中，有静态代理和动态代理两种，所谓静态代理，就是代理类在源码阶段或编译阶段是确定的。而动态代理，代理类在源码或编译阶段是不存在的，在程序运行中动态生成的。需要注意的是，动态代理的实现有很多种方式，如JDK动态代理、CGLIB动态代理等等。

# Java静态代理

代理和被代理对象在代理之前是确定的，它们都实现相同的接口或继承相同的抽象类。

![](/images/design_pattern_1_1.png)

下面以代码举例来说明静态代理的使用：

（1）定义接口

```java
// Moveable.java
public interface Moveable {
    public void move();
}
```

（2）定义被代理类，被代理类要实现接口

```java
// Bike.java
public class Bike implements Moveable {
    @Override
    public void move() {
        System.out.println("自行车骑行中...");
    }
}
```

（3）定义代理类，代理类也要实现接口

```java
// BikeProxy.java
public class BikeProxy implements Moveable {
    private Bike bike;
   
    public BikeProxy(Bike bike) {
        super();
        this.bike = bike;
    }

    @Override
    public void move() {
        System.out.println("Bike静态代理类增强/扩展逻辑开始...");
        bike.move();
        System.out.println("Bike静态代理类增强/扩展逻辑结束...");
    }
}
```

（4）测试代理类的使用

```java
// Test.java
public class Test {
    public static void main(String[] args) {
        Bike bike = new Bike();
        BikeProxy bikeProxy = new BikeProxy(bike);
        bikeProxy.move();
    }
}
```

程序输出结果如下：

    Bike静态代理类增强/扩展逻辑开始...
    自行车骑行中...
    Bike静态代理类增强/扩展逻辑结束...

# Java JDK动态代理

通过静态代理的代码可以发现每一个代理类只能为一个接口服务，这样一来程序开发中必然会产生过多的代理。如果可以在程序运行中能够动态地生成代理类那就极好了。呵呵，JDK动态代理就可以达到这个目的。动态代理类的字节码在程序运行时由Java反射机制动态生成，无需程序员手工编写它的源代码。动态代理类不仅简化了编程工作，而且提高了软件系统的可扩展性，因为Java反射机制可以生成任意类型的动态代理类。`java.lang.reflect`包中的`Proxy`类和`InvocationHandler`接口提供了生成动态代理类的能力。

![](/images/design_pattern_1_2.png)

下面用代码来演示JDK动态代理的使用：

（1）定义接口

```java
// Moveable.java
public interface Moveable {
    public void move();
}
```

（2）定义被代理类，被代理类要实现接口

```java
// Bike.java
public class Bike implements Moveable {
    @Override
    public void move() {
        System.out.println("自行车骑行中...");
    }
}
```

（3）定义实现了java.lang.reflect.InvocationHandler接口的InvocationHandler类

`InvocationHandler`接口实现类中，要实现`invoke()`方法，该方法中需要通过反射调用被代理类的方法，以及加入一些增强/扩展逻辑。

```java
// MyInvocationHandler.java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
public class MyInvocationHandler implements InvocationHandler {
    private Object target;   // target是被代理类的实例对象
   
    public MyInvocationHandler(Object target) {
        super();
        this.target = target;
    }
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("Bike JDK动态代理类增强/扩展逻辑开始...");
        method.invoke(target, args); //调用被代理类的方法
        System.out.println("Bike JDK动态代理类增强/扩展逻辑结束...");
        return null;
    }
}
```

备注：`invoke`方法中有三个参数，`proxy`是代理类的实例对象，`method`是被代理类的方法，`args`是被代理类的方法参数。

（4）使用Proxy.newProxyInstance动态生成代理类对象，并测试使用

```java
// Test.java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;
public class Test {
    public static void main(String[] args) {
        Bike bike = new Bike();
        InvocationHandler hander = new MyInvocationHandler(bike);
        // 生成代理类对象
        Moveable m = (Moveable) Proxy.newProxyInstance(bike.getClass().getClassLoader(),
                bike.getClass().getInterfaces(), hander);
        // Moveable m = (Moveable) Proxy.newProxyInstance(Bike.class.getClassLoader(),
        // Bike.class.getInterfaces(), hander);
        m.move();
    }
}
```

备注：`Proxy.newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h)`的有三个参数，`loader`是被代理类的类加载器，`interfaces`是被代理类实现的接口，`h`是`InvocationHandler`实现类的实例对象。

程序输出结果如下：

    Bike JDK动态代理类增强/扩展逻辑开始...
    自行车骑行中...
    Bike JDK动态代理类增强/扩展逻辑结束...

# Java CGLIB动态代理

JDK动态代理的前提条件是被代理类实现了某些接口，若被代理类没有实现任何接口，则不能使用JDK动态代理哦。

CGLIB是一个功能强大，高性能的代码生成包。它为没有实现接口的类提供代理，为JDK的动态代理提供了很好的补充。通常可以使用Java的动态代理创建代理，但当要代理的类没有实现接口或者为了更好的性能，CGLIB是一个好的选择。

CGLIB原理是动态生成一个被代理类的子类，子类重写被代理的类的所有不是final的方法。在子类中采用方法拦截的技术拦截所有父类方法的调用，顺势织入横切逻辑。它比使用Java反射的JDK动态代理要快。

CGLIB底层使用字节码处理框架ASM，来转换字节码并生成新的类。不鼓励直接使用ASM，因为它要求你必须对JVM内部结构包括class文件的格式和指令集都很熟悉。CGLIB缺点是对于final方法，无法进行代理。

CGLIB广泛地被许多AOP的框架使用，例如Spring AOP和dynaop。Hibernate使用CGLIB来代理单端single-ended（多对一和一对一）关联。

下面用代码实例来说明CGLIB动态代理的使用：

（1）引入CGLIB的JAR包

```
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>2.2.2</version>
</dependency>
```

（2）定义被代理类，被代理类可以不实现任何接口

```java
// WarPlane.java
public class WarPlane {
    public void move() {
        System.out.println("战斗机巡航中...");
    }
}
```

（3）定义被代理类的方法拦截器，需要实现net.sf.cglib.proxy.MethodInterceptor接口

```java
import java.lang.reflect.Method;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;
public class MyMethodInterceptor implements MethodInterceptor {
    @Override
    public Object intercept(Object obj, Method m, Object[] args, MethodProxy proxy) throws Throwable {
        System.out.println("WarPlane CGLIB动态代理类增强/扩展逻辑开始...");
        proxy.invokeSuper(obj, args);
        System.out.println("WarPlane CGLIB动态代理类增强/扩展逻辑结束...");
        return null;
    }
}
```

备注：`MyMethodInterceptor`有点类似于JDK动态代理中`MyInvocationHandler`类，`MethodInterceptor`接口中`intercept(Object obj, Method m, Object[] args, MethodProxy proxy)`方法有四个参数，`obj`是被代理类的实例，`m`是被代理类的方法，`args`被代理类的方法参数，`proxy`是代理类的实例。

（4）生成代理类并测试

```java
// Test.java
import net.sf.cglib.proxy.Enhancer;
public class Test {
    public static void main(String[] args) {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(WarPlane.class);
        enhancer.setCallback(new MyMethodInterceptor());
        WarPlane wp = (WarPlane) enhancer.create();  //生成代理类对象
        wp.move();
    }
}
```

程序的输出结果为：

    WarPlane CGLIB动态代理类增强/扩展逻辑开始...
    战斗机巡航中...
    WarPlane CGLIB动态代理类增强/扩展逻辑结束...

学习资料参考于：
http://www.cnblogs.com/jqyp/archive/2010/08/20/1805041.html
http://www.runoob.com/design-pattern/proxy-pattern.html