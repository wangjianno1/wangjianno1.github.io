---
title: MySQL的基本数据类型
date: 2018-02-02 14:26:07
tags: MySQL
categories: 数据库
---

MySQL的数据类型有：

（1）整型

```bash
TINYINT   #占用1Byte
SMALLINT  #占用2Bytes
MEDIUMINT #占用3Bytes
INT       #占用4Bytes
BIGINT    #占用8Bytes
```

（2）浮点数

```bash
FLOAT    #占用4Bytes
DOUBLE   #占用8Bytes
DECIMAL
```

（3）字符串

```bash
VARCHAR  #可变长度的字符串的存储
CHAR     #固定长度的字符串的存储
TEXT     #包括TINYTEXT/TEXT/MEDIUMTEXT/LONGTEXT四种类型
BLOB     #包括TINYBLOB/BLOB/MEDIUMBLOB/LONGBLOB四种类型
```

备注：VARCHAR存储可变长度的字符串，如VARCHAR(100)，虽然是100，但会根据字符串的实际大小来分配空间。CHAR是存储固定长度字符串的，如CHAR(100)，不管字符串的长度多长，都分配100个Byte。

（4）日期

```bash
DATETIME   #占用8Bytes
TIMESTAMP  #占用4Bytes
```