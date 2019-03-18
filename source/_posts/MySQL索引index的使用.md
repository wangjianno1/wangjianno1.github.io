---
title: MySQL索引index的使用
date: 2018-02-02 14:41:36
tags: MySQL
categories: 数据库
---

# MySQL索引

MySQL索引的建立对于mysql的高效运行是很重要的，索引可以大大提高MySQL的检索速度。索引分单列索引和组合索引。单列索引，即一个索引只包含单个列，一个表可以有多个单列索引，但这不是组合索引。组合索引，即一个索引包含多个列。

需要注意的是，过多的使用索引将会造成滥用，虽然索引能大大提高查询速度，但是却会降低更新表的速度（如对表进行insert、update和delete）。因为更新表时，MySQL不仅要保存数据，还要更新一下索引文件。

# 索引的创建、删除及查看

创建索引的方法有：

（1）创建普通索引

```sql
create index index_name on some_table(column_name);
alter table some_table add index index_name(column_name);
create table some_table (
  id INT NOT NULL,   
  username VARCHAR(16) NOT NULL, 
  index index_name(column_name) 
);
```

（2）创建唯一索引

与普通索引类似，不同的是，索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。

```sql
create unique index index_name on some_table(column_name);
alter table some_table add unique index index_name(column_name);
create table some_table (
  id INT NOT NULL,   
  username VARCHAR(16) NOT NULL, 
  unique index index_name(column_name) 
);
```

（3）删除索引

```sql
drop index some_index on some_table;
```

（4）查看指定数据库表上的所有索引

```sql
show index from some_table;
```

# 聚集索引与非聚集索引

聚集索引是指数据库表行中数据的物理存储顺序与键值的逻辑（索引）顺序相同。一个表只能有一个聚集索引，因为一个表的物理顺序只有一种情况，所以，对应的聚集索引只能有一个。如果某索引不是聚集索引，则表中的行物理顺序与索引顺序不匹配，与非聚集索引相比，聚集索引有着更快的检索速度。

InnoDB支持聚集索引，而MyISAM不支持聚集索引。MySQL数据表中的自增id字段上就是聚集索引哦。

学习资料参考于：
http://www.runoob.com/mysql/mysql-index.html
https://mp.weixin.qq.com/s/tvfieCo_W_pLQwpLofwT9A
