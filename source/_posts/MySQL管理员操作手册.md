---
title: MySQL管理员操作手册
date: 2018-02-02 16:13:28
tags: MySQL
categories: 数据库
---

# MySQL登录

（1）利用TCP/IP连接，客户端和服务端可以在不同的机器上

```bash
mysql -h12.45.23.41 -uwahaha -p
mysql -h12.45.23.41 -P3345 -uwahaha -p   #非标准的3306端口
```

然后输入用户密码，若无密码，直接回车即可。

（2）利用Unix域套接字来连接，客户端和服务端要在同一台机器上

```bash
mysql -S /var/lib/mysql/mysql.sock -uroot -p
```

# 查看基础信息

```sql
show databases;                         /*查看所有数据库*/
use db_name;                            /*切换到数据库db_name*/
show tables;                            /*查看某个数据库包含哪些数据库表*/
desc table_name;                        /*查看数据库表table_name的表结构定义*/
describe table_name;                    /*同desc table_name*/
show columns from table_name;           /*同desc table_name*/
select count(*) from table_name;        /*查询指定表中总共有多少条记录*/
show index from table_name;             /*查看指定表的index信息*/
select host, user, password from user;  /*查看mysql中所有的用户信息*/
flush privileges;                       /*当我们修改完mysql的用户及授权信息后，一般需要执行该命令。执行后mysql会重新载入授权表，从而生效最新的权限变更*/
```

# 查看MySQL的版本信息

有如下几种方法：

（1）直接执行`mysql -V`

（2）执行`mysqladmin -V`

（3）登录MySQL后，在命令提示符上执行`status`命令

```bash
mysql> status;
```

（4）在MySQL的命令提示符中使用version函数

```bash
mysql> select version();
```

# 获取数据库元数据

```sql
select version();                     /*获取mysql服务器版本信息*/
select database();                    /*查看当前使用的数据库*/
select user();                        /*查看当前登录账户*/
select current_user();                /*查看当前登录账户*/
show status;                          /*查看mysql服务器的状态*/
show variables;                       /*查看mysql服务器的配置变量*/
show variables like '%sql_log_bin%';  /*查看mysql服务器中包含了某关键字的变量*/
show warnings;                        /*查看mysql中执行sql时的错误信息*/
```

# 一些常用的操作命令

（1）数据库的定义和删除

```sql
drop database `some_database`;            /*删除some_database数据库*/
drop database if exists `some_database`;  /*若some_database存在，则删除some_database数据库*/
create database `some_database`;          /*创建some_database数据库*/
```

（2）数据表的定义和删除

```sql
drop table `some_table`;                  /*删除指定表*/
drop table if exists `some_table`;        /*若指定表存在，则删除之*/
create table if not exists `some_table` (
  `id` INT UNSIGNED AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `author` VARCHAR(40) NOT NULL,
  `date_t` DATE,
  PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;     /*创建表结构*/
```

（3）数据表的名称或字段修改（alter）

```sql
alter table testalter_tbl drop age;                  /*删除字段age*/
alter table testalter_tbl add age INT;               /*增加字段age，数据类型为整型*/
alter table testalter_tbl modify name CHAR(10);      /*修改字段name的数据类型为char(10)*/
alter table testalter_tbl change age age_fd BIGINT;  /*将字段名age修改为age_fd*/
alter table testalter_tbl alter age SET DEFAULT 29;  /*修改字段age的默认值为29*/
alter table testalter_tbl ENGINE = MYISAM;           /*修改数据库表的存储引擎*/
alter table testalter_tbl rename to alter_tbl;       /*修改数据库表的名称*/
```

（4）插入记录（insert）

```sql
insert into runoob_tbl (title, author, date_t) values ("学习MySQL", "wahaha", NOW());
insert into wahaha(name, info) values ('2332', '2323'), ('vv2332', 'vv2323'), ('as2332', 'as2323');  /*批量插入多条记录，但是MySQL对SQL语句的长度有限制（通过变量max_allowed_packet）*/
```

（5）数据查询（select）

```sql
select * from some_table;                              /*查询数据库表中所有内容*/
select column_name_1, column_name_2 from some_table;   /*查询数据库表中指定列*/
select a.runoob_id, a.runoob_author, b.runoob_count from runoob_tbl a, tcount_tbl b where a.runoob_author = b.runoob_author;   /*多表查询*/
```

（6）更新记录（update）

```sql
update some_table set title='学习MySQL' where author='wahaha';
```

