---
title: SPA项目打包工具webpack
date: 2018-03-07 19:25:22
tags:
categories: 前端工具
---

# webpack

webpack是一个JavaScript应用程序的模块打包器(module bundler)。当webpack处理应用程序时，它会递归地构建一个资源依赖关系图表(dependency graph)，其中包含应用程序需要的每个模块，然后将所有这些模块打包成少量的bundle。通常只有一个，由浏览器加载。简单来说，webpack是一个前端资源加载、打包工具，主要是用来打包在浏览器端使用的javascript的，同时也能转换、捆绑、打包其他的静态资源，包括css、image、font file、template等。另外可以通过自己开发loader和plugin来满足自己个性化的需求。

![](/images/webpack_1_1.png)

# webpack的安装和使用

前提申明，这里演示的是webpack 2.4.1版本。

（1）安装

使用npm安装即可，执行命令`npm install webpack`

备注：当在本地安装webpack后，能够从node_modules/.bin/webpack访问webpack的可执行bin文件，后面如果需要在命令行中直接执行webpack命令时，可以使用`node_modules/.bin/webpack`来执行。

（2）准备js/css/img等资源文件

（3）编写webpack配置文件

（4）执行webpack命令，开始打包资源文件

webpack打包命令范例如下：

```bash
webpack --config webpack.config.js --progress --colors
webpack-dev-server --config webpack-dev-server.config.js --progress --inline --colors
```

备注：也可以将webpack的命令写入到npm的package.json中，需要打包前端资源时，只要执行`npm run scriptname`即可

# webpack中的一些其他概念

（1）入口Entry

（2）输出

（3）loader

loader是在webpack对web项目打包过程中，用来对一些静态文件(js/css/img等等)做特殊的处理。例如将es6转换成es5的loader，将scss/less转成css的loader，对图片压缩或base编码的loader等等。

（4）插件plugins

（5）模块

.....

# 一个简单的webpack的配置文件

```javascript
//webpack.config.js
const config = {
    entry:{
        bundle :'./index.js',
    },
    output:{
        path:'./target',
        filename:'[name].js'
    }
}
module.exports = config;
```

备注：其实config就是一个遵循CommonJS的规范的JS模块。webpack是根据config里面描述的内容对一个项目进行打包的。上述配置文件表示，webpack要打包的前端WEB APP的入口文件是index.js，webpack会从这个文件开始来生成整个WEB APP的依赖关系图表。output表示打包完成后，文件的输出路径以及文件名。

一个config文件，基本是由以下几个配置项组成的：

（1）entry

配置要打包的文件的入口，可以配置多个入口文件。

（2）output

配置经过webpack打包后产出的文件的存储路径和文件名等。

（3）module(loaders)

配置要使用的loader，以对文件进行一些相应的处理。比如babel-loader可以把es6的文件转换成es5。大部分的对文件的处理的功能都是通过loader实现的。loader可以用来处理在入口文件中require进来或其他方式引用进来的文件。loader一般是一个独立的node模块，要单独安装。

（4）plugins

配置webpack要使用的插件。

# webpack监测项目变化，自动重新打包

webpack中提供了几种方式，可以帮助我们在代码发生变化后自动重新打包代码，分别如下：

（1）webpack Watch Mode

要使用这样方式，只需要在webpack命令后加上--watch参数即可。例如：

```bash
webpack --config webpack.config.js --watch --progress --colors
```

（2）webpack-dev-server

webpack-dev-server是webpack官方提供的一个小型Express服务器，webpack-dev-server是一个独立的工具，需要使用npm install来安装。使用它可以为webpack打包生成文件以及其他的一些静态资源文件提供web服务。webpack-dev-server主要提供两个功能：

+ 为静态文件提供WEB服务

+ 自动刷新和热替换(HMR)

自动刷新指的是，每次修改代码后，webpack可以自动重新打包 ，且浏览器可以响应代码变化并自动刷新。而当我们使用webpack-dev-server的自动刷新功能时，浏览器会整页刷新，热替换（HMR）的区别就在于，当前端代码变动时，无需刷新整个页面，只把变化的部分替换掉。

webpack-dev-server提供了iframe和inline两种自动刷新模式。iframe模式是默认的模式，页面被嵌套在一个iframe下，使用此模式无需额外配置，只需访问`http://localhost:8080/webpack-dev-server/index.html`即可。inline模式需要在启动webpack-dev-server加上inline参数。

热替换（HMR）则需要启动webpack-dev-server时加上hot参数。

我们可以在webpack.config.js中添加一端devserver的配置，其中contentBase指定了webpack-dev-server作为web服务器的DocumentRoot。

备注：当我们使用webpack-dev-server来启动我们的项目时，webpack-dev-server会自动监视我们文件的变化，若某个文件被修改后，webpack-dev-server会自动重新打包文件，但是不会在本地生成打包后的bundle文件，只会在内存中生成bundle文件，因此我们需要在html中使用`http://localhost:8080/bundle.js`路径来访问，也就是src=/bundle.js即可。也就是我们使用webpack-dev-server仅仅做开发调试，也没必要生成本地bundle文件，所以webpack-dev-server只在内存中生成。当调试完毕后，我们再执行webpack打包出bundle本地文件就好了。

（3）webpack-dev-middleware

通常来说，我们在项目开发中使用webpack-dev-server比较多一些。

# webpack中遇到的一些知识点

（1）source map

当使用webpack打包源代码时，可能会很难追踪到错误和警告在源代码中的原始位置。例如，如果将三个源文件（a.js,b.js和c.js）打包到一个 bundle（bundle.js）中，而其中一个源文件包含一个错误，那么堆栈跟踪就会简单地指向到 bundle.js。这并通常没有太多帮助，因为你可能需要准确地知道错误来自于哪个源文件。 为了更容易地追踪错误和警告，JavaScript提供了source map功能，将编译后的代码映射回原始源代码。如果一个错误来自于 b.js，source map就会明确的告诉你。

在webpack的config中，是通过devtool这个参数来指定一种source map（也即是在webpack.config.js中的devtool参数）。webpack中有很多种source map可以选择，举例来说：

![](/images/webpack_1_2.png)

# webpack在实践中的一些最佳实践

（1）一般来说，我们根据部署环境的不同，分别创建`webpack-dev.config.js`、`webpack-test.config.js`以及`webpack-prod.config.js`三个webpack的配置文件，分别代表开发环境/测试环境/生产环境的webpack配置文件。

（2）有时我们需要在使用webpack打包的过程中，进行一个文件copy的操作，例如我们需要将src中的一些文件copy到webpack的output目录中，我们就可以使用一个webpack的第三方plugins，名称为TransferWebpackPlugin，官网地址为`https://github.com/molforp/transfer-webpack-plugin`.
