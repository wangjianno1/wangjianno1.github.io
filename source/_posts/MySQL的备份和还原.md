---
title: MySQL的备份和还原
date: 2018-02-02 15:06:28
tags: MySQL
categories: 数据库
---

# 数据库的备份和还原

（1）备份命令

```bash
./mysqldump -uroot -pwahaha --all-database=TRUE > ./all_database.sql    #导出所有数据库的定义和数据
./mysqldump -uroot -pwahaha some_database > ./some_database.sql         #导出指定数据库的定义和数据
./mysqldump -uroot -pwahaha some_database some_table > ./some_table.sql #导出指定数据库表的定义和数据
```

（2）还原命令

```bash
./mysql -uroot -pwahaha < ./all_database.sql                 #还原所有数据库的定义和数据
./mysql -uroot -pwahaha some_database < ./some_database.sql  #还原指定数据库的定义和数据
./mysql -uroot -pwahaha some_database < ./some_table.sql     #还原指定数据库表的定义和数据
```

# 只导出数据库的表结构，不导出数据，可以利用这个复制一个没有数据的空数据库

```bash
./mysqldump -uroot -pwahaha --all-database=TRUE -d > ./all_database.sql    #只导出所有数据库的定义
./mysqldump -uroot -pwahaha some_database -d > ./some_database.sql         #只导出指定数据库的定义
./mysqldump -uroot -pwahaha some_database some_table -d > ./some_table.sql #只导出指定数据库表的定义
```

备注：-d参数表示只dump表结构，不dump数据记录哦。这个很好用哦。

# 使用into outfile子句

使用into outfile子句，可以将查询结果，写入到一个文本文件中，文件的格式也可以自定义。然后可以使用脚本语言来处理这个文件哦。

```bash
select * from websites into outfile '/tmp/output';
```