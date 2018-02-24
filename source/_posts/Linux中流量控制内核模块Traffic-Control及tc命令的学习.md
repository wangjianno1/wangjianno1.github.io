---
title: Linux中流量控制内核模块Traffic Control及tc命令的学习
date: 2018-02-24 15:54:24
tags:
categories: Linux
---

# TC内核模块及tc工具简介

在传统的TCP/IP网络的路由器中，所有的IP数据包的传输都是采用FIFO（先进先出），尽最大努力传输的处理机制。在早期网络数据量和关键业务数据不多的时候，并没有体现出非常大的缺点，路由器简单的把数据报丢弃来处理拥塞。但是随着计算机网络的发展， 数据量的急剧增长，以及多媒体，VOIP数据等对延时要求高的应用的增加。路由器简单丢弃数据包的处理方法已经不再适合当前的网络。单纯的增加网络带宽也不能从根本上解决问题。所以网络的开发者们提出了服务质量的概念。概括的说：就是针对各种不同需求，提供不同服务质量的网络服务功能。提供QoS能力将是对未来IP网络的基本要求。Linux内核网络协议栈从2.2.x开始，就实现了对服务质量的支持模块，即从内核的层面支持QOS，具体的代码位于net/sched/目录。在linux里面，对这个内核功能模块的称呼是Traffic Control，简称TC。简单来说，TC就是Linux进行流量控制的工具。

在Linux中，Traffic Control提供了一个tc命令工具，可以用来查看和配置Traffic Control内核模块。

# 流量控制的处理对象

Traffic Control内核模块通过三种对象来进行流量控制，分别是qdisc（排队规则）、class（类别）和filter（过滤器）。

Traffic Control模块进行流量控制的基础是队列(qdisc)，每个网卡都与一个队列(qdisc)相联系，每当内核需要将报文分组从网卡发送出去，都会首先将该报文分组添加到该网卡所配置的队列中，由该队列决定报文分组的发送顺序。然后，内核会按照队列的顺序尽可能多地从qdisc里面取出数据包，把它们交给网络适配器驱动模块。

有些队列的功能是非常简单的，它们对报文分组实行先来先走的策略，我们把这些简单的队列称为不可分类（Classless）的队列。而有些队列则功能复杂，会将不同的报文分组进行排队、分类，并根据不同的原则，以不同的顺序发送队列中的报文分组。为实现这样的功能，这些复杂的队列需要使用不同的过滤器(Filter)来把报文分组分成不同的类别(Class)，我们把这些复杂的队列称为可分类(Classiful)的队列。通常，要实现功能强大的流量控制，可分类的队列是必不可少的。因此，类别(Class)和过滤器(Filter)也是流量控制的另外两个重要的基本概念。

下图是可分类队列的概念图：

![](/images/traffic_control_1_1.png)

由上图可以看出，类别(Class)和过滤器(Filter)都是队列的内部结构，并且可分类的队列可以包含多个类别，同时，一个类别又可以进一步包含有子队列，或者子类别。所有进入该类别的报文分组可以依据不同的原则放入不同的子队列或子类别中，以此类推。而过滤器(Filter)是队列用来对数据报文进行分类的工具，它决定一个数据报文将被分配到哪个类别中。

下面分别简单介绍下qdisc（排队规则）、class（类别）和filter（过滤器）：

（1）qdisc

qdisc，英文全称为queueing discipline。qdisc分成不可分类的qdisc和可分类的qdisc两种。

不可分类的qdisc的有：

+ [p|b]fifo

使用最简单的qdisc，纯粹的先进先出。只有一个参数limit，用来设置队列的长度。pfifo是以数据包的个数为单位。bfifo是以字节数为单位。

+ pfifo_fast

在编译内核时，如果打开了高级路由器(Advanced Router)编译选项，pfifo_fast就是系统的标准QDISC。它的队列包括三个波段(band)。在每个波段里面，使用先进先出规则。而三个波段(band)的优先级也不相同，band 0的优先级最高，band 2的最低。如果band里面有数据包，系统就不会处理band 1里面的数据包，band 1和band 2之间也是一样。数据包是按照服务类型(Type of Service,TOS)被分配多三个波段(band)里面的。

+ red

red是Random Early Detection(随机早期探测)的简写。如果使用这种QDISC，当带宽的占用接近于规定的带宽时，系统会随机地丢弃一些数据包。它非常适合高带宽应用。

+ sfq

sfq是Stochastic Fairness Queueing的简写。它按照会话(session--对应于每个TCP连接或者UDP流)为流量进行排序，然后循环发送每个会话的数据包。

