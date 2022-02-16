---
title: JAVA中JPA关联映射小结
date: 2019-03-04 19:07:11
tags:
categories: SSM/SSH
---

# JAVA中JPA关联映射简介

数据库的关系映射的概念知识，参见[《数据库设计中关系映射（一对一|多对一|一对多|多对多|单向|双向）》](https://wangjianno1.github.io/2019/03/13/%E6%95%B0%E6%8D%AE%E5%BA%93%E8%AE%BE%E8%AE%A1%E4%B8%AD%E5%85%B3%E7%B3%BB%E6%98%A0%E5%B0%84%EF%BC%88%E4%B8%80%E5%AF%B9%E4%B8%80-%E5%A4%9A%E5%AF%B9%E4%B8%80-%E4%B8%80%E5%AF%B9%E5%A4%9A-%E5%A4%9A%E5%AF%B9%E5%A4%9A%EF%BC%89/)部分。JAVA JPA规范也对关系映射有支持，JPA中的映射类型有：

    一对一（One To One）
    一对多（One To Many）
    多对一（Many To One）
    多对多（Many To Many）

另外，关联映射是有方向的，即是单向或者双向的。如Student和ClassRoom两个实体类，从student来看，是多对一；而从ClassRoom来看，是一对多。具体来说如下：

（1）单向“多对一”

若Student实体类中定义了private ClassRoom classRoom属性，那么对于Student实体类来说是建立了单向的“ManyToOne”的映射，通过Student的classRoom属性可以得知该Student所属的ClassRoom；

（2）单向“一对多”

若ClassRoom实体类中定义了private List<Student> studentList属性，那么对于ClassRoom实体类来说是建立了单向的“OneToMany”的映射，通过ClassRoom的studentList属性可以得知属于该ClassRoom的所有Student。

（3）双向“一对多”或双向“多对一”

若Student实体类中定义了private ClassRoom classRoom属性，且ClassRoom实体类中定义了`private List<Student> studentList`属性，那么对于Student和ClassRoom来说，它们就建立了双向“一对多”或双向“多对一”的关系。

# mappedBy="xxxxxx"

在四种关联关系OneToOne，OneToMany，ManyToOne和ManyToMany中，只有OneToOne、OneToMany和ManyToMany这三种关联关系有mappedBy属性，ManyToOne是不存在mappedBy属性的。

简单来说，实体类中使用了mappedBy设置，那么表示该实体类放弃维护关联关系，也就是不会去维护数据库层面的外键关系，而是将关联关系交给对方维护。假设ClassRoom中定义了private List<Student> studentList属性，当在studentList上使用mappedBy，则我们新增一个ClassRoom时，会在数据库中插入ClassRoom记录以及Student记录，但是不会设置Student表中外键值，在这种情况下，只有新增Student实例时，才会设置Student表中的外键classid。

ClassRoom实体类`private List<Student> studentList`属性上的`mappedBy="xxxxxx"`，xxxx要是Student实例中private ClassRoom classRoom的属性名，即classRoom，也就是`mappedBy="classRoom"`。

# JoinColum(name = "xxxxx")

关于`@JoinColumn(name = "address_id", referencedColumnName="ref_id")`，我们知道，无论使用OneToOne，OneToMany还是ManyToOne，最终都会落实到数据库表中的外键关系，这里的name表明外键在数据库中的字段名，referencedColumnName表示被外键关联到的表的哪个字段，如果不指定referencedColumnName，默认会外键指向的被关联表的主键哦。在实例类的关系映射处都加上JoinColumn注解。

需要注意是，当属性上标注了mappedBy，则该属性就不能再标注JoinColum或JoinTable啦。

# 关联映射中的FetchType和CascadeType

使用JPA标准或实现了JPA标准的框架时，会使用@OneToOne|@OneToMany|@ManyToOne|@ManyToMany等注解来实现实体类的关联映射。例如ClassRoom实体类中定义了`private List<Student> studentList`属性，那么当我们增删改查ClassRoom实体类对应的数据库记录时，就涉及到对Student实体类的级联操作。具体来说，查询ClassRoom时，属于该ClassRoom的所有学生的查询形式，这对应就是FetchType。当我们删除某个ClassRoom时，我们是否删除属于该ClassRoom下的所有学生实体类，这对应的就是CascadeType概念。

# FetchType类型

（1）FetchType.LAZY

延迟加载，在查询实体A时，不查询出其关联实体B，只有再调用A的getB方法时，才会去数据库中查询A的关联实体B。我们在使用延迟加载特性时，可能会因为使用不当导致“LazyInitializationException no Session”问题，这是因为当我们查询A后，Hibernate连接数据库的Session已经关闭了，当我们再使用A的getB去查询关联对象B时，就没有session可以使用了。若我们想要getB()成功，需要在Service层的方法上使用事务@Transactional注解，这样在该事务中Hibernate连接数据库的Session会一直有效，这样在调用getB()时可以成功地从数据库中查询到关联数据。

（2）FetchType.EAGER

饥饿加载，在查询实体A时，就立即查询出其关联的实体B。所以使用饥饿加载时，会发起多次查询，不仅查询实体A对应的数据库表，还会去查询实体A的关联实体B对应的数据库表，所以在控制台日志中我们可以看到多条的查询语句。

# CascadeType类型

假设ClassRoom实体类中定义了`private List<student> studentlist`属性，下面分别说明CascadeType各种类型的作用：

（1）CascadeType.PERSIST

当我们增加一个ClassRoom记录时，会在ClassRoom对应的数据表中插入一条记录，同时将studentlist中的Student实例，插入到student实例对应的数据库表中。说白了，就是级联插入。当studentlist属性上没有标注CascadeType.PERSIST，那么数据库中只插入ClassRoom记录，并不会级联插入Student啦。

（2）CascadeType.MERGE

当我们修改ClassRoom实例类的某个属性，同时修改studentlist中Student实例类的属性时，ClassRoom和Student实体类对应的数据库表都会被更新Update，说白了，CascadeType.MERGE是级联更新。若在studentlist属性上没有标明CascadeType.MERGE，则只会更新ClassRoom对应的数据库表，并不会更新Student实例类对应的数据库表啦。

（3）CascadeType.REMOVE

当我们删除ClassRoom实例类时，会将ClassRoom实体类对应的数据库表中的记录删除，同时会将Student实例类对应的数据库表中的记录删除。说白了，CascadeType.REMOVE是级联删除的功能。若在studentlist属性上没有标明CascadeType.REMOVE，则ClassRoom和Student对应的数据库表中的记录都不会删除，ClassRoom不会被删除，是因为Student表中有外键关联到ClassRoom，数据库层面的一致性导致都删除失败啦。

（4）CascadeType.REFRESH

对于业务系统，往往会存在多个用户，如果用户A取得了ClassRoom和其对应的studentlist，并且对ClassRoom和studentlist进行了修改，同时用户B也做了如此操作，但是用户B先保存了，然后用户A保存时，需要先刷新ClassRoom关联的studentlist，然后再把用户A的变更更新到数据库。这中场景就对应了CascadeType.REFRESH的需求。

（5）CascadeType.ALL

包含了CascadeType.PERSIST、CascadeType.MERGE、CascadeType.REMOVE以及CascadeType.REFRESH的功能。

# FetchType和CascadeType的默认值

（1）FetchType

当我们没有显式地指定FetchType时，则会有缺省值。在JPA2.0规范中，缺省值如下：

    OneToMany: LAZY
    ManyToOne: EAGER
    ManyToMany: LAZY
    OneToOne: EAGER

而若使用的是Hibernate框架，默认值都是LAZY。

（2）CascadeType

CascadeType缺省值是空，也就是说没有任何级联的操作。

学习资料参考于：
https://www.jianshu.com/p/9970495f76ab
http://westerly-lzh.github.io/cn/2014/12/JPA-CascadeType-Explaining/
https://www.zhihu.com/question/64187262
