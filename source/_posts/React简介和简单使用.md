---
title: React简介和简单使用
date: 2018-07-08 12:49:20
tags:
categories: ReactJS
---

# React简介

React是一个用于构建用户界面的JAVASCRIPT库。 React主要用于构建UI，很多人认为React是MVC中的V（视图）。 React拥有较高的性能，代码逻辑非常简单，越来越多的人已开始关注和使用它。React最核心的场景就是开发widget，或者说组件，大型React项目本质上就是有widget堆积而成，面向组件的开发模式。也就是说，React的核心理念是组件式开发，通过React构建组件，使得代码更加容易得到复用，能够很好的应用在大项目的开发中。

React的主要发展历程如下：

```
2013.6 Facebook官方发布React
2013.9 React热度开始上涨
2015.3 React Native发布，用React来编写跨平台的移动端应用，即使用React编写IOS，Android，Windows Phone应用
```

备注：React是单向数据绑定，而AngularJS是双向绑定。

# React的HelloWorld

```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Hello React!</title>
        <script src="https://cdn.bootcss.com/react/15.4.2/react.min.js"></script>
        <script src="https://cdn.bootcss.com/react/15.4.2/react-dom.min.js"></script>
        <script src="https://cdn.bootcss.com/babel-standalone/6.22.1/babel.min.js"></script>
    </head>
    <body>
        <div id="example"></div>
        <script type="text/babel">
            ReactDOM.render(
              <h1>Hello, world!</h1>,
              document.getElementById('example')
            );
        </script>
    </body>
</html>
```

# React官网上推荐的创建React项目的方法

React官网上推荐的创建React项目的步骤如下：

（1）安装npm工具

（2）执行如下命令

```bash
npm install -g create-react-app
create-react-app my-app
cd my-app
npm run start  #启动了web-app
```

（3）访问测试

浏览器输入`http://ip:port/`来访问页面，效果如下：

![](/images/react_1_1.png)

备注：在实际项目中，不推荐这种方式，可以使用一些脚手架来初始化一个React项目，也可以使用已有的项目来构建一个初始化的React项目，如`https://github.com/wangjianno1/fifa-fe`或`https://github.com/wangjianno1/houyi-fe`。

# React中的一些重要概念

（1）React elements  - React元素

React elements类似如下形式，可以简单理解成是一段html标签。

```javascript
const element = <h1>Hello, world</h1>;
```

（2）React Components  - React组件

React组件可以是函数组件，也可以是Class组件。组件可以被用来重用哦。一个组件的输入是JavaScript对象，输出是一个React元素。举例来说：

```javascript
// functional式React组件
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}
```

```javascript
// class式React组件
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

备注：`React.createClass`方法也可以生成一个组件类。

# React开发包的结构

React package被拆分为react及react-dom两个package。其中react package中包含React.createElement、.createClass、.Component、.PropTypes以及.Children等这些API，而react-dom package中包含ReactDOM.render、.unmountComponentAtNode、.findDOMNode等这些API。一般来说，React项目是放在服务端转码成原生JS后再在浏览器端执行，当然React也可以直接在浏览器端解释执行，则react对应的是react.min.js，react-dom对应的是react-dom.min.js。

参考资料来源于：
https://github.com/ruanyf/jstraining/blob/master/docs/react.md （非常好的React技术栈的说明）
