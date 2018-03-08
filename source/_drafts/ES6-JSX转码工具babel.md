---
title: ES6/JSX转码工具babel
date: 2018-03-08 19:11:01
tags:
categories: 前端工具
---

# babel简介

Babel是一个广泛使用的ES6转码器，可以将ES6代码转为ES5代码，从而在现有环境执行。这意味着，你可以用ES6的方式编写程序，又不用担心现有环境是否支持。Babel是所有ES6转换编译器中与ES6规范兼容度最高的，甚至超过了谷歌创建已久的Traceur编译器。Babel允许开发者使用ES6的所有新特性，而且不会影响与老版本浏览器的兼容性。

备注：可以说，有了Babel这一类转码工具，一些JS的最新的标准或特性，在没有被大多的浏览器厂商支持的情况下，让前端开发者提前使用上了这些新特性。

举例来说：

```javascript
// 转码前
input.map(item => item + 1);

// 使用Babel转码后
input.map(function (item) {
  return item + 1;
});
```

备注：上面的原始代码用了箭头函数，Babel将其转为普通函数，就能在不支持箭头函数的JavaScript环境执行了。

# babel的使用方法

Babel有两种使用方式，如下：

（1）直接安装babel的命令行工具，或结合webpack的babel-loader进行转码。

（2）在浏览器中直接转码。

在浏览器中转码时，需要在HTML中做如下配置：

```javascript
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.4.4/babel.min.js"></script>
<script type="text/babel">
// Your ES6 code
</script>
```

备注：从Babel6.0开始，不再直接提供浏览器版本，而是要用构建工具构建出来。即需要使用第一种方式来使用Babel，因为直接在浏览器中转码，会增加浏览器的性能损耗。

# babel工具在项目中基础配置

当需要在服务端使用babel对ES6进行转码时，我们首先需要配置babel的转码规则和插件。babel有两种配置方法，一种是配置.babelrc；另一种是在package.json中增加babel的配置。二者选择其一即可。

（1）.babelrc文件的配置

在项目的根目录中增加一个.babelrc文件，文件内容的基本格式如下：

```
{
  "presets": [],
  "plugins": []
}
```

presets字段设定转码规则，也就是从什么语法转换成浏览器能直接支持的原生JS，官方提供以下的规则集：

```bash
# ES2015转码规则
npm install --save-dev babel-preset-es2015

# react转码规则
npm install --save-dev babel-preset-react

# ES7不同阶段语法提案的转码规则（共有4个阶段），选装一个
npm install --save-dev babel-preset-stage-0
npm install --save-dev babel-preset-stage-1
npm install --save-dev babel-preset-stage-2
npm install --save-dev babel-preset-stage-3
```

假设我们的JS代码中有ES2015、JSX的语法，那么我们需要在.babelrc文件中增加如下内容：

```
{
    "presets": [
      "es2015",
      "react",
      "stage-2"
    ],
    "plugins": []
}
```

（2）在package.json中增加babel的配置

在package.json中增加babel的配置，需要在package.json中增加一个babel字段，形式如下：

```
{
  "name": "my-package",
  "version": "1.0.0",
  "babel": {
    // my babel config here
  }
}
```

# babel的项目实践

待补充。。

学习资料参考于：
http://www.infoq.com/cn/news/2015/05/ES6-TypeScript