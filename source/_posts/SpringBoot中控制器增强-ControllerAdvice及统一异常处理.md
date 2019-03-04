---
title: SpringBoot中控制器增强@ControllerAdvice及统一异常处理
date: 2019-03-04 14:56:14
tags:
categories: SpringBoot
---

# @ControllerAdvice简介

@ControllerAdvice，是Spring3.2提供的新注解，从名字上可以看出大体意思是控制器增强。@ControllerAdvice的定义如下所示：

```java
@Target(value=TYPE)
@Retention(value=RUNTIME)
@Documented
@Component
public @interface ControllerAdvice
```

从@ControllerAdvice定义可以看出，被@ControllerAdvice注解的类会是一个Component，即会被Spring容器管理。

@ControllerAdvice是一个@Component，可以配合@ExceptionHandler，@InitBinder或@ModelAttribute注解，来实现增强控制器的功能，适用于所有使用@RequestMapping的控制器方法。

Spring4之前，@ControllerAdvice在同一调度的Servlet中的所有的控制器controller进行增强。但Spring4已经改变，@ControllerAdvice支持配置控制器controller的子集，若不配置子集，则会对所有控制器有效。在Spring4中，@ControllerAdvice通过annotations()，basePackageClasses()，basePackages()方法定制用于选择控制器子集。

# 使用@ControllerAdvice+@ExceptionHandler来实现统一异常处理

如下为使用@ControllerAdvice+@ExceptionHandler来实现SprintBoot项目的统一异常处理：

```java
class GlobalProcessException extends RuntimeException {    
    public GlobalProcessException(String message) {
        super(message);
    }
}

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(value=GlobalProcessException.class)
    @ResponseBody
    public ResultBody<Object> handleProcessException(Exception ex, HttpServletRequest request) {
        return ResultUtil.exception(ex.getMessage());
    }
     
    @ExceptionHandler(value=Exception.class)
    @ResponseBody
    public ResultBody<Object> handleUnknownException(Exception ex, HttpServletRequest request) {
        return ResultUtil.error();
    }
}
```

备注：ExceptionHandler表示该增强Controller可以捕获什么类型的异常。在上面的例子中，当controller层抛出GlobalProcessException或Exception异常时，就会被增强Controller GlobalExceptionHandler所捕获，然后按照方法内容进行处理并将处理结果返回给浏览器。使用@ResponseBody可以返回json格式的数据内容到浏览器。

学习资料参考于：
http://www.spring4all.com/article/1477
