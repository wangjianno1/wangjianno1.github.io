---
title: 使用Hexo搭建自己的Blog站点
date: 2018-01-28 23:11:37
tags: 搭建个人站点
categories: 杂货铺
---

# Hexo简介

Hexo是一个快速、简洁且高效的博客框架。Hexo使用Markdown（或其他渲染引擎）解析文章，在几秒内，即可利用靓丽的主题生成静态网页。简单来说，我们在Hexo框架内编写MarkDown格式的文档，然后使用Hexo帮我们生产静态的WEB资源（如HTML/CSS/JS等）。使用这些静态WEB页面，我们就可以部署个人WEB站点。

Hexo出自台湾大学生tommy351之手，是一个基于Node.js的静态博客程序，其编译上百篇文字只需要几秒。Hexo是类似于Jekyll，Octopress这样的东东哦，但Hexo目前比较流行。

# Hexo环境的搭建

如下为在Windows环境搭建hexo环境的步骤：

（1）安装git工具

要将git bash工具一同安装上。

（2）安装node.js

安装node并配置PATH环境变量。

（3）安装Hexo

在Windows命令提示符中执行命令`npm install -g hexo-cli`即可。

备注：然后使用hexo new命令创建文章以及提交github等操作都是在git bash中进行。

# Hexo使用步骤

一般来说，使用hexo的步骤如下：

（1）使用hexo new创建一篇新文章

可以参见下面的<<使用Hexo new创建一篇新文章>>部分。

（2）使用编辑器打开source或source/_posts目录下新文章对应的MarkDown文件，然后编辑其内容并保存

（3）使用hexo server命令启动hexo http server服务器，然后在浏览器中输入`http://ip:4000`来预览文章内容

也可以使用`hexo server -p port --watch`来打开服务器，这样hexo server就会热加载最新的编辑内容，而不用每次编辑文件后就需要重启的hexo server。

（4）使用hexo generate命令生成文档的静态WEB资源

（5）使用hexo deploy命令将静态资源（即mysitename/public目录下的内容）部署到Github pages免费空间中

（6）在浏览器中输入`http://username.github.io/`来查看文章内容

# 使用Hexo new创建一篇新文章

命令格式为：hexo new [layout] <title>即可。这里的layout最好不要理解成布局的意思，个人觉得是新文章的类别。Hexo默认的有三种类别，分别是post、page 和 draft，下面分别介绍：

（1）post

使用hexo new不指定layout参数时，则会根据/mysitename/_config.yml中的default_layout参数来指定默认layout，一般来说默认是post。hexo new post会在mysitenaem/source/_posts/中创建一个markdown文件（使用scaffolds/post.md作为脚手架来创建markdown文件）。然后经过hexo generate生成静态文件后，会在"public/${year}/${month}/${day}/markdown文件tilte/"组成的目录中生成index.html文件，在浏览器中输入`http://ip:4000/2018/01/28/markdown文件title/`即可访问。

备注：这种就是使用最多的创建文章类型。

（2）draft

使用hexo new draft会在mysitenaem/source/_drafts/中创建一个markdown文件（使用scaffolds/draft.md作为脚手架来创建markdown文件），执行hexo generate命令时，并不会生成对应的html文件，我们把hexo new draft创建的文章称为草稿，也就是创建后并不会在站点中显示出来的文章。当然，我们可以使用`hexo generate --draft && hexo server --draft`在本地预览草稿文章的效果。当我们需要将草稿正式发布时，可以使用`hexo publish draft "文章标题"`即可。

备注：当我们的一篇文章还没有彻底完善好或想作为私密文档的话，就可以使用该种类型。

（3）page

使用hexo new page title会在mysitenaem/source/中创建一个markdown文件（使用scaffolds/page.md作为脚手架来创建markdown文件），然后经过hexo generate生成静态文件后，会在"public/markdown文件tilte/"目录下生成index.html文件，在浏览器中输入`http://ip:4000/markdown文件title/`即可访问。

