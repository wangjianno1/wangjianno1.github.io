---
title: JAVA中内部类与匿名内部类
date: 2018-05-24 15:18:23
tags: JAVA基础
categories: JAVA
---

# 内部类

可以将一个类的定义放在另一个类的定义内部，这就是内部类。内部类是一个非常有用的特性但又比较难理解使用的特性。举例来说，

```java
public class OuterClass {
    private String name ;
    private int age;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }
    
    class InnerClass{
        public InnerClass() {
            name = "chenssy";
            age = 23;
        }
    }
}
```

# 匿名内部类

匿名内部类是一种特殊的内部类。使用匿名内部类我们必须要继承一个父类或者实现一个接口，当然也仅能只继承一个父类或者实现一个接口。同时它也是没有class关键字，这是因为匿名内部类是直接使用new来生成一个对象的引用。举例来说，

```java
public abstract class Bird {
    private String name;

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }    
    public abstract int fly();
}

public class Test {  
    public void test(Bird bird) {
        System.out.println(bird.getName() + "能够飞 " + bird.fly() + "米");
    }
    
    public static void main(String[] args) {
        Test test = new Test();
        test.test(new Bird() {            
            public int fly() {
                return 10000;
            }          
            public String getName() {
                return "大雁";
            }
        });
    }
}
```

上述使用了匿名内部类的语法和如下代码是等价的：

```java
public class WildGoose extends Bird {
    public int fly() {
        return 10000;
    }
    public String getName() {
        return "大雁";
    }
}

WildGoose wildGoose = new WildGoose();
test.test(wildGoose);
```