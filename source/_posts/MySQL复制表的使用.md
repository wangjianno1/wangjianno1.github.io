---
title: MySQL复制表的使用
date: 2018-02-02 14:54:11
tags: MySQL
categories: 数据库
---

# MySQL复制表

假设数据库中已经有数据库表some_table，现在想要复制出一张新的表，表的结构和some_table一样。如果需要的话，还希望将some_table中的数据拷贝到新数据库表中。我们知道使用mysqldump工具可以将整个数据库导出，但是满足不了上面以表为单位的操作。

# 具体操作

假设现在已经有数据库表websites，现在要复制出名称为websites2的数据表，操作步骤如下：

（1）复制表的结构

执行`show create table websites \G`可以查看已有表的创建命令，如下：

![](/images/mysqlreptable_1_1.png)

复制上述命令，修改表名为website2，然后执行该命令，即可以创建出和websites表结构一样的websites2，如下：

![](/images/mysqlreptable_1_2.png)

（2）复制表的数据记录

执行如下命令，将websites中的数据记录复制到表websites2中，如下：

![](/images/mysqlreptable_1_3.png)
