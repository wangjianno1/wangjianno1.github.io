---
title: JAVA语言中控制逻辑语句
date: 2018-01-30 19:04:52
tags: JAVA基础
categories: JAVA
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

当变量的值与case语句的值相等时，那么case语句之后的语句开始执行，直到break语句出现才会跳出switch语句。当遇到break语句时，switch语句终止，程序跳转到switch语句后面的语句执行。case语句不必须要包含break语句，如果没有break语句出现，程序会继续执行下一条case语句，直到出现break语句。代码举例如下：

```java
public class Test {
   public static void main(String args[]){
      //char grade = args[0].charAt(0);
      char grade = 'C';
 
      switch(grade) {
         case 'A' :
            System.out.println("优秀"); 
            break;
         case 'B' :
         case 'C' :
            System.out.println("良好");
            break;
         case 'D' :
            System.out.println("及格");
            break;
         case 'F' :
            System.out.println("你需要再努力努力");
            break;
         default :
            System.out.println("未知等级");
      }
      System.out.println("你的等级是 " + grade);
   }
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

代码举例如下：

```java
String[] fruits = {"Apple", "Banana", "Watermelon", "Orange"};
for (String fruit : fruits) {
    System.out.println(fruit);
}
```

# 跳转语句

（1）break

结束整个循环体

（2）continue

结束本次循环，开始下一次循环

（3）return

回到方法调用处

