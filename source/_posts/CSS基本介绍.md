---
title: CSS基本介绍
date: 2018-07-08 02:12:31
tags:
categories: CSS
---

# CSS简介

CSS指层叠样式表（Cascading Style Sheets），CSS定义如何显示 HTML元素。CSS的出现是为了解决内容与表现分离的问题，使WEB文档样式风格相关的定义和申明都放在独立的文件中，也就是CSS文件中。而HTML中只包含了文档标签和文档内容。CSS是在HTML 4.0时候提出来的。

现在最新的CSS版本是CSS3，里面有好多新的样式定义，例如圆角属性border-radius、渐变属性等等。

# CSS语法

CSS规则由两个主要的部分构成：选择器以及一条或多条声明：

![](/images/css_1_1.png)

选择器通常是需要改变样式的HTML元素。每条声明由一个属性和一个值组成。属性（property）是希望设置的样式属性（style attribute）。每个属性有一个值。属性和值被冒号分开。例如，定义段落的颜色和对齐方式如下：

```css
p
{
    color: red;
    text-align: center;
}
```
其中选择器除了可以是普通的HTML标签元素，也可以是id选择器和class选择器：

（1）id选择器

id选择器可以为标有特定id的HTML元素指定特定的样式。HTML元素以id属性来设置id选择器，CSS中id选择器以"#"来定义。以下的样式规则应用于`id="para1"`的HTML标签元素:

```cass
#para1
{
    text-align: center;
    color: red;
}
```

（2）class选择器

class选择器用于描述一组元素的样式，class选择器有别于id选择器，class可以在多个元素中使用。class选择器在HTML中以class属性表示, 在 CSS中，类选择器以一个点"."号显示：在下面的例子中，所有class属性为center的 HTML元素均居中：

```css
.center 
{
    text-align: center;
}
```

（3）混合模式选择器

可以使用HTML元素和class属性来作为选择器。例如，下面的例子中，为html文档中所有class属性的值为center的p标签定义样式：

```css
p.center 
{
    text-align: center;
}
```

（4）选择器的组合与嵌套

形式一：

```css
h1,h2,p
{
    color: green;
}
```

如上写法表示html元素h1、h2、p使用相同的样式。

形式二：

```css
.marked p
{
    color: white;
}
```

如上写法表示为所有`class="marked"`元素内的`p`元素指定一个样式。

形式三：

```css
div>p
{
    background-color: yellow;
}
```

如上写法表示为`div`标签中所有`p`元素设置样式。

形式四：

```css
div+p
{
    background-color: yellow;
}
```

如上写法表示选中`div`标签后第一个`p`元素，为其设置样式。注意`div`和`p`元素必须是同级的元素。

形式五：

```css
div~p
{
    background-color: yellow;
}
```

如上写法表示选中`div`标签后所有`p`元素，为其设置样式。注意`div`和`p`元素必须是同级的元素。
