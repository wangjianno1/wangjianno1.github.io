---
title: MySQL中级联删除|级联更新|级联查询
date: 2019-03-14 08:24:30
tags:
categories: 数据库
---

# 级联删除和级联更新

级联删除或级联更新是为了保证数据完整性。有两种方式：

（1）外键实现

在外键上设置`ON DELETE CASCADE`或`ON UPDATE CASCADE`，实现级联更新或级联查询。

```sql
ALTER TABLE `score`
ADD CONSTRAINT `student_ibfk1`
FOREIGN KEY `sid`(`sid`) REFERENCES `students` (`id`)
ON DELETE CASCADE ON UPDATE CASCADE;
```

即当某个学生从数据库中删除了，会自动删除score表中该学生的成绩。

（2）触发器实现

```sql
CREATE TRIGGER `deleteScore` AFTER DELETE ON `students`
 FOR EACH ROW BEGIN
DELETE FROM score WHERE sid=OLD.`id`;
END
```

# 级联查询

通过JOIN/LEFT JOIN/RIGHT JOIN等来实现多表的级联查询。
