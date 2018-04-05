---
title: JS包管理工具npm
date: 2018-02-05 20:43:08
tags:
categories: 前端工具
---

# npm简介

npm，全称为node package manager，是Node的模块管理器，也可以说是JavaScript的包管理工具。npm体系有npm工具客户端和npm包仓库两部分。npm包官方仓库为`https://www.npmjs.com`，使用npm客户端工具可以在本地安装、删除JavaScript包，功能非常强大。

# npm客户端工具的安装

npm客户端工具并不需要单独安装。安装完nodejs后，会连带将npm工具安装好。通常来说，这样得到的npm版本比较低。我们可以通过如下命令来升级npm：

```bash
npm install npm@latest -g
```

# npm工具的一些常用操作命令

```bash
npm install express -g          #安装npm包到全局目录
npm install express             #安装npm包到当前目录中的./node_modules
npm install express@3.0.6       #安装指定版本的npm包
npm install express@latest      #表示要下载最新的版本
npm install express --save-dev  #安装npm包到当前目录中的./node_modules中，并将依赖关系写入到当前目录的package.json的devDependencies中
npm install express --save-prod #安装npm包到当前目录中的./node_modules中，并将依赖关系写入到当前目录的package.json的dependencies中
npm install express --no-save   #安装npm包到当前目录中的./node_modules中，但不将依赖写入到devDependencies或dependencies中。npm install默认是带--save-prod的
npm install                     #若获取到一个npm package源码，执行npm install可以安装该项目所有的依赖
npm uninstall express           #卸载npm包

npm update express              #升级npm包
npm search express              #搜索npm包

npm init          #初始化，生成package.json文件
npm adduser       #向npm远程仓库注册用户
npm publish       #向npm远程仓库发布npm包

npm list -g       #查看全局安装了哪些npm包
npm list          #查看当前目录中安装了那些npm包
npm list express  #查看某个npm包的版本
```

另外，关于npm install package@version的版本问题还有一个特殊注意的地方：

```
npm install package@*       #表示安装最新的版本，相当于npm install package@latest
npm install package@1.1.0   #表示安装指定的版本，本例中即1.1.0
npm install package@~1.1.0  #表示满足>=1.1.0 && < 1.2.0条件中最新的版本号
npm install package@^1.1.0  #表示满足>=1.1.0 && < 2.0.0条件中最新的版本号
```

其中~和^两个前缀让人比较迷惑，简单的来说：

	~ 前缀表示，安装大于指定的这个版本，并且匹配到x.y.z中z最新的版本
	^ 前缀在^0.y.z时的表现和~0.y.z是一样的，然而^1.y.z的时候，就会匹配到y和z都是最新的版本

# package.json

npm管理的JavaScript模块包中会包含一个package.json文件，该文件包括了该package包的名称、版本、作者、该包的依赖等等信息，如下为package.json常见的属性配置：

```bash
name             #包名
version          #包的版本号
description      #包的描述
homepage         #包的官网url
author           #包的作者姓名
contributors     #包的其他贡献者姓名
dependencies     #依赖包列表。如果依赖包没有安装，npm 会自动将依赖包安装在node_module目录下
devDepandencies  #开发环境依赖的npm包，例如测试用的npm包等
repository       #包代码存放的地方的类型，可以是git或svn，git可在Github 上
main             #main字段是一个模块ID，它是一个指向你程序的主要项目。就是说，如果你包的名字叫express，然后用户安装它，然后require("express")
keywords         #关键字
license          #许可证
scripts          #定义npm script脚本，然后通过npm run *来执行
```

# npm包script脚本

举例来说，如下是一个package.json的scripts脚本段

```bash
{
    // ...
    "scripts": {
        "build": "node build.js" ,
        "test": "test command here",
        "xxoo": "xxoo command here"
    }
}
```

我们可以通过`npm run build`、`npm run test`、`npm run xxoo`来分别执行。

值得注意的是，npm scripts脚本段有两个默认的配置，如下（前提是目录下有server.js或node-gyp才可以）：

```bash
"start": "node server.js"，
"install": "node-gyp rebuild"
```

# npm闲杂问题

（1）npm代理设置

```bash
npm search express --proxy http://10.17.29.112:3128
```

详细参考于：
http://www.cnblogs.com/youfeng365/p/5846674.html
http://www.ruanyifeng.com/blog/2016/10/npm_scripts.html