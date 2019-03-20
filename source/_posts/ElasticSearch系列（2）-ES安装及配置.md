---
title: ElasticSearch系列（2）_ES安装及配置
date: 2018-02-02 10:35:51
tags: ElasticSearch
categories: ELKStack
---

# ElasticSearch的配置和安装

前提申明：本次部署测试用的是elasticsearch-5.3.0，依赖1.8或1.8以上的JDK版本

（1）安装Java JDK并配置CLASSPATH,PATH,JAVA_HOME环境变量

（2）到ES官网`https://www.elastic.co/downloads/elasticsearch`上下载ES的zip包，解压即可。

（3）启动

执行`./bin/elasticsearch`即可在前台启动ES，或者执行`./bin/elasticsearch -d`在后台启动ES

（4）测试

在浏览器中输入`http://x.x.x.x:9200`，即可看到：

![](/images/elasticsearch_2_1.png)

备注：如果在远程主机上访问`http://x.x.x.x:9200`，需要在${ES_HOME}/config/elasticsearch.yml中将network.host的配置打开，且将后面ip修改为0.0.0.0

# ElasticSearch的常见配置项

ElasticSearch的配置文件为${ES_HOME}/config/elasticsearch.yml，一般来说，ElasteSearch集群不需要配置太多东西，使用缺省的配置就可以了。

（1）cluster.name

集群的名称。如果没有配置，默认为elasticserach.  cluster.name相同的elasticsearch节点，会自动组成一个名称为cluster.name的配置值的ElasticSearch集群

（2）node.name

节点的名称。如果没有配置，ElasticSearch会在你的节点启动的时候随机给它指定一个名字。ElasticSearch节点每次启动时，都会得到一个新的名字。这会使日志变得很混乱，因为所有节点的名称都是不断变化的。因此我们需要在配置文件中人为定义一个有意义的节点名称。

（3）path.data

指定es节点的数据存放路径，可以通过path.data: /path/to/data1,/path/to/data2的形式指定多个目录，当然也可以只指定一个目录。默认是存储在${ES_HOME}/data

（4）path.logs

指定es节点的运行日志存放路径。默认存储在${ES_HOME}/logs

（5）path.plugins

指定es的插件存放路径。默认是放到${ES_HOME}/plugins

（6）transport.tcp.port

设置节点间的交互的tcp端口，默认是9300

（7）http.port

设置集群对外服务的http端口，默认为9200

（8）node.master

指定该节点是否有资格被选举成为master节点，默认是true.  es是默认集群中的第一台机器为master，如果这台机挂了就会重新选举master

（9）node.data

指定该节点是否存储索引数据，默认为true.

（10）index.number_of_shards

设置默认索引分片个数，默认为5片

（11）index.number_of_replicas

设置默认索引副本replica个数，默认为1个副本

（12）http.enabled

是否使用http协议对外提供服务，默认为true

（13）ElasticSearch重启恢复方面的配置

假设我们的集群有10个节点，现在我们要对10个节点进行升级并重启，假设5个节点先正常启动了，这五个节点会相互通信，选出一个 master，从而形成一个集群。 然后集群发现数据不再均匀分布，因为有5 个节点在集群中丢失了，所以他们之间会立即启动分片复制。这时，另外的5个节点启动完成了，这些节点会发现它们的数据正在被复制到其他节点，所以他们删除本地数据（因为这份数据要么是多余的，要么是过时的）。 然后整个集群重新进行平衡，因为集群的大小已经从5变成了10。对比有TB量级的ElasticSearch集群，这种来回地数据移动，无疑会大量消耗集群计算或网络资源。通常我们在通过配置如下的参数来缓解这种情况：

	gateway.recover_after_nodes: 8
	gateway.expected_nodes: 10
	gateway.recover_after_time: 5m

上述参数表示，满足如下条件之一集群才开始进行数据恢复：一是集群在线的节点数为10个；二是集群在线的节点数至少为8个，且等待5分钟

（14）discovery.zen.minimum_master_nodes

ElasticSearch集群一旦建立起来以后，会选举出一个master，其他都为slave节点。当配置了discovery.zen.minimum_master_nodes参数后，当集群面临重新选主时，所有可能成为master的节点的集合（仲裁集）要大于等于discovery.zen.minimum_master_nodes。所以一般来说，`discovery.zen.minimum_master_nodes`设置为`(master_eligible_nodes / 2) + 1`，其中master_eligible_nodes表示`node.master=true`的节点数，因此可以避免一个ES集群出现脑裂的问题（所谓脑裂指的是，集群中某些节点脱离了集群后，自动组成一个新的集群。这样的话，原来的一个集群就变成了两个集群，会导致一些不确定的问题发生）。

比如我们集群有5个节点，我们需要配置discovery.zen.minimum_master_nodes=(5/2)+1=3，所以当这个集群中有2个节点断连脱离集群后，不会选主成功，当然也不会成为一个独立的集群。而另外3个节点可以选主成功，从而组成一个单独的集群。

备注：

