---
title: JS/ES中的数据类型
date: 2018-07-08 00:29:21
tags:
categories: JavaScript
---

# Javascript中数据类型

Javascript是弱类型的语言，也就是Javascript中定义变量时，不会显式地指明一个变量的数据类型。例如`var aa=3`。JavaScript的数据类型分为两类：

- 一类是原始类型或基础数据类型
- 一类是对象类型。

# 基础数据类型

Javascript中的基础数据类型有：number、string、boolean、null、undefined五种。

# 对象类型

Javascript对象类型是属性的集合。对象类型具体又有好多种，例如function、Array、Date、正则、Error、{x:2, y:4}等等。

（1）对象

```javascript
var book = {
    topic: "JavaScript",
    fat: ture
};
```

可以通过`.`或`[]`来访问对象属性

```javascript
book.topic;
book["fata"];
```

（2）数组

```javascript
var primes = [2, 3, 5, 7];
```

同样可以通过`.`或`[]`来访问数组元素：

```javascript
primes[0];
primes.length;
```

（3）function

（4）.....

