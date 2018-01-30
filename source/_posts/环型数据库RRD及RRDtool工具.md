---
title: 环型数据库RRD及RRDtool工具
date: 2018-01-30 17:23:33
tags: RRD
categories: 数据库
---

# RRD

RRD全称是Round Robin Database，即「环型数据库」。顾名思义，它是一种循环使用存储空间的数据库，适用于存储和时间序列相关的数据。RRD数据库在被创建的时候就已经定义好了数据库的大小，当空间存储满了以后，又从头开始覆盖旧的数据，这样整个存储空间的大小就是一个固定的数值，所以和其他线性增长的数据库不同 。 可以把RRD 理解为一个有时间刻度的圆环，每个刻度上可以存储一个数值，同时有一个从圆心指向最新存储值的指针。

RRD的数据库文件是以.rrd为结尾的文件，当然也可以随便定义文件名，但是最好后缀是rrd.

# RRDtool

RRDtool是一个往RRD数据库中存放和读取数据的工具，同时RRDtool又可以读取RRD数据库中的数据来动态创建图表。所以RRDtool看起来既是后台工具，也是前端画图工具。举例来说：

（1）使用rrdtool create命令创建一个名为test.rrd的RRD数据库

```bash
rrdtool create test.rrd
--step 300
DS:miles:COUNTER:600:0:1024
RRA:AVERAGE:0.5:2:8
RRA:AVERAGE:0.5:4:7
```

（2）使用rrdtool update命令存储监测值

```bash
rrdtool update test.rrd 920804700:12345 920805000:12357 920805300:12363
```

备注：表示插入3条记录，时间点920804700时，被监测对象数值为12345 ；时间点920805000时，被监测对象数值为12357 ；时间点920805300时，被监测对象数值为12363.

（3）使用rrdtool graph输出一张png图片

```bash
rrdtool graph myrouter-day.png --start -86400
DEF:inoctets=myrouter.rrd:input:AVERAGE
DEF:outoctets=myrouter.rrd:output:AVERAGE
AREA:inoctets#00FF00:"In traffic"
LINE1:outoctets#0000FF:"Out traffic"
```


学习资料参考于：
http://www.jianshu.com/p/b925b1584ab2
