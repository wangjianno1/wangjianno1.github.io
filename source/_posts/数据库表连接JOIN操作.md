---
title: 数据库表连接JOIN操作
date: 2019-03-13 22:56:04
tags:
categories: 数据库
---

# 表连接JOIN操作简介

在关系型数据库中，JOIN本质上是基于两个或者多个表进行结合重构成一种大表的过程。其创造的结果可以被保存为一个表（table）或是作为一个表来使用。这个结合的过程的基础，或者说联系点，是存在于两个表之间的共同的列。一般来说，ANSI标准的SQL定义了如下这些JOIN操作类型：

    INNER JOIN，指内连接
    LEFT OUTER JOIN，指左连接
    RIGHT OUTER JOIN，指右连接
    FULL OUTER JOIN，指全连接
    CROSS JOIN，指交叉连接

备注：其中INNER JOIN属于内连接，LEFT OUTER JOIN、RIGHT OUTER JOIN以及FULL OUTER JOIN属于外连接。

# 维恩图解释表连接JOIN

很多文章采用维恩图（两个圆的集合运算），解释不同数据库连接JOIN的差异。如下图：

![](/images/mysql_join_1_1.png)

需要说明的是，用集合操作的方式并不能恰当的解释数据库JOIN操作，因为集合操作中，需要各个集合中的元素是同类型的。而执行数据库连接JOIN操作的不同数据表的结构并不是一样的哦，真正的集合操作见[《数据库中多表查询操作》](https://wangjianno1.github.io/2019/03/13/%E6%95%B0%E6%8D%AE%E5%BA%93%E4%B8%AD%E5%A4%9A%E8%A1%A8%E6%9F%A5%E8%AF%A2%E6%93%8D%E4%BD%9C/)。因此下面还有更恰当的解释方法。

# 笛卡尔乘积解释表连接JOIN

## 笛卡尔积的概念

![](/images/mysql_join_1_2.png)

## 交叉连接CROSS JOIN

交叉连接CROSS JOIN是一种特殊的连接，指的是表A和表B不存在关联字段，这时表A（共有n条记录）与表B（共有m条记录）连接后，会产生一张包含`n x m`条记录的新表。

![](/images/mysql_join_1_3.png)

需要说明的是，交叉连接是其他各种连接的基础，其他各种连接可以简单理解为**“加上了筛选条件的交叉连接”**。

## 其他各种连接

![](/images/mysql_join_1_4.png)

# 各种数据库JOIN操作语法举例

（1）内连接

```sql
SELECT * FROM TableA a INNER JOIN TableB b ON a.name = b.name;       --INNER可以省略
```

备注：TableA和TableB做完笛卡尔积之后，只有满足a.name = b.name的记录才是内连接的结果。

（2）左连接

```sql
SELECT * FROM TableA a LEFT OUTER JOIN TableB b ON a.name = b.name;  --OUTER可以省略
```

备注：TableA和TableB做完笛卡尔积之后，除了满足a.name = b.name的记录是左连接的结果外，再加上TableA中没有被匹配上的记录（这块没有TableB的字段）。

（3）右连接

```sql
SELECT * FROM TableA a RIGHT OUTER JOIN TableB b ON a.name = b.name; --OUTER可以省略
```

备注：TableA和TableB做完笛卡尔积之后，除了满足a.name = b.name的记录是由连接的结果外，再加上TableB中没有被匹配上的记录（这块没有TableA的字段）。

（4）全连接

```sql
SELECT * FROM TableA a FULL OUTER JOIN TableB b ON a.name = b.name;  --OUTER可以省略
```

备注：TableA和TableB做完笛卡尔积之后，除了满足a.name = b.name的记录是全连接的结果外，再加上TableA中没有被匹配上的记录（这块没有TableB的字段），再加上TableB中没有被匹配上的记录（这块没有TableA的字段）。

另外，在JOIN操作的SQL语句后面还可以加上where从句，进一步过滤查询结果，举例如下：

```sql
SELECT * FROM TableA a LEFT OUTER JOIN TableB b ON a.name = b.name WHERE b.name IS null;
```

# 一些复杂查询例子

（1）复杂JOIN操作

```sql
select B.CUST_NO "custNo", B.CUST_NAME "custName", B.SELL_NAME "sellName", B.CUST_TYPE "custType", sum(B.AMOUNT) "amountSum" from T_ORDER_APPLY A left join T_ORDER_APPLY_DETAIL B on A.ORDER_ID=B.ORDER_ID where A.STATUS=6 and A.IS_DELETE='N' and B.IS_DELETE='N' and A.UPDATE_DATE<='2022-09-25 00:00:00' group by B.CUST_NO, B.CUST_NAME, B.SELL_NAME, B.CUST_TYPE
```

上面是一个复杂查询的例子，包括了join、where以及group by等操作，我们可以进行如下拆解任务：

（1）第一步：先进行左连接

```sql
select * from T_ORDER_APPLY A left join T_ORDER_APPLY_DETAIL B on A.ORDER_ID=B.ORDER_ID
```

（2）第二步：对左连接的结果进行where子句进行筛选过滤

```sql
select * from (第一步中得到的查询结果) where A.STATUS=6 and A.IS_DELETE='N' and B.IS_DELETE='N' and A.UPDATE_DATE<='2022-09-25 00:00:00'
```

（3）第三步：对第二步的结果进行group by子句进行分组统计

```sql
select B.CUST_NO "custNo", B.CUST_NAME "custName", B.SELL_NAME "sellName", B.CUST_TYPE "custType", sum(B.AMOUNT) "amountSum" from (第二步中得到的查询结果) group by B.CUST_NO, B.CUST_NAME, B.SELL_NAME, B.CUST_TYPE
```

（2）多个JOIN操作

```sql
select * from a left join b on a.id=b.id left join c on b.id=c.id
```

上面是一个多个JOIN串联操作的例子，先是a和b左连接生成结果集t，然后再做t和c的左连接。

学习资料参考于：
http://www.ruanyifeng.com/blog/2019/01/table-join.html
https://coolshell.cn/articles/3463.html/comment-page-1
https://blog.jooq.org/2016/07/05/say-no-to-venn-diagrams-when-explaining-joins/
https://www.jianshu.com/p/9e1d3793cba6
