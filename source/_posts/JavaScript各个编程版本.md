---
title: JavaScript各个编程版本
date: 2018-02-05 20:40:05
tags:
categories: JavaScript
---

# JavaScript各个编程版本

（1）原生JS

就是常说的JavaScript，也称为ECMAScript，即ES5.1版及以前的JS版本。

（2）ES6

ES6既是一个历史名词，也是一个泛指，含义是5.1版以后的JavaScript的下一代标准，涵盖了ES2015、ES2016、ES2017等等，其中 ES20XX则是正式名称，特指该年发布的正式版本的语言标准。

（3）TypeScript

微软开发的。

（4）CoffeeScript

（5）JSX

facebook React项目中定义的。

# 各个JavaScript版本的关系

其实ES6/TypeScript/CoffeeScript/JSX可以说都是基于原生JS的语法糖，它们能够实现的功能使用原生的JS同样可以完成。但是原生JS编写效率、学习成本等等有一定的问题。所以在当前的前端开发项目中，一般会选择ES6/TypeScript/CoffeeScript/JSX等其中的一种语言去开发，然后通过前端或服务端转码工具（如Babel）将其转换成原生的JS语法，浏览器才可以支持，否则浏览器会不完全支持。另外，ES官方每年都会发布一版ES，以ES+年份命名，例如ES2015、ES2016、ES2017等等。

# 目前JavaScript编程规范迭代方式

任何人都可以向标准委员会（又称TC39委员会）提案，要求修改语言标准。一种新的语法从提案到变成正式标准，需要经历五个阶段。每个阶段的变动都需要由TC39委员会批准。

	Stage 0 - Strawman（展示阶段）
	Stage 1 - Proposal（征求意见阶段）
	Stage 2 - Draft（草案阶段）
	Stage 3 - Candidate（候选人阶段）
	Stage 4 - Finished（定案阶段）

一个提案只要能进入Stage 2，就差不多肯定会包括在以后的正式标准里面。ECMAScript当前的所有提案，可以在TC39的官方网站github.com/tc39/ecma262中查看。