备注：若update语句后面不带条件，即不带where子句，那么update语句将修改该数据库表some_table中的所有记录。

（7）删除记录（delete）

```sql
delete from some_table where author='wahaha'; /*按条件删除记录*/
delete from some_table;     /*删除表中所有记录*/
truncate table some_table;  /*删除表中所有记录*/
```

delete和truncate语句都可以删除表中记录。delete配合where子句可以删除符合条件的记录，但是truncate只能删除表中所有的记录。delete删除记录的操作是可回滚的，而truncate删除的记录是不可以回滚的。truncate删除记录的效率要高于delete语句。delete和truncate语句都不删除表的定义，但是drop table语句会删除表的定义。

如果一个表中有自增字段，使用`truncate table some_table`和没有where子句的`delete from some_table`删除所有记录后，这个自增字段将起始值恢复成1。如果你不想这样做的话，可以在delete语句中加上永真的where子句，如`where 1`或`where true`。

（8）where子句

where子句用于有条件地从表中选取数据。where子句也可以运用于SQL的select/delete/update命令。另外可以使用and或or关键字指定一个或多个条件。

```sql
select * from some_table where id='12' and author='wahaha';
```

（9）where子句中嵌套like子句

SQL like子句中使用百分号`%`字符来表示任意字符，类似于UNIX或正则表达式中的星号`*`。 如果没有使用百分号`%`，like子句与等号`=`的效果是一样的。如下为查找author字段以haha为结尾的所有记录：

```sql
select * from some_table where author like '%haha';
```

（10）对结果集排序order by子句

```sql
select * from some_table order by id;
select * from some_table order by id asc;
select * from some_table order by id desc;
```

备注：asc表示将查询结果集按升序排列，desc表示将查询结果集按降序排列。如果order by子句不指明asc或desc，那默认的是asc，即升序排列。

（11）分组group by子句

mysql中可使用group by子句对记录行进行分组。select子句中的列名必须为分组列或列函数。列函数对于group by子句定义的每个组各返回一个结果。举例来说：

```sql
select name，count(*) from employee_tbl group by name;
select dept, max(salary) as maximum from staff group by dept;
```

（12）limit | offset子句

    select _column,_column from _table [where Clause] [limit N][offset M]

说明如下：

    limit N表示返回前N条记录
    offset M表示跳过M条记录，从第M条记录开始
    limit N offset M表示从第M条记录开始, 返回N条记录
    limit M, N等价于limit N offset M

`limit | offset`一个重要用途就是实现MySQL查询分页功能：

```sql
select * from _table limit (page_number-1)*lines_perpage, lines_perpage;       //写法一
select * from _table limit lines_perpage offset (page_number-1)*lines_perpage; //写法二
```

# MySQL NULL值处理

mysql使用select命令及where子句来读取数据表中的数据，但是当提供的查询条件字段为NULL时，该命令可能就无法正常工作。 为了处理这种情况，mysql提供了两种运算符：

	IS NULL       #当列的值是NULL，此运算符返回true
	IS NOT NULL   #当列的值不为NULL，此运算符返回true

举例来说，如下：

```sql
select * from runoob_test_tbl where runoob_count IS NULL;
select * from runoob_test_tbl where runoob_count IS NOT NULL;
select * from runoob_test_tbl where runoob_count = NULL;  /*这种是没用的，需要使用IS NULL*/
select * from runoob_test_tbl where runoob_count != NULL; /*这种是没用的，需要使用IS NOT NULL*/
```

# MySQL中使用正则表达式

```sql
select name from person_tbl where name regexp '^st'; /*查询name字段以st开头的记录*/
select name from person_tbl where name regexp 'ok$'; /*查询name字段以ok结尾的记录*/
```

# SQL文件的执行方式

可以将sql语句编写到`*.sql`文件中，执行方法有如下几种：

（1）

```bash
./mysql -h11.23.43.34 -uwahaha -phehe123 < *.sql
```

或直接将sql语句写入终端中：

```bash
mysql -h11.23.43.34 -uwahaha -p -Ddatabase_name -e "select * from some_table"
```

（2）客户端连接后

```
mysql>source sql文件的绝对路径
```

（3）客户端连接后

```
mysql>/. sql文件的绝对路径
```

# perror工具的使用

当使用mysql过程中出现错误，返回了错误码error_code，可以使用mysql安装的bin目录下perror工具来查看具体错误的含义。例如：

```
[work@hostname bin]$ ./perror 111
OS error code 111:  Connection refused
```
