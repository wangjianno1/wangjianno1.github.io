---
title: JS/ES中操作符|表达式|语句
date: 2018-07-08 00:29:44
tags:
categories: JavaScript
---

# 操作符

Javascript中有的操作符不限于下面这些：

a).基础运算符

`+`，`-`，`*`，`/`，`+=`，`|`等。

b).特殊运算符

`c?a:b`，`delete`，`in`，`instanceof`，`typeof`，`new`，`this`，`void`等。

# 表达式

表达式有如下几种：

（1）原始表达式

例如`b + c`

（2）对象和数据初始化表达式

例如，

```javascript
["east","west", "north", "south"]
{a: 3, b:4}
```

（3）函数定义表达式

例如，

```javascript
var square = function(x){return x * x;}
```

（4）对象创建表达式

```javascript
new Object()
newPoint(2, 3)
new Object
new Date
```

如果后面的函数不需要传递参数的话，可以省略不写。

（5）。。。

# JavaScript中的语句

（1）块语句

用来组合多个语句。形式如下：

```javascript
{
    语句1;
    语句2;
    …
    语句n;
}
```

备注：Javascript中没有块级作用域。

（2）var变量声明语句

```javascript
var a = 1;
var a = 1; b = 3;
```

（3）try-catch-finally语句

有三种形式：

```
try-catch语句
try-finally语句
try-catch-finally语句
```

例如，

```javascript
try {
    throw "test";
} catch(ex) {
    console.log(ex);
} finally {
    console.log("finally");
}
```

（4）函数定义语句

```javascript
function fd() {
    //do something
    return true;
}
```

（5）循环语句

```javascript
//while
while(expr){
    //do something
}

//do-while
do {
    //do something
} while(expr)

//for语句
for (i =0; i < n; i++) {
    //do something
}
```

（6）switch语句

（7）with语句
