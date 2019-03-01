---
title: JAVA中final关键字-final变量/final方法/final类
date: 2018-05-24 15:13:13
tags: JAVA基础
categories: JAVA
---

# final关键字简介

final在Java中是一个保留的关键字，可以声明成员变量、方法、类以及本地变量。一旦你将引用声明作final，你将不能改变这个引用了，编译器会检查代码，如果你试图将变量再次初始化的话，编译器会报编译错误。

# final变量

凡是对成员变量或者本地变量（在方法中的或者代码块中的变量称为本地变量）声明为final的都叫作final变量。final变量经常和static关键字一起使用，作为常量。下面是final变量的例子：

```java
private static final User user = new User("zhangsan", 30);

public static void main(String[] args) {
    user.setName("lisi");          //修改final常量的内部状态是没有问题的
    user = new User("wangwu", 31); //修改final常量的引用指向则编译器会报错
    System.out.println(user.getName());
}
```

# final方法

final也可以声明方法。方法前面加上final关键字，代表这个方法不可以被子类的方法重写。如果你认为一个方法的功能已经足够完整了，子类中不需要改变的话，你可以声明此方法为final。final方法比非final方法要快，因为在编译的时候已经静态绑定了，不需要在运行时再动态绑定。下面是final方法的例子：

```java
class PersonalLoan {
    public final String getName(){
        return "personal loan";
    }
}

class CheapPersonalLoan extends PersonalLoan{
    @Override
    public final String getName(){
        return "cheap personal loan"; //此处覆写父类中的final方法，编译会报错，overridden method is final
    }
}
```

# final类

使用final来修饰的类叫作final类。final类通常功能是完整的，它们不能被继承。Java中有许多类是final的，譬如String, Interger以及其他包装类。下面是final类的实例：

```java
final class PersonalLoan{
}

class CheapPersonalLoan extends PersonalLoan {  //此处试图继承一个final类，编译器会报错，cannot inherit from final class
}
```

# final关键字的好处

下面总结了一些使用final关键字的好处

- final关键字提高了性能。JVM和Java应用都会缓存final变量。
- final变量可以安全的在多线程环境下进行共享，而不需要额外的同步开销。
- 使用final关键字，JVM会对方法、变量及类进行优化。

学习资料参考于：
http://www.importnew.com/7553.html
