---
title: MySQL数据库的一些操作技巧
date: 2018-02-02 16:34:55
tags: MySQL
categories: 数据库
---

# 表记录删除

在生产环境中，一般来说是不会物理删除数据库表中的一些的记录的，而是进行逻辑删除。比如在表中增加一个tag字段。若`tag=1`则表示已删除；若`tag!=1`表示没有被删除。

# mysql中使用\G格式化输出

使用mysql的client工具，如`select * from user_msg limit 2\G;`，可以以如下的格式输出：

```
mysql> select * from user_msg limit 2\G;
*************************** 1. row ***************************
         uid: 1
   today_msg: 0
*************************** 2. row ***************************
         uid: 2
   today_msg: 0
2 rows in set (0.02 sec)
```

# MySQL的auto-rehash功能

MySQL配置文件中有个auto-rehash的选项，auto-rehash是自动补全的意思，当我们在MySQL的命令行中输入SQL语句时，按TAB键就会帮我们自动补全表名或字段名。这个功能就像我们在Linux命令行里输入命令的时候，使用TAB键补全命令就好了。

但是，这个功能在有些情况下会出现一些弊端，当我们打开数据库，即`use 数据库名;`时，会预读数据库信息。有时候由于数据库太大或者表数量太多，预读数据库信息将非常慢，很容易就卡住。在进入数据库时加`-A`选项可以解决这个问题，即执行`mysql -u root -p -A`命令即可。
