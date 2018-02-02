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

