---
title: JAVA语言中各种数据类型
date: 2018-01-30 19:02:36
tags: JAVA基础
categories: JAVA
---

# 基本数据类型

|数据类型|关键字|占用空间(字节）|包装类型|
|:----|:---|:---|:---|
|整型|byte|1|Byte|
|整型|char|2|Character|
|整型|short|2|Short|
|整型|int|4|Integer|
|整型|long|8|Long|
|浮点型|float|8|Float|
|浮点型|double|8|Double|
|布尔型|boolean|8|Boolean|

备注：byte/char/short/int/long都是整型数据类型，因占用存储空间的不同，所能代表的取值范围也是不同的。char和short虽然都占2个字节，但是char是无符号的整型，而short是有符号的整型，因此char和short的取值范围也是不同的。

**在Java中，整数字面值常量默认的数据类型是int，小数字面值常量默认的数据类型是double。**

当声明`long a = 23`时，23是int类型，属于小类型往大类型转换，Java可以自动转换，但是当后字面值常量大于int的范围时，就会报错了，因此当声明long类型的变量时，在后面加上`L/l`，即`long a = 23L`，`23L`就是一个long类型的字面值常量，这样就不存在类型的自动转换了。

当声明`float a = 2.3`时，2.3是double类型，属于大类型往小类型转换，这就可能会造成精度丢失，编译时会直接报错，因此当声明float类型的变量时，在后面加上`F/f`，即`float a = 2.3F`，`2.3F`就是一个float类型的字面值常量，这样就不存在类型的自动转换了。

# 抽象数据类型ADT

```
类/对象
```
