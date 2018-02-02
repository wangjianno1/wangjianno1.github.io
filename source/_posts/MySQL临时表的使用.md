---
title: MySQL临时表的使用
date: 2018-02-02 14:50:20
tags: MySQL
categories: 数据库
---

# MySQL临时表

MySQL临时表在需要保存一些临时数据时是非常有用的。临时表只在当前连接可见，当关闭连接时，MySQL会自动删除表并释放所有空间。 MySQL临时表是在MySQL 3.23及以后版本中才有的功能，若使用的MySQL版本低于3.23，则无法使用MySQL临时表。

# MySQL临时表的具体使用

（1）创建临时表

```bash
create temporary table some_table (
  product_name VARCHAR(50) NOT NULL,
  total_sales DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  avg_unit_price DECIMAL(7,2) NOT NULL DEFAULT 0.00,
  total_units_sold INT UNSIGNED NOT NULL DEFAULT 0
);
```

（2）往临时表中插入数据

```bash
insert info some_table (product_name, total_sales, avg_unit_price, total_units_sold) values ('cucumber', 100.25, 90, 2);
```

（3）从临时表中查询数据

```bash
select * from some_table;
```

备注：如果退出了当前MySQL会话，再使用select命令来读取原先创建的临时表数据，那会发现数据库中该表已经不存在了，因为在退出MySQL会话时，该临时表已经被销毁了。
