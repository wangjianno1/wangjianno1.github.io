---
title: YAML数据格式介绍和使用
date: 2018-02-27 11:09:22
tags:
categories: 杂货铺
---

# YAML

与XML或JSON一样，YAML是一种利于人们读写的数据格式。

# YAML文件的编写

一个YAML文件的开始行都应该是三个横杠（`---`），这是YAML格式的一部分，表明一个YAML文件的开始。YAML中有两种数据结构，一种是列表，一种是字典。

（1）列表

列表中的所有成员都开始于相同的缩进级别，并且使用一个“- ”作为开头（一个横杠和一个空格），举例来说：

	---
	- Apple
	- Orange
	- Strawberry
	- Mango

（2）字典

一个字典是由一个简单的“键: 值”的形式组成（这个冒号后面必须是一个空格），举例来说：

	---
	name: Example Developer
	job: Developer
	skill: Elite

# YAML文件的范例

一个YAML文件的内容是由列表、字典以及列表字典的嵌套组成，如下为一个YAML文件的范例：

	---
	name: Example Developer
	job: Developer
	skill: Elite
	employed: True
	foods:
	  - Apple
	  - Orange
	  - Strawberry
	  - Mango
	languages:
	  ruby: Elite
	  python: Elite
	  dotnet: Lame
