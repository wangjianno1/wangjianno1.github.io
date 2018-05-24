---
title: JAVA语言中数组的使用
date: 2018-01-30 19:14:20
tags: JAVA基础
categories: JAVA
---

# 数组变量的声明

```java
dataType[] arrayRefVar;   // 首选的方法
```

或

```java
dataType arrayRefVar[];  // 效果相同，但不是首选方法
```

# 数组变量的初始化

```java
arrayRefVar = new dataType[arraySize];
```

# 数组的声明和初始化

```java
dataType[] arrayRefVar = new dataType[arraySize];
dataType arrayRefVar[] = new dataType[arraySize];
dataType arrayRefVar[] = {value0, value1, ..., valuek};
```

# 举例来说

```java
int size = 10;

// 定义数组
double[] myList = new double[size];
myList[0] = 5.6;
myList[1] = 4.5;
myList[2] = 3.3;
```
