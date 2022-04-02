---
title: JAVA设计模式之其他模式
date: 2022-03-21 14:17:17
tags:
categories: Design Pattern
---

# 单例模式

单例模式（Singleton Pattern）是 Java 中最简单的设计模式之一。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。这种模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。

单例类只能有一个实例。单例类必须自己创建自己的唯一实例。单例类必须给所有其他对象提供这一实例。

```java
// 懒汉式，线程不安全
public class Singleton { 
    private static Singleton instance;
    private Singleton (){
    }

    public static Singleton getInstance() {
        if (instance == null) { 
            instance = new Singleton(); 
        } 
        return instance; 
    }
}
```

```java
// 饿汉式，线程安全
public class Singleton {
    private static Singleton instance = new Singleton(); 
    private Singleton (){
    }

    public static Singleton getInstance() { 
        return instance; 
    }
}
```

备注：还有一些其他构建单例类的改进方式。

# 工厂模式

工厂模式属于创建型模式，它提供了一种创建对象的最佳方式。在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

（1）定义接口

```java
public interface Shape {
    void draw();
}
```

（2）定义多个实现类

定义一个矩形，

```java
public class Rectangle implements Shape {
    @Override
    public void draw() {
        System.out.println("Inside Rectangle::draw() method.");
    }
}
```

定义一个三角形，

```java
public class Circle implements Shape {
    @Override
    public void draw() {
        System.out.println("Inside Circle::draw() method.");
    }
}
```

（3）创建工厂类

```java
public class ShapeFactory {
    //使用 getShape 方法获取形状类型的对象
    public Shape getShape(String shapeType){
        if(shapeType == null){
            return null;
        }        
        if(shapeType.equalsIgnoreCase("CIRCLE")){
            return new Circle();
        } else if(shapeType.equalsIgnoreCase("RECTANGLE")){
            return new Rectangle();
        } 
        return null;
    }
}
```

（4）使用工厂类

```java
public class FactoryPatternDemo {
    public static void main(String[] args) {
        ShapeFactory shapeFactory = new ShapeFactory();
 
        //获取 Circle 的对象，并调用它的 draw 方法
        Shape shape = shapeFactory.getShape("CIRCLE");
 
        //调用 Circle 的 draw 方法
        shape.draw();
    }
}
```

# 模版模式

在模板模式（Template Pattern）中，一个抽象类公开定义了执行它的方法的方式/模板。它的子类可以按需要重写方法实现，但调用将以抽象类中定义的方式进行。这种类型的设计模式属于行为型模式。

（1）创建一个抽象类，它的模板方法被设置为final

```java
public abstract class Game {
   abstract void initialize();
   abstract void startPlay();
   abstract void endPlay();
 
   //模板
   public final void play(){
 
      //初始化游戏
      initialize();
 
      //开始游戏
      startPlay();
 
      //结束游戏
      endPlay();
   }
}
```

（2）创建扩展了上述类的实体类Cricket和Football

```java
public class Cricket extends Game {
 
   @Override
   void endPlay() {
      System.out.println("Cricket Game Finished!");
   }
 
   @Override
   void initialize() {
      System.out.println("Cricket Game Initialized! Start playing.");
   }
 
   @Override
   void startPlay() {
      System.out.println("Cricket Game Started. Enjoy the game!");
   }
}
```

```java
public class Football extends Game {
 
   @Override
   void endPlay() {
      System.out.println("Football Game Finished!");
   }
 
   @Override
   void initialize() {
      System.out.println("Football Game Initialized! Start playing.");
   }
 
   @Override
   void startPlay() {
      System.out.println("Football Game Started. Enjoy the game!");
   }
}
```

（3）使用Game的模板方法play()来演示游戏的定义方式

```java
public class TemplatePatternDemo {
    public static void main(String[] args) {
        Game game = new Cricket();
        game.play();
        System.out.println();
        ame = new Football();
        game.play();      
    }
}
```
