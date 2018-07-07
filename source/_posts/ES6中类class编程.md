---
title: ES6中类class编程
date: 2018-07-08 01:34:15
tags:
categories: JavaScript
---

# ES6类class编程简介

ES6提供了更接近传统语言的写法，引入了class（类）这个概念，作为对象的模板。通过class关键字，可以定义类。 基本上，ES6的class可以看作只是一个语法糖，它的绝大部分功能，ES5都可以做到，新的class写法只是让对象原型的写法更加清晰、更像面向对象编程的语法而已。举例来说：

```javascript
class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    toString() {
        return '(' + this.x + ', ' + this.y + ')';
    }

    dosth() {
        //do something
    }
}

var p = new Point ();
p.dosth();
```

备注：定义“类”的方法时，前面不需要加上`function`这个关键字，直接把函数定义放进去了就可以了。`constructor`是类的构造函数。

# ES6中类继承

ES6中class是可以继承的，语法规则如下：

```javascript
class Point {
}

//ColorPoint继承了Point
class ColorPoint extends Point {
    constructor(args) {
        super(args);
    }
}
```

备注：子类必须在`constructor`方法中调用`super`方法，否则新建实例时会报错。`super()`函数会调用父类的构造函数，进行对象初始化工作。

# 类的构造函数constructor()

`constructor`方法就是ES6中类的构造方法。constructor方法是类的默认方法，通过`new`命令生成对象实例时，自动调用该方法。一个类必须有`constructor`方法，如果没有显式定义，一个空的`constructor`方法会被默认添加。

# 类的私有方法

私有方法是常见需求，但ES6不提供，只能通过变通方法模拟实现。通常来说，在类方法名前面加上下划线，表示这是一个只限于内部使用的私有方法。但是，这种命名是不保险的，在类的外部，还是可以调用到这个方法。

举例来说：

```javascript
class Widget {
    // 公有方法
    foo (baz) {
        this._bar(baz);
    }

    // 私有方法
    _bar(baz) {
        return this.snaf = baz;
    }
}
```