+ tbf

tbf是Token Bucket Filter的简写，适合于把流速降低到某个值。

可分类的qdisc的有：

+ CBQ

CBQ是Class Based Queueing(基于类别排队)的缩写。它实现了一个丰富的连接共享类别结构，既有限制(shaping)带宽的能力，也具有带宽优先级管理的能力。带宽限制是通过计算连接的空闲时间完成的。空闲时间的计算标准是数据包离队事件的频率和下层连接(数据链路层)的带宽。

+ HTB

HTB是Hierarchy Token Bucket的缩写。通过在实践基础上的改进，它实现了一个丰富的连接共享类别体系。使用HTB可以很容易地保证每个类别的带宽，虽然它也允许特定的类可以突破带宽上限，占用别的类的带宽。HTB可以通过TBF(Token Bucket Filter)实现带宽限制，也能够划分类别的优先级。

+ PRIO

PRIO QDisc不能限制带宽，因为属于不同类别的数据包是顺序离队的。使用PRIO QDisc可以很容易对流量进行优先级管理，只有属于高优先级类别的数据包全部发送完毕，才会发送属于低优先级类别的数据包。为了方便管理，需要使用iptables或者ipchains处理数据包的服务类型(Type Of Service,ToS)。

（2）Class

（3）Filter

# 流量控制对象的命名规则

所有的qdisc、类和过滤器都有ID。ID可以手工设置，也可以有内核自动分配。ID由一个主序列号和一个从序列号组成，两个数字用一个冒号分开。 

（1）qdisc

一个qdisc会被分配一个主序列号，叫做句柄(handle)，然后把从序列号作为类的命名空间。句柄采用像10:这样的表达方式。 备注队列的从序号默认是0，所以一般可以省略从序列号，例如队列1:和1:0其实是等价的。

（2）类(CLASS)

在同一个qdisc里面的类分享这个qdisc的主序列号，但是每个类都有自己的从序列号，叫做类识别符(classid)。

（3）过滤器(FILTER)

过滤器的ID有三部分，只有在对过滤器进行散列组织才会用到。详情请参考tc-filters手册页。

# tc工具配置的基本步骤

在Linux中，流量控制都是通过TC这个工具来完成的。通常，要对网卡进行流量控制的配置，需要进行如下的步骤：

（1）为网卡配置一个队列

（2）在该队列上建立分类

（3）根据需要建立子队列和子分类

（4）为每个分类建立过滤器

我的理解是，filter圈定满足一定规则的所有数据包，然后将这些数据包引入到某一个类Class中（class中会设定非常多的流量控制策略），然后会关联到一个队列qdisc中（qdisc中实现一些数据包排队的算法）

# tc命令的使用方法

```bash
tc qdisc  [ add | change | replace | link ] dev DEV [ parent qdisc-id | root ] [ handle qdisc-id ] qdisc [ qdisc  specific parameters ]
tc class [ add | change | replace ] dev DEV parent qdisc-id [ classid class-id ] qdisc [ qdisc  specific  parameters ]
tc filter  [ add | change | replace ] dev DEV [ parent qdisc-id | root ] protocol protocol prio priority filtertype [ filtertype specific parameters ] flowid flow-id
tc [ FORMAT ] qdisc show [ dev DEV ]
tc [ FORMAT ] class show dev DEV
tc filter show dev DEV
tc [ -force ] [ -OK ] -b[atch] [ filename ]
```

常用的命令举例：

```bash
tc qdisc list dev eth0        #查看指定网卡eth0上的所有队列qdisc
tc class list dev eth0        #查看指定网卡eth0上的所有过滤器class
tc filter list dev eth0       #查看指定网卡eth0上的所有过滤器filter
tc -s -d qdisc show dev eth0  #查看指定网卡eth0的qdisc的详细的工作状态，其中-s表示统计数据，-d表示详细内容
tc -s -d class show dev eth0  #查看指定网卡eth0的class的详细的工作状态，其中-s表示统计数据，-d表示详细内容
tc -s -d filter show dev eth0 #查看指定网卡eth0的filter的详细的工作状态，其中-s表示统计数据，-d表示详细内容
```

# tc进行流量控制的举例

假设eth0出口有100mbit/s的带宽，分配给WWW、E-mail和Telnet三种数据流量，其中分配给WWW的带宽为40Mbit/s，分配给Email的带宽为40Mbit/s，分配给Telnet的带宽为20Mbit/S。这里，我们以HTB队列为例，来讲述tc工具的使用，详细步骤如下：

