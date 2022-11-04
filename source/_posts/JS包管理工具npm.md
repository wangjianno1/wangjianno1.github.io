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

其中`~`和`^`两个前缀让人比较迷惑，简单的来说：

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

（2）修改npm的仓库源

npm官方的源地址是`http://registry.npmjs.org`。我们可以修改该源地址。有两种方式，一种使用`npm config`命令来修改如下：

```bash
npm config set registry https://registry.npm.taobao.org  # 修改为淘宝源
npm config set registry http://x.x.x.x:7001              # 修改为内网搭建的源
```

另一种是修改npm的配置文件`~/.npmrc`。

（3）package-lock.json

在工程中，和package.json同目录下，可能会有package-lock.json文件。假设某项目中packgae.json的配置的依赖是`"react": "^17.0.2"`，当我们执行npm install下载安装的版本是`17.0.2`，因为有标识符`^`，所以如果React模块有在17大版本下新的小版本，比如17.0.3，此时其他人再执行`npm install`时，会自动安装最新版本`17.0.3`。这是就会出现不同环境的依赖的具体版本出现了不同。npm install自动生成package-lock.json就是用来解决这种不一致的问题的，package-lock.json简单来说就是锁定安装模块的版本号。就是在npm install的时候，记录各个模块的版本信息和下载路径，这样别人拉项目npm install时候， 就会依据packgae-lock.json去安装依赖，保证大家依赖一致并且安装模块速度也能提高。

package-lock.json不是必需的，是在npm install时，npm自动生成的，当我们把package-lock.json提交到代码仓中，其他人获取到项目安装依赖时，一些依赖模块就会依据packjson-lock.json文件来下载依赖。

学习资料参考于：
http://www.cnblogs.com/youfeng365/p/5846674.html
http://www.ruanyifeng.com/blog/2016/10/npm_scripts.html