---
title: JAVA中SPI机制总结
date: 2019-02-14 16:09:52
tags: JAVA基础
categories: JAVA
---

# API与SPI

面向对象的设计里，我们一般推荐模块之间基于接口编程，模块之间不对实现类进行硬编码。一旦代码里涉及具体的实现类，就违反了可拔插的原则，如果需要替换一种实现，就需要修改代码。

![](/images/java_spi_1_1.png)

当接口属于实现方时，实现方提供了接口和具体实现类，然后调用方通过引用接口来达到调用该实现类的功能。这中模式就是我们经常所说的API。

当接口属于调用方时，我们就将其称为SPI（全称为Service Provider Interface）。

# SPI

SPI全称为(Service Provider Interface)，是JDK内置的一种服务提供发现机制。许多开发框架都使用了Java的SPI机制，如数据库驱动java.sql.Driver的SPI实现（mysql驱动、oracle驱动等）、common-logging的日志接口实现、dubbo的扩展实现等等。下面我们以数据库驱动为例来解释SPI的机制原理。

## JDBC驱动接口的定义

首先在JDK中定义了接口`java.sql.Driver`，但并没有具体的实现，具体的实现都是由不同的数据库厂商来提供的。

## java.sql.Driver的MySQL厂商实现

在MySQL的jar包`mysql-connector-java-6.0.6.jar`中，可以找到`META-INF/services`目录，该目录下会有一个名字为`java.sql.Driver`的文件，文件内容是`com.mysql.cj.jdbc.Driver`，这个就是针对JDK中定义的Driver接口的MySQL实现类的完整包路径。

## java.sql.Driver的Postgresql厂商实现

同样在PostgreSQL的jar包postgresql-42.0.0.jar中，也可以找到同样的配置文件`META-INF/services/java.sql.Driver`，文件内容是`org.postgresql.Driver`，这是postgresql对JDK的Driver接口的实现类的完整包路径。

## 通过SPI机制来加载具体的驱动实现

我们在项目开发中，可以通过如下代码来获取数据库连接：

```java
String url = "jdbc:xxxx://xxxx:xxxx/xxxx";
Connection conn = DriverManager.getConnection(url, username, password);
```

这里就涉及到使用Java的SPI扩展机制来查找相关具体驱动实例类了，但从直观上来看，并不能看到有关SPI机制相关的代码，其实被封装在了DriverManager中。DriverManager是JDK中的实现，用来获取数据库连接，在DriverManager中有一个静态代码块如下：

```java
static {
    loadInitialDrivers();
    println("JDBC DriverManager initialized");
}
```

可以看到是加载实例化驱动的，接着看loadInitialDrivers方法：

```java
private static void loadInitialDrivers() {
    String drivers;
    try {
        drivers = AccessController.doPrivileged(new PrivilegedAction<String>() {
            public String run() {
                return System.getProperty("jdbc.drivers");
            }
        });
    } catch (Exception ex) {
        drivers = null;
    }

    AccessController.doPrivileged(new PrivilegedAction<Void>() {
        public Void run() {
            //使用SPI的ServiceLoader来加载接口的实现
            ServiceLoader<Driver> loadedDrivers = ServiceLoader.load(Driver.class);
            Iterator<Driver> driversIterator = loadedDrivers.iterator();
            try{
                while(driversIterator.hasNext()) {
                    driversIterator.next();
                }
            } catch(Throwable t) {
            // Do nothing
            }
            return null;
        }
    });

    println("DriverManager.initialize: jdbc.drivers = " + drivers);

    if (drivers == null || drivers.equals("")) {
        return;
    }
    String[] driversList = drivers.split(":");
    println("number of Drivers:" + driversList.length);
    for (String aDriver : driversList) {
        try {
            println("DriverManager.Initialize: loading " + aDriver);
            Class.forName(aDriver, true,
                    ClassLoader.getSystemClassLoader());
        } catch (Exception ex) {
            println("DriverManager.Initialize: load failed: " + ex);
        }
    }
}
```

在上述代码中，关于SPI的代码部分如下：

```java
ServiceLoader<Driver> loadedDrivers = ServiceLoader.load(Driver.class);
//获取迭代器
Iterator<Driver> driversIterator = loadedDrivers.iterator();
//遍历所有的驱动实现
while(driversIterator.hasNext()) {
    driversIterator.next();
}
```

在遍历的时候，首先调用`driversIterator.hasNext()`方法，这里会搜索classpath下以及jar包中所有的`META-INF/services`目录下的`java.sql.Driver`文件，并找到文件中的实现类的名字，此时并没有实例化具体的实现类。然后是调用`driversIterator.next()`方法，此时就会根据驱动名字具体实例化各个实现类了。现在驱动就被找到并实例化了。

当我们在测试项目中添加了两个jar包，`mysql-connector-java-6.0.6.jar`和`postgresql-42.0.0.0.jar`，跟踪到`DriverManager`中之后，可以看到此时迭代器中有两个驱动，mysql和postgresql的都被加载了。有关两个驱动都加载了，JDBC会有一定的方法来判断使用哪一个驱动。

![](/images/java_spi_1_2.png)

# SPI的具体实现者需要遵循的SPI规则

以`java.sql.Driver`的MySQL厂商实现`mysql-connector-java-5.1.44.jar`为例来说，需要在META-INF/services目录下创建一个名字为接口全限定名的文件，即`java.sql.Driver`文件，文件内容是具体的实现名字，如下：

    com.mysql.jdbc.Driver
    com.mysql.fabric.jdbc.FabricMySQLDriver

`com.mysql.jdbc.Driver`和`com.mysql.fabric.jdbc.FabricMySQLDriver`即是MySQL公司实现了JAVA JDK的`java.sql.Driver`接口的实现类。

学习资料参考于：
https://cxis.me/2017/04/17/Java%E4%B8%ADSPI%E6%9C%BA%E5%88%B6%E6%B7%B1%E5%85%A5%E5%8F%8A%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/