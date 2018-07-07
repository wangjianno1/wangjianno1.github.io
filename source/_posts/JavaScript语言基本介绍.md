---
title: JavaScript语言基本介绍
date: 2018-07-08 00:29:09
tags:
categories: JavaScript
---

# JavaScript的语言简介

JavaScript是一门动态、弱类型的编程语言，JavaScript的编程风格具体面向对象和函数式编程的特点。JavaScript的语法源自Java；一等函数来自于Scheme；基于原型的继承来自于Self。

# JavaScript的运行环境

JavaScript可以在浏览器中执行，也可以使用chrome V8引擎的nodejs那样执行。我们最熟悉的是在浏览器中执行JavaScript代码，但是一定要注意在浏览器的执行上下文中，浏览器提供了很多的api，例如表示浏览器窗口的window对象，表示web页面的document对象。

# JavaScript中的基础词法规则

（1）JavaScript中的标识符是区分大小写

（2）JavaScript的语句分割符

JavaScript中可以使用分号(;)来分割不同的语句，当然也可以省略。如果在书写JavaScript代码时，省略了分号，那么JavaScript在解释执行时，会在何时的地方添加上分号；但是在不需要分隔符的换行上，JavaScript解释器就不会加上分号，例如：

```javascript
console.log("this is mydemo program..");
```

可以等价写成：

```javascript
console
.log("this is my demo program..")
```

在这个例子中，JavaScript就不会在console后面加上分号。

（3）JavaScript的注释写法

注释有两种方式：

- 使用`//`来单行注释
- 使用`/* ... */`来多行注释

