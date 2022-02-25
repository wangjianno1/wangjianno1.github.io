---
title: Redis技术调研
date: 2022-02-25 10:34:44
tags: Redis
categories: NoSQL
---

# Redis简介

Redis是一个key-value的非关系型数据库（NoSQL），现在在各种系统中的使用越来越多，大部分情况下是因为其高性能的特性，被当做缓存使用。Redis应用广泛，尤其是被作为缓存使用，Redis由于其丰富的数据结构也可以被应用到其他场景。Redis的具有很多优势：

（1）读写性能高，10w次/s+的读速度，8w次/s+的写速度

（2）K-V，value支持的数据类型很多，包括字符串String、队列List、哈希Hash、集合Sets以及有序集合Sorted Sets五种不同的数据类型

（3）原子性，Redis的所有操作都是单线程原子性的

（4）特性丰富，支持订阅/发布模式，具有通知、设置key过期等特性

（5）在Redis 3.0版本引入了Redis集群，可用于分布式部署

Redis的功能有缓存，分布式锁以及消息队列。

# Redis的一些特性

（1）value支持的数据类型有很多，如字符串、哈希以及集合等等

（2）Redis实例支持多数据库，一个Redis实例最多支持16个数据库，编号从0到15

（3）支持事务，multi指示事务的开始，exec指示事务的执行，discard指示事务的丢弃。所有的指令在exec之前都不执行，只是被缓存到服务器的一个队列里，只有在收到exec指令后才开始执行

# Redis持久化

即将内存的数据持久化磁盘上，这样重启Redis进程之后，缓存的数据就不会丢失。当然也可以设置让Redis不做持久化，这样数据只会在内存中存在，当Redis进程重启时，数据就会丢失。关于Redis持久化有如下两种方式：

（1）RDB方式，即快照

周期性地将Redis内存中的数据持久化到磁盘上。

（2）AOF方式

以日志方式记录Redis的所有操作。

# Redis的速度为什么快

Redis采用的是基于内存的采用的是单进程单线程模型的KV数据库，由C语言编写。Redis之所以快的原因主要有：

（1）完全基于内存，绝大部分请求是纯粹的内存操作，非常快速。数据存在内存中，类似于HashMap，HashMap的优势就是查找和操作的时间复杂度都是O(1)。

（2）数据结构简单，对数据操作也简单，Redis中的数据结构是专门进行设计的。

（3）采用单线程，避免了不必要的上下文切换和竞争条件，也不存在多进程或者多线程导致的切换而消耗CPU，不用去考虑各种锁的问题，不存在加锁释放锁操作，没有因为可能出现死锁而导致的性能消耗。

（4）使用多路I/O复用模型，非阻塞IO
需要注意的是，Redis是单线程的，只是在处理网络请求的时候只有一个线程来处理，一个正式的Redis Server运行的时候肯定是不止一个线程的。例如Redis进行持久化的时候会以子进程或者子线程的方式执行（具体是子线程还是子进程待读者深入研究）。至于Redis处理请求时使用单线程，官方解释说，Redis的瓶颈不在CPU，而在内存和网络带宽。

正是由于Redis处理请求是单线程的，所以不能充分利用CPU多核的特性。如果要想利用CPU多核特性，我们可以在一台机器上启动多个Redis实例就好了。

# Redis支持抽象数据类型

Redis的value不仅支持整型、浮点型、字符、字符串这些基础数据类型，还支持一些抽象数据类型：

（1）list

list即是链表。操作list的常用命令有rpush，lpop，lpush，rpop，lrange，llen等。命令举例如下：

```bash
rpush myList value1         #向list的头部（右边）添加元素
rpush myList value2 value3  #向list的头部（最右边）添加多个元素
lpop myList                 #将list的尾部(最左边)元素取出
lrange myList 0 1           #查看对应下标的list列表， 0为start，1为end
lrange myList 0 -1          #查看列表中的所有元素，-1表示倒数第一
```

![](/images/redis_1_1.png)

（2）hash

hash类似于JDK1.8前的HashMap。操作hash的常用命令有hset，hmset，hexists，hget，hgetall，hkeys，hvals等。命令举例如下：

```bash
hmset userInfoKey name "guide" description "dev" age “24”  #初始化一个hash对象
hexists userInfoKey name  #查看key对应的value中指定的字段是否存在
hget userInfoKey name     #获取存储在哈希表中指定字段的值
hgetall userInfoKey       #获取在哈希表中指定key的所有字段和值
hkeys userInfoKey         #获取key列表
hvals userInfoKey         #获取value列表
hset userInfoKey name "GuideGeGe"  #修改某个字段对应的值
```

（3）set

set类似于Java中的HashSet。Redis中的set类型是一种无序集合，集合中的元素没有先后顺序。操作set的常用命令有sadd，spop，smembers，sismember，scard，sinterstore，sunion等。

```bash
sadd mySet value1 value2  #添加元素进去
sadd mySet value1         #不允许有重复元素
smembers mySet            #查看set中所有的元素
scard mySet               #查看set的长度
sismember mySet value1    #检查某个元素是否存在set中，只能接收单个元素

sadd mySet2 value2 value3
sinterstore mySet3 mySet mySet2  #获取mySet和mySet2的交集并存放在mySet3中
```

（4）sorted set

和set相比，sorted set增加了一个权重参数score，使得集合中的元素能够按score进行有序排列，还可以通过score的范围来获取元素的列表。操作sorted set的常用命令有zadd，zcard，zscore，zrange，zrevrange，zrem等。

```bash
zadd myZset 3.0 value1             #添加元素到sorted set中3.0为权重
zadd myZset 2.0 value2 1.0 value3  #一次添加多个元素
zcard myZset          #查看sorted set中的元素数量
zscore myZset value1  #查看某个value的权重
zrange myZset 0 -1    #顺序输出某个范围区间的元素，0-1表示输出所有元素
zrange myZset 0 1     #顺序输出某个范围区间的元素，0为start，1为stop
zrevrange myZset 0 1  #逆序输出某个范围区间的元素，0为start，1为stop
```

（5）bitmap

 bitmap存储的是连续的二进制数字（0和1），通过bitmap, 只需要一个bit位来表示某个元素对应的值或者状态，key就是对应元素本身。操作bitmap的常用命令有setbit，getbit，bitcount，bitop。

# Redis分布式集群的搭建

未完待续

# 其他闲杂

缓存击穿，缓存穿透
