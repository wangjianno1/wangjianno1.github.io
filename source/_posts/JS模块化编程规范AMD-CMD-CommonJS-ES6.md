---
title: JS模块化编程规范AMD | CMD | CommonJS | ES6
date: 2018-02-05 20:20:50
tags:
categories: JavaScript
---

随着JS模块化编程的发展，处理模块之间的依赖关系成为了维护的关键，而原生的JavaScript是没有模块化编程的支持，直到ES6中才有了模块化编程的支持。社区中也有很多JS的模块化编程的规范，如AMD、CMD、CommonJS是目前最常用的三种模块化书写规范。

# CommonJS

CommonJS规范是诞生比较早的。NodeJS就采用了CommonJS。是这样加载模块：

```javascript
var clock = require('clock');
clock.start();
```

这种写法适合服务端，因为在服务器读取模块都是在本地磁盘，加载速度很快。但是如果在客户端，加载模块的时候有可能出现“假死”状况。比如上面的例子中clock的调用必须等待clock.js请求成功，加载完毕。那么，能不能异步加载模块呢？

# AMD

AMD，英文全称为Asynchronous Module Definition，这种规范是异步的加载模块，requireJS应用了这一规范。先定义所有依赖，然后在加载完成后的回调函数中执行：

```javascript
require([module], callback);
```

用AMD写上一个模块：

```javascript
require(['clock'], function(clock){
    clock.start();
});
```

AMD虽然实现了异步加载，但是开始就把所有依赖写出来是不符合书写的逻辑顺序的，能不能像commonJS那样用的时候再require，而且还支持异步加载后再执行呢？

# CMD
CMD，Common Module Definition，是seajs推崇的规范，CMD则是依赖就近，用的时候再require。它写起来是这样的：

```javascript
define(function(require, exports, module) {
    var clock = require('clock');
    clock.start();
});
```

AMD和CMD最大的区别是对依赖模块的执行时机处理不同，而不是加载的时机或者方式不同，二者皆为异步加载模块。

AMD依赖前置，js可以方便知道依赖模块是谁，立即加载；而CMD就近依赖，需要使用把模块变为字符串解析一遍才知道依赖了那些模块，这也是很多人诟病CMD的一点，牺牲性能来带来开发的便利性，实际上解析模块用的时间短到可以忽略。

# ES6的模块化编程

（1）ES6模块编程简介

JavaScript一直没有模块（module）体系，无法将一个大程序拆分成互相依赖的小文件，再用简单的方法拼装起来。其他语言都有这项功能，比如Ruby的require、Python的import，甚至就连CSS都有@import，但是JavaScript任何这方面的支持都没有，这对开发大型的、复杂的项目形成了巨大障碍。 在ES6之前，社区制定了一些模块加载方案，最主要的有CommonJS和AMD两种。前者用于服务器，后者用于浏览器。ES6在语言标准的层面上，实现了模块功能，而且实现得相当简单，完全可以取代CommonJS和AMD规范，成为浏览器和服务器通用的模块解决方案。

ES6模块的设计思想，是尽量的静态化，使得编译时就能确定模块的依赖关系，以及输入和输出的变量。CommonJS和AMD模块，都只能在运行时确定这些东西。ES6模块不是对象，而是通过export命令显式指定输出的代码，再通过import命令输入。

（2）export和import

ES6的模块功能主要由两个命令构成，即export和import。export命令用于规定模块的对外接口，import命令用于输入其他模块提供的功能。说白了，export是显式地说明模块中有哪些变量、函数、类要暴露出来，用来给其他模块使用。而import是导入其他模块中被export的实体。举例来说：

```javascript
export var firstName = 'Michael';
export function multiply(x, y) {
    return x * y;
};
import {firstName, lastName, year} from './profile';  //从./profile.js中导入模块接口firstName, lastName, year
import {myMethod} from 'util';  //这里util是模块名，而不是一个js文件
```

备注：import后面的from指定模块文件的位置，可以是相对路径，也可以是绝对路径，.js路径可以省略。如果只是模块名，不带有路径，那么必须有配置文件，告诉JavaScript引擎该模块的位置。

（3）export default

使用import命令的时候，用户需要知道所要加载的变量名或函数名，否则无法加载。但是，用户肯定希望快速上手，未必愿意阅读文档，去了解模块有哪些属性和方法。为了给用户提供方便，让他们不用阅读文档就能加载模块，就要用到export default命令，为模块指定默认输出。举例来说：

```javascript
// file1.js, 使用export default导出默认的接口
export default function () {
    console.log('foo');
}
```

```javascript
// file2.js, import不用严格指定和export中同样的名字，可以随便地取一个名字，注意这里就不需要用花括号括起来了
import customName from './export-default';
customName();
```

（4）index.js

如果一个JS APP的目录结构为：

```bash
|- reducers
    |- index.js
    |- test1.js
    |- test2.js
```

那么我们可以在另外一个JS文件中，使用`import * from '/reducers'`语句，可以自动导入index.js中的接口。其中*可以是任意的名字。


学习资料参考于：
http://www.jianshu.com/p/09ffac7a3b2c