备注：当我们需要创建一篇拥有独立url路径的文章时，如“关于我（`http://ip:port/about`）”的页面时，就可以使用hexo new page啦。

（4）自定义

我们也可以自定义哦，若我们在scaffolds目录下新建一个wahaha.md的脚手架，然后我们就可以使用hexo new wahaha "title"来创建一篇文章。hexo new wahaha会在mysitenaem/source/_posts/中创建一个markdown文件（使用scaffolds/wahaha.md作为脚手架来创建markdown文件）。

# 将项目部署到Github pages

（1）在Github上创建“用户名.github.io”的仓库

（2）安装deployer-git

执行`npm install hexo-deployer-git --save`命令即可

（3）给hexo配置github pages属性

在/blog/_config.yml中修改deploy属性，内容如下：

```
deploy:
  type: git
  repository: git@github.com:wangjianno1/wangjianno1.github.io.git
  branch: master
```

（4）使用hexo deploy命令可以一键部署站点静态文件到Github pages

备注：hexo generate命令将我们编写的MarkDown等文件生成浏览器能直接识别的静态页面文件（包括html、js、css等等），使用hexo deploy是将这些静态文件提交到Github的“用户名.github.io”仓库中。

# Hexo中主题(theme)说明
创建Hexo主题非常容易，只需要在互联网上搜索hexo主题，然后将hexo主题对应的文件夹放置到mysitname/themes目录中，然后修改mysitename/_config.yml内的theme属性即可切换主题。

一般来说，Hexo的主题文件夹的结构如下：

![Hexo主题目录结构](/images/hexo_1_1.png)

其中在主题的layout目录下，通常有index.ejs、page.ejs、post.ejs、category.ejs、tag.ejs以及layout.ejs等文件，其实这些文件类似于Python中使用Jiaja2规则编写的html模板文件类似。Hexo默认使用的内建Swig模板引擎，也可以使用其他的模板引擎，如EJS、Haml或Jade等。

layout.ejs是一个完整的html页面的模板文件，该模板中包含了导航条、底部footer、分类侧边栏以及标签侧边栏等元素，其中还有一个body变量。而index.ejs、page.ejs、post.ejs、category.ejs、tag.ejs就代表了html中主要内容部分，如index.ejs表示打开站点首页时，显示的文章列表部分（不包括导航条、底部footer、分类侧边栏以及标签侧边栏等元素），post.ejs表示具体某一篇文章的正文，category.ejs表示我们点击某个分类，显示该分类下所有文章列表的部分（不包括导航条、底部footer、分类侧边栏以及标签侧边栏等元素），tag.ejs表示我们点击某个标签，显示该标签下所有文章列表的部分（不包括导航条、底部footer、分类侧边栏以及标签侧边栏等元素）。而index.ejs、page.ejs、post.ejs、category.ejs、tag.ejs等就是用来填充layout.ejs文件中body变量的，从而能构成一个完整的html页面哦。

具体的模板的说明如下：

![模板说明](/images/hexo_1_2.png)

# Hexo搭建个人站点的部署方案

使用Hexo搭建个人站点有如下几种部署方案：

（1）直接使用hexo内置的http server来启动站点，即在博客项目中执行hexo server命令即可。

（2）使用hexo generate生成站点的静态页面文件（包括html、js、css等等），然后直接部署到web服务器（例如nginx/apache等等）中。

（3）部署到Github pages免费空间中，参见第4部分内容。

# 使用Hexo的闲杂问题

（1）如何保存自己的Hexo生成的原始文件以及自己编写MarkDown文件呢？

可以在“用户名.github.io”仓库下新建一个非master分支，将Hexo的原始文件提交到该分支上（不能是master分支哦，因为master分支是用github pages的默认使用的分支哦）

（2）。。。


参考资料来源于：
https://hexo.io/zh-cn/docs/