```
node.master=true  & node.data=true  —— 表示节点既可以是master节点，也可以是data节点
node.master=false & node.data=true  —— 表示节点只可能是data节点，不可能成为master节点
node.master=true  & node.data=false —— 表示节点只可能成为master节点，不存储数据
node.master=false & node.data=false —— 表示节点不会成为master节点，也不存储数据。只能用来作为client节点
```

# ElasticSearch的最佳实践

（1）部署ElasticSearch的机器，64GB内存的机器是非常理想的，但是32GB和16GB机器也是很常见的。少于8GB会适得其反（你最终需要很多很多的小机器），大于64GB的机器也会有问题。

（2）当ElasticSearch集群已经在生产环境中，如果这时需要修改集群的配置参数，可以有两种方式：一种是修改配置，然后重启ES实例；一种是使用ES的HTTP API直接修改内存中的配置，不需要重启。当然推荐第二种方式来修改集群参数。

（3）ElasticSearch中有索引有type的概念，建议一个index就配置一个type就好了。ES中type的概念逐渐弱化，到ES6.0时候，可能就没有type的概念了。

# ES安装与配置常见问题

（1）elasticsearch安装和配置问题

elasticsearch出于安全的考虑，不允许使用root账户启动，所以要为elasticsearch单独创建账户。命令如下：

```
useradd elasticsearch
chown -R elasticsearch:elasticsearch ~/prod/elasticsearch-2.4.0
su elasticsearch && ./bin/elasticsearch    #加上-d，将在后台启动
```

（2）无法使用`http://192.168.65.239:9200/`来测试，需要修改config/elasticsearch.yml中network.host: 192.168.0.1，改成network.host: 0.0.0.0

（3）出现failed to resolve local host, fallback to loopback错误，因为hostname没有在/etc/hosts中，需要将机器名追加到/etc/hosts中127.0.0.1这一行的后面

（4）elasticsearch开启了9200和9300两个端口，9200是提供的http接口，9300是其他的非http接口。如果是用flume的sink往elasticsearch中写的话，需要使用9300端口

（5）http://www.jianshu.com/p/89f8099a6d09

今天开工，在看ES时候发现前几天已经发布了5.2.0，就安装了一下，岂料安装完一直启动不了，可以说是一个bug。报错如下：


	[2017-05-09T13:19:18,665][INFO ][o.e.b.BootstrapChecks    ] [sgw-node-1] bound or publishing to a non-loopback or non-link-local address, enforcing bootstrap checks
	ERROR: bootstrap checks failed
	max file descriptors [65535] for elasticsearch process is too low, increase to at least [65536]
	max number of threads [1024] for user [elasticsearch] is too low, increase to at least [2048]
	max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
	system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk

这是在因为Centos6不支持SecComp，而ES5.2.0默认`bootstrap.system_call_filter`为true进行检测，所以导致检测失败，失败后直接导致ES不能启动。

在elasticsearch.yml中配置`bootstrap.system_call_filter`为false，注意要在Memory下面：

	bootstrap.memory_lock: false
	bootstrap.system_call_filter: false

对于`max file descriptors`和`max number of threads`的问题，可以修改`/etc/security/limits.conf`，配置如下：
	*                soft   nofile          65536
	*                hard   nofile          65536
	elasticsearch    soft   nproc           16384
	elasticsearch    hard   nproc           32768

对于`vm.max_map_count`的问题，可以修改/etc/sysctl.conf，配置如下：

	vm.max_map_count=262144

# ElasticSearch中的一些闲杂知识

（1）在ElasticSearch中一个文档有很多的字段Field，在ES中文档不仅包括数据本身，还包括一些元数据Metadata，例如_index/_type/_id. 其中_index表示文档所属索引名称，_type表示文档属于索引的哪个类型，_id表示文档的id，id可以自己指定，也可以由ES集群自动生成。在一个ElasticSearch集群中三元组（_index, _type, _id）唯一确定一个文档。

（2）ElasticSearch的一些内置字段

![](/images/elasticsearch_2_2.png)

（3）关于ES heap设置，官方建议ES的内存不要超过系统可用内存的一半，并且不要超过32GB。https://elasticsearch.cn/article/32

（4）在config/jvm.options中可以修改ElasticSearch JAVA应用的heap大小

# 生产环境中ES集群全局配置修改方式

（1）修改配置文件并重启集群的每个节点

修改config/elasticsearch.yml静态文件，然后重启集群的每个节点。这个方式比较粗暴，生产环境中不建议使用。

（2）使用动态更新集群配置（Cluster Update Settings）API

使用动态更新就集群配置（Cluster Update Settings）API，又有两种，即一种是瞬时Transient生效，另一种是永久Persistent生效。

A）瞬时Transient

这些变更在集群重启之前一直会生效。一旦整个集群重启，这些配置就被清除。操作方法如下：

```bash
PUT /_cluster/settings
{
    "transient" : {
        "indices.recovery.max_bytes_per_sec" : "20mb"
    }
}
```

B）永久Persistent

这些变更会永久存在直到被显式修改。即使全集群重启它们也会存活下来，当和静态配置config/elasticsearch.yml有冲突时，会覆盖掉静态配置文件里的选项。操作方法如下：

```bash
PUT /_cluster/settings
{
    "persistent" : {
        "indices.recovery.max_bytes_per_sec" : "50mb"
    }
}
```
