---
title: ElasticSearch系列（4）_Shard Allocation策略
date: 2018-02-02 11:41:43
tags: ElasticSearch
categories: ELKStack
---

# ES的Shard Allocation策略简介

某个shard分配在哪个节点上，一般来说，是由ES集群自动决定的。以下几种情况会触发分配动作：

	新索引生成
	索引的删除
	新增副本分片
	节点增减引发的数据均衡

ES提供了一系列参数详细控制这部分逻辑，如下：

（1）cluster.routing.allocation.enable

该参数用来控制允许分配哪种分片。默认是all。可选项还包括primaries和new_primaries。none则彻底拒绝分片。

（2）cluster.routing.allocation.allow_rebalance

该参数用来控制什么时候允许数据均衡。默认是indices_all_active，即要求所有分片都正常启动成功以后，才可以进行数据均衡操作，否则的话，在集群重启阶段，会浪费太多流量了。

（3）cluster.routing.allocation.cluster_concurrent_rebalance

该参数用来控制集群内同时运行的数据均衡任务个数。默认是2个。如果有节点增减，且集群负载压力不高的时候，可以适当加大。

（4）cluster.routing.allocation.node_initial_primaries_recoveries

该参数用来控制节点重启时，允许同时恢复几个主分片。默认是4个。如果节点是多磁盘，且IO压力不大，可以适当加大。

（5）cluster.routing.allocation.node_concurrent_recoveries

该参数用来控制节点除了主分片重启恢复以外其他情况下，允许同时运行的数据恢复任务。默认是2个。所以，节点重启时，可以看到主分片迅速恢复完成，副本分片的恢复却很慢。除了副本分片本身数据要通过网络复制以外，并发线程本身也减少了一半。当然，这种设置也是有道理的——主分片一定是本地恢复，副本分片却需要走网络，带宽是有限的。从ES 1.6开始，冷索引的副本分片可以本地恢复，这个参数也就是可以适当加大了。

（6）indices.recovery.concurrent_streams

该参数用来控制节点从网络复制恢复副本分片时的数据流个数。默认是3个。可以配合上一条配置一起加大。

（7）indices.recovery.max_bytes_per_sec

该参数用来控制节点恢复时的速率。默认是40MB。显然是比较小的，建议加大。

# ES支持的一些特殊的Shard Allocation策略

ES还有一些其他的分片分配控制策略，比如以tag和rack_id作为区分等。一般来说，ElasticStack场景中使用不多，在ES集群运维中会常常使用到。

（1）基于磁盘空间的Shard Allocation

为了保护节点数据安全，ES会定时（cluster.info.update.interval，默认30 秒）检查一下各节点的数据目录磁盘使用情况。在达到cluster.routing.allocation.disk.watermark.low（默认 85%）的时候，新索引分片就不会再分配到这个节点上了。在达到cluster.routing.allocation.disk.watermark.high （默认 90%）的时候，就会触发该节点现存分片的数据均衡，把数据挪到其他节点上去。这两个值不但可以写百分比，还可以写具体的字节数。

备注：这个可以解决ES集群中各节点的磁盘空间不一致的问题哦。

具体参见官方文档：https://www.elastic.co/guide/en/elasticsearch/reference/5.3/disk-allocator.html

（2）解决热索引分片不均的问题

略。

# 手动Shard Allocation

上面说的各种配置，都是从ES集群自身的策略层面来控制分片分配的规则。在必要的时候，还可以通过ES的reroute接口，手动完成对分片的分配选择的控制。reroute接口支持五种指令allocate_replica, allocate_stale_primary, allocate_empty_primary, move和cancel。


学习资料参考于：
https://github.com/chenryn/ELKstack-guide-cn/blob/master/elasticsearch/principle/shard-allocate.md