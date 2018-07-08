---
title: React中JSX
date: 2018-07-08 22:29:59
tags:
categories: ReactJS
---

# JSX
JSX，全称是JavaScript XML，JSX是对JavaScript语法的扩展。JSX和CoffeeScript、TypeScript类似，它们最终被转换成JavaScript后被浏览器解释执行。可以说他们是JavaScript是语法糖。React WEB APP开发不一定要使用JSX，但一般建议使用。更简单来说，JSX并不是一个模板语言，是语法糖，JSX能够让开发者在JavaScript代码中直接编写HTML标签。举例来说：

```javascript
ReactDOM.render(
    <h1>Hello, world!</h1>,
    document.getElementById('example')
);
```

# JSX中className

在JSX中HTML代码，并非真实的DOM结构，是虚拟的DOM，它是要被React框架解析后并挂载到DOM上才可以的。我们知道在普通的HTML标签中，要为某个标签设置CSS样式，可以为该标签定义一个class的属性，然后再CSS中通过该class找到HTML元素，并设置样式。但是在ES6中，class是一个关键字，我们就不能直接为HTML标签或者我们通过React自定义的组件设置class属性啦，而是要换成className的属性，然后在CSS中，通过className属性来设置样式。

普通的HTML中，如下：

```html
<div class="submit_button"></div>
```

在JSX中，要是用className，替代class，如下：

```javascript
<div className="submit_button"></div>
```

# JSX中花括号`{}`

在JSX中的花括号`{}`是用来表示去JS表达式的值，如`{this.state.xxoo}`表示获取组件State中的xxoo的属性值。当我们要获取一个对象时，就会出现出现两个花括号，如下

```javascript
{{foo: 122, bar: 'kaka'}} //外面的花括号的含义同前面，里面的花括号是对象自己的花括号啦。
```

备注：其实JSX中花括号`{}`中内容是JS代码，可能会表达式，也可能是一行JS语句等。

