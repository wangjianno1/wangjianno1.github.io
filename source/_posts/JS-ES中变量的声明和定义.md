---
title: JS/ES中变量的声明和定义
date: 2018-07-08 00:29:33
tags:
categories: JavaScript
---

# JS/ES中变量声明和定义

ES5中只有两种声明变量的方法，即var命令和function命令。ES6中除了var/funtion命令，还增加了let/const/import/class命令。因此ES6一共有6种声明变量的方法。

# var

```javascript
var a;
var a= 4;
var a, b;
var a = 4; b = 8;
```

备注，需要注意的是var关键字声明的变量是全局变量，即使var语句在代码段中。

# let

ES6新增了let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效。也就是是一个局部变量。举例来说：

```javascript
for (let i = 0; i < 10; i++) {
    // ...
}
```

备注：let声明的变量i只在for循环体中有效。而在JS中var声明的变量，会有变量提升的问题，即var声明的变量会是全局变量。

# const

const声明一个只读的常量。一旦声明，常量的值就不能改变。举例来说：

```javascript
const PI = 3.1415;
const obj = {aaa: 1, bbb:2};
```

备注：声明的PI变量，之后是不可以修改的。这里需要注意的是，const常量指定是变量的引用不可以修改，但是变量的内部属性可以变化，如下：

```javascript
const obj = {aaa: 1, bbb:2}; 
obj = {ccc: 1, ddd: 3};   //报错，因为修改了常量obj的引用
obj.aaa = 3;      //没问题，因为只是修改了变量内部的属性，和Java中final常量差不多啦
```

# function

参见JS/ES中函数的定义。

# import

和export关键字一起，构成了ES6标准中模块化编程。

```javascript
import React, { Component } from 'react';
import { Table, Badge, Button, Modal, Divider } from 'antd';
```

# class

参见JS/ES中类编程。
