---
title: JAVA语言中数组的使用
date: 2018-01-30 19:14:20
tags: JAVA基础
categories: JAVA
---

# 数组变量的声明和初始化（分开）

（1）数据变量的声明

```java
dataType[] arrayRefVar;   // 首选的方法

dataType arrayRefVar[];   // 效果相同，但不是首选方法
```

（2）数组变量的初始化

```java
arrayRefVar = new dataType[arraySize];

arrayRefVar = new dataType[]{var1, var2, var3, ....};
// arrayRefVar = new dataType[2]{var1, var2}; //这种写法不可以哦，注意

// arrayRefVar = {var1, var2, var3, ....}; //这种写法不可以哦，注意
```

# 数组变量的声明和初始化（合并）

```java
dataType[] arrayRefVar = new dataType[arraySize];
dataType arrayRefVar[] = new dataType[arraySize];

dataType[] arrayRefVar = new dataType[] { value0, value1, ..., valuek };
dataType arrayRefVar[] = new dataType[] { value0, value1, ..., valuek };
// dataType[] arrayRefVar = new dataType[2] { value0, value1 }; //这种写法不可以哦，注意
// dataType arrayRefVar[] = new dataType[2] { value0, value1 }; //这种写法不可以哦，注意

dataType[] arrayRefVar = { value0, value1, ..., valuek };
dataType arrayRefVar[] = { value0, value1, ..., valuek };
```

# 举例来说

```java
int size = 10;

// 定义数组
double[] myArr = new double[size];
myArr[0] = 5.6;
myArr[1] = 4.5;
myArr[2] = 3.3;

myArr.length;  // 获取数组的长度
```

# 一点闲杂

（1）java.util.Arrays提供了一些操纵数组的静态方法。举例来说：

```java
Arrays.sort(Object[] array)  // 排序数组
Arrays.sort(Object[] array, int from, int to)  // 对数组指定范围的元素进行排序
Arrays.toString(Object[] array)  // 返回数组的字符串形式
static <T> List<T>	asList(T... a)  // 用给定的数组构造一个List对象
// ...
```
