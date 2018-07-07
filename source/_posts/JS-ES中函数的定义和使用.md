---
title: JS/ES中函数的定义和使用
date: 2018-07-08 01:23:40
tags:
categories: JavaScript
---

# JS/ES中函数的定义

JavaScript中的函数，也称为函数对象，因为函数在JavaScript中是一个对象的数据类型。JavaScript中函数的定义有两种形式：

（1）函数声明式定义

```javascript
function add(x, y) {
    return a + b;
}
```

（2）函数表达式

```javascript
var add = function (a, b) {
    return a + b;
};
```

# ES6中箭头函数的定义和使用

ES6允许使用“箭头”（`=>`）来定义函数，称为是“箭头函数”。

（1）基本格式

```javascript
(参数1, 参数2, …, 参数N) => { 函数声明 }
(参数1, 参数2, …, 参数N) => 表达式（单一）  //等价于：(参数1, 参数2, …, 参数N) =>{ return 表达式; }
(单一参数) => {函数声明}   //当只有一个参数时，圆括号是可选的：单一参数 => {函数声明}
() => {函数声明}          //没有参数的函数应该写成一对圆括号。() => {函数声明}
参数 => ({foo: bar})      //加括号的函数体返回对象字面表达式
(参数1, 参数2, ...rest) => {函数声明}   //支持可变参数
(参数1 = 默认值1,参数2, …, 参数N = 默认值N) => {函数声明}   //支持默认参数和可变参数
```

（2）举例说明

//#1

```javascript
//ES6写法
var f = v => v;
```

```javascript
//等同于ES5代码
var f = function(v) {
  return v;
};
```

//#2

```javascript
//ES6,如果函数不需要参数，就直接用圆括号括起来
var f = () => 5;
```

```javascript
//等同于ES5代码
var f = function () { return 5 };
```

//#3

```javascript
//ES6
var sum = (num1, num2) => num1 + num2;
```

```javascript
//等同于ES5代码
var sum = function(num1, num2) {
  return num1 + num2;
};
```

//#4

```javascript
//ES6, 若函数体有多行语句，则使用花括号括起来
var sum = (num1, num2) => { return num1 + num2; }
//ES6, 若函数需要返回对象，为了和上面的区分，需要再在外面加上圆括号
var getTempItem = id => ({ id: id, name: "Temp" });
```

# JS/ES中函数的特殊用法

（1）立即执行函数表达式

定义函数后会立即执行啦，形式如下：

```javascript
(function() {
    //do something
})();
```

（2）命名式的函数表达式

```javascript
var add =function foo (a,b) {
    //do something
};
```

（3）将函数表达式作为`return`返回值

```javascript
return function() {
    //do something
};
```

学习资料参考于：
https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Functions/Arrow_functions
