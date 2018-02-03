---
title: Linux中交互输入yes命令
date: 2018-02-04 00:14:51
tags:
categories: Linux
---

# yes命令

yes命令可以重复输出指定的字符串到终端，直到被终止。默认会输出字符y。使用yes命令可以更加自动化地执行一些命令。举例来说，

```bash
yes | rm testfile           #直接删除testfile，不用手动确认，相当于为rm命令加上了-f参数
yes | yum install iftop     #这样在安装iftop时，就不需要用户手动键入yes确认
yes no | yum install iftop  #这样在安装iftop时，提示用户确认安装时，自动输入no字符串，而导致安装终止
yes YAMAHA                  #在终端屏幕上循环打印YAMAHA字符串
```
