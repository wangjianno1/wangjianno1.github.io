---
title: Nginx中URL重写rewrite模块
date: 2019-03-05 22:09:44
tags:
categories: Nginx
---

# Nginx rewrite模块简介

Nginx rewrite模块就是使用Nginx提供的全局变量或自己设置的变量，结合正则表达式和标志位实现URL重写以及重定向。rewrite模块包含的指令有break、if、return、rewrite、rewrite_log、set以及uninitialized_variable_warn。

rewrite模块的指令一般在server及location块指令里面。在server或location中包含了rewrite指令后，请求在server中处理顺序为：

    a）执行server块中的rewrite模块指令
    b）选择location
    c）location块中的rewrite模块的指令被执行
    d）如果在c）中请求uri被修改，那么会从b）继续往后执行，即重新选择location

备注：如上d）的循环不能超过10次，如果超过10次，就会返回浏览器500，内部服务器错误。

# break指令

break跳过当前上下文中所有ngx_http_rewrite_module模块的指令（如rewrite/if/return等等），但是其他模块指令是不受影响的。break有如下几点注意事项：

（1）break只对ngx_http_rewrite_module模块的指令有影响，对其他模块的指令没有影响；

（2）break指令可以在server/location/if上下文中，break只影响所属上下文中的ngx_http_rewrite_module模块的指令，例如server中break，不会影响到location的中重写相关的指令。值得注意的是，if语句块中的break，会影响到if所在的server或location中重写模块相关的指令。

# rewrite指令

rewrite指令只能放在`server{}`，`location{}`以及`if{}`中，并且只能对域名后边的除去传递的参数外的字符串起作用，例如`http://seanlook.com/a/we/index.php?id=1&u=str`，rewrite只对`/a/we/index.php`重写。

rewrite命令使用格式：

    rewrite regex replacement [flag];

其中regex是正则，用来匹配request uri，replacement是将匹配的uri替换为新的uri。flag可以为last、break、redirect和permanent。

（1）last

表示终止后续的rewrite模块的指令，且立即开始重新选择location，即实现Nginx内部的重定向，对用户来说是无感的哦

（2）break

表示终止后续的rewrite模块的指令，但是还会执行后续的非rewrite模块的指令，然后再开始重新选择location，也是实现Nginx的内部重定向。

（3）redirect

返回302临时重定向，浏览器地址栏会显示跳转后的地址。也即是外部重定向。

（4）permanent

返回301永久重定向，地址栏会显示跳转后的地址。也是外部重定向。

# return指令

return指令停止处理并将指定的HTTP码返回给浏览器。return指令的格式有：

    return code [text];
    return code URL;
    return URL

举例来说，`return 404`将返回给浏览器404错误页面。return也可以实现30X的重定向了。如果`return 444`，那么Nginx不会返回浏览器任何响应。

# if指令

if指令用来根据一定的条件，来执行一些指令，格式如下：

```
if (condition) 
{ 
    ... 
}
```

备注：理解rewrite模块一定要理解内部重定向和外部重定向

# set指令

设置指定变量的值。变量的值可以包含文本，变量或者是它们的组合形式。

学习资料参考于：
https://segmentfault.com/a/1190000008102599
