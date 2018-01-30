---
title: JAVA基础（3）_控制逻辑语句
date: 2018-01-30 19:04:52
tags: JAVA基础
categories: JAVA技术栈
---

# 顺序语句

# 条件语句

（1）if语句

结构一：

```java
if(expression) {
    //如果布尔表达式为true将执行的语句
}
```

结构二：

```java
if(expression) {
    //如果布尔表达式的值为true
} else {
    //如果布尔表达式的值为false
}
```

结构三：

```java
if(expression1) {
    //如果布尔表达式1的值为true执行代码
} else if(expression2) {
    //如果布尔表达式2的值为true执行代码
} else {
    //如果以上布尔表达式都不为true执行代码
}
```

（2）switch语句

```java
switch(expression) {
    case value:
        //语句
        break; //可选
    case value:
        //语句
        break; //可选
    default:   //可选
        //语句
}
```

# 循环结构

（1）while循环

```java
while(expression) {
    //循环内容
}
```

（2）do-while循环

```java
do {
    //代码语句
} while(expression);
```

（3）for循环

```java
for(初始化; 布尔表达式; 更新) {
    //代码语句
}
```

（4）增强for循环或foreach循环

```java
for(声明语句 : 表达式) {
    //代码句子
}
```

# 跳转语句

（1）break

结束整个循环体

（2）continue

结束本次循环，开始下一次循环

（3）return

回到方法调用处