（1）创建HTB队列

首先，需要为网卡eth0配置一个HTB队列，使用下列命令：

```bash
tc qdisc add dev eth0 root handle 1: htb default 11
```

备注：命令中的"add"表示要添加qdisc；“dev eth0”表示要操作的网卡为eth0；“root”表示为网卡eth0添加的是一个根队列；“handle 1:”表示队列的句柄为1:0；“htb”表示要添加的队列为HTB队列；命令最后的“default 11”是htb特有的队列参数，意思是所有未分类的流量都将分配给类别1:11。

（2）为根队列创建相应的类别

可以利用下面这三个命令为根队列1:0创建三个class类别，分别是1:11、1:12和1:13，它们分别占用40、40和20Mbit/s的带宽。

```bash
tc class add dev eth0 parent 1: classid 1:11 htb rate 40mbit ceil 40mbit   #创建class，类识别符为1:11，其中1是与父qdisc的主序号一致
tc class add dev eth0 parent 1: classid 1:12 htb rate 40mbit ceil 40mbit   #创建class，类识别符为1:12，其中1是与父qdisc的主序号一致
tc class add dev eth0 parent 1: classid 1:13 htb rate 20mbit ceil 20mbit  #创建class，类识别符为1:13，其中1是与父qdisc的主序号一致
```

备注：命令中，“parent 1:”表示类别class的父亲为根队列1: ；“classid 1:11”表示创建一个标识为1:11的类别；“rate 40mbit”表示系统将为该类别确保带宽40mbit；“ceil 40mbit”表示该类别的最高可占用带宽为40mbit。

（3）为各个类别设置过滤器

由于需要将WWW、E-mail、Telnet三种流量分配到三个类别，即上述1:11、1:12和1:13，因此，需要创建三个过滤器，如下面的三个命令:

```bash
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dport 80 0xffff flowid 1:11
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dport 25 0xffff flowid 1:12
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dport 23 oxffff flowid 1:13
```

备注：“protocol ip”表示该过滤器应该检查报文分组的协议字段；“prio 1”表示它们对报文处理的优先级是相同的，对于不同优先级的过滤器，系统将按照从小到大的优先级顺序来执行过滤器，对于相同的优先级，系统将按照命令的先后顺序执行；“u32”说明这几个过滤器用到了u32选择器（命令中u32后面的部分）来匹配不同的数据流。以第一个命令为例，判断的是dport字段，如果该字段与Oxffff进行与操作的结果是80，则“flowid 1:11”表示将把该数据流分配给类别1:11。

# 一个使用tc工具组成的流量控制脚本

附上如下为工作中用到tc工具编写的一个shell流量控制脚本：

```bash
#1.清空队列
tc qdisc del dev eth0 root

#2.添加htb队列
tc qdisc add dev eth0 root handle 1: htb default 30

#3.添加class
tc class add dev eth0 parent 1:  classid 1:1  htb rate 1000mbit burst 10mbit
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 1000mbit burst 5mbit
tc class add dev eth0 parent 1:1 classid 1:20 htb rate 1mbit burst 10k
tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1mbit burst 10k
tc class add dev eth0 parent 1:1 classid 1:40 htb rate 300mbit burst 1mbit

4.为子类别添加子队列
tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10
tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10
tc qdisc add dev eth0 parent 1:30 handle 30: sfq perturb 10
tc qdisc add dev eth0 parent 1:40 handle 40: sfq perturb 10

#5.添加filter
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip dst 10.13.85.177/32  flowid 1:30
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip dst 10.13.91.52/32  flowid 1:30
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip src 10.13.91.52/32  flowid 1:30
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip dst 10.13.91.53/32  flowid 1:20
tc filter add dev eth0 protocol ip parent 1:0 prio 2 u32 match ip src 10.13.91.53/32  flowid 1:20
tc filter add dev eth0 protocol ip parent 1:0 prio 100 u32 match ip dst 0.0.0.0/0  flowid 1:40
tc filter add dev eth0 protocol ip parent 1:0 prio 100 u32 match ip src 0.0.0.0/0  flowid 1:40

#6.查看统计信息
tc qdisc list dev eth0
tc filter list dev eth0
tc -s -d class  show dev eth0
tc -s -d filter show dev eth0
```


学习资料参考于：
http://www.ibm.com/developerworks/cn/linux/kernel/l-qos/
https://www.ibm.com/developerworks/cn/linux/1412_xiehy_tc/index.html
http://blog.csdn.net/qinyushuang/article/details/46611709
