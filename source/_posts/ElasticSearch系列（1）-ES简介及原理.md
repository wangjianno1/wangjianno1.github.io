---
title: ElasticSearch系列（1）_ES简介及原理
date: 2018-01-31 17:46:30
tags: ElasticSearch
categories: ELKStack
---

# ElasticSearch简介

Elasticsearch是一个基于Apache Lucene(TM)的开源搜索引擎。无论在开源还是专有领域，Lucene可以被认为是迄今为止最先进、性能最好的、功能最全的搜索引擎库。但是，Lucene只是一个库。想要使用它，你必须使用Java来作为开发语言并将其直接集成到你的应用中，更糟糕的是，Lucene非常复杂，你需要深入了解检索的相关知识来理解它是如何工作的。

Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。

ElasticSearch不仅仅是Lucene，并且也不仅仅只是一个全文搜索引擎。 它可以被下面这样准确的形容：

（1）一个分布式的实时文档存储，每个字段可以被索引与搜索

（2）一个分布式实时分析搜索引擎

（3）能胜任上百个服务节点的扩展，并支持 PB 级别的结构化或者非结构化数据

备注：Apache Solr项目和ElasticSearch的功能类似，Apache Solr也是基于Lucene库的开源搜索引擎。Apache Solr在2010年与Apache Lucene项目合并。

如下为ElasticSearch的架构图：

![](/images/elasticsearch_1_1.png)

备注：Apache Lucene是一个单机版的全文索引和搜索的工具包，通过ElasticSearch的封装，可以让Apache lucene具有分布式的扩展能力。

# ElasticSearch中的一些概念

（1）集群和节点

节点(node)是一个运行着的ElasticSearch实例。集群(cluster)是一组具有相同cluster.name的节点集合，他们协同工作，共享数据并提供故障转移和扩展功能，当然一个节点也可以组成一个集群。

我们通过修改config/elasticsearch.yml文件，来修改cluster.name名称，然后重启ELasticsearch即可。cluster.name默认为elasticsearch，我们最好修改一个自定义的名称，这样可以防止一个新启动的节点加入到相同网络中的另一个同名的集群中。

另外，节点的名称可以通过node.name配置来修改。

（2）索引、类型、文档

和关系型数据库对比一下概念：

	Relational DB -> Databases -> Tables -> Rows      -> Columns
	ElasticSearch -> Indices   -> Types  -> Documents -> Fields

![](/images/elasticsearch_1_2.png)

备注：
Elasticsearch集群可以包含多个索引(indices)（数据库），每一个索引可以包含多个类型(types)（表），每一个类型包含多个文档(documents)（行），然后每个文档包含多个字段(Fields)（列）

（3）索引

索引(index)这个词在Elasticsearch中有着不同的含义，所以有必要在此做一下区分：

A）索引（名词） 

如上文所述，一个索引(index)就像是传统关系数据库中的数据库，它是相关文档存储的地方，index的复数是indices 或indexes。

B）索引（动词） 

「索引一个文档」表示把一个文档存储到索引（名词）里，以便它可以被检索或者查询。这很像SQL中的INSERT关键字，差别是，如果文档已经存在，新的文档将覆盖旧的文档。

（4）分片和副本（Shards & Replicas）

一个索引可能存储大量的数据，这个数据量可能超过一个单独节点的硬盘大小。比如说，十亿个文档的索引可能会占用1TB大小的磁盘空间，可能就不适合一个单独节点的磁盘，也可能会导致这个节点处理查询请求非常缓慢。 为了解决这个问题，ElasticSearch提供一种能力，这种能力可以把索引细分到多个称为分片的地方中去。当我们往ES中写入文档时，ES按照一定的hash策略`[ shard = hash(routing) % number_of_primary_shards ]`，将文档写入某一个分片中，所以一个索引的多个shard是同时工作的，而不是说一个shard写满之后，就不在写了，然后创建出一个新的shard。当你创建索引的时候，可以自定义分片的数量。每个分片对于它自己都是全功能和独立索引的。

在一个网络、云环境中，任何时候都有可能失败，万一 一个分片、节点以某种方式下线或者消失，有一个故障恢复机制是非常有用并被建议的。ElasticSearch允许索引的分片有一个或多个副本，这个副本我们称为复制分片，或直接叫做副本。

备注：一个索引的shards的数量，是在创建shards时指定的，创建之后不可修改。而一个shard的replica数量是可以在索引创建之后根据需要修改的。

# ElasticSearch集群工作机制

（1）ElasticSearch集群基本概念

ElasticSearch集群中一个节点被选举为master节点，其他的节点则为slave节点。master节点负责集群整体状态的维护，例如创建或删除索引、增加或删除节点等等。对于用户，可以和集群中的任意节点进行通信，包括主节点。每个节点都知道某个文档的存放位置，并且能够将请求转发到持有所需数据的节点。用户直接通信的节点负责将需要的数据从各个节点收集起来，然后返回给用户。这个过程都是由ES透明地进行管理。

当我们创建索引时，ElasticSearch默认将这个索引配置5个shard和1个replica（也就是新索引有5个分片，每个分片又有一个副本）。

A）一个没有数据，且只有一个节点的空集群

![](/images/elasticsearch_1_3.png)

该节点是集群中有一个节点，该节点为master节点

B） 在（A）的基础上，创建一个有3个shard，1个replica的索引

![](/images/elasticsearch_1_4.png)

三个shard均被分配到NODE1上。由于只有一个节点，3个replica没有被分配，当前集群状态为yellow

C）在（B）的基础上，给ES集群增加一个节点NODE2

![](/images/elasticsearch_1_5.png)

该索引的3个shard被复制到NODE2节点，因此在NODE2上有3个replica，至此集群状态为green（3个主分片和3个副本均正常）

D）在（C）的基础上再增加一个节点NODE3

![](/images/elasticsearch_1_6.png)

ES集群的shards和replica将会在集群中重新分配，以达到一个比较均衡的状态。

E）在（D）的基础上将replica数量从1调整到2

![](/images/elasticsearch_1_7.png)

F）在（E）的基础上干掉NODE1 master节点

![](/images/elasticsearch_1_8.png)

master节点宕掉之后，第一件事是剩余的节点重新选主出master节点，图中NODE2被选举为新的master节点。由于P1和P2两个主分片在NODE1被干掉时丢失了，所以新的master节点将重新从replica中恢复主分片，图中将NODE2和NODE3中replica确定为主分片。此时集群的状态为yellow，因为该所有需要2个replica，目前只有1个replica.

（2）shard的路由机制

在ElasticSearch中，一个索引可能有多个shard，一个文档只能被存储到一个shard中。因此在索引文档的时候，需要有一个机制来决定文档被索引到哪一个shard上。在ES中，通过公式shard = hash(routing) % number_of_primary_shards来计算文档应该被分配到哪个shard中。而且在读取ES中某个文档时，也是通过该公式计算出该文档存储在哪个shard中。因此在ES中，shard数在创建文档时指定，后来就无法改变，因为如果改变索引的shard数，那么已经被索引的数据将会失效或找不到。而replica数目则是可以随时调整的。

备注：公式中routing可以是文档的_id，也可以是用户自定义的值。

（3）在ES集群中，每一个节点都维护了一套完整集群元数据，所有每个节点都知道某个文档的存储节点，以及能够将请求转发给相应的节点，因此ES集群中每一个节点都能响应客户端的所有请求，而不管它是master节点，还是slave节点。

（4）ElasticSearch基本操作工作流

***场景一：创建或删除一个文档***

![](/images/elasticsearch_1_9.png)

A）NODE1收到用户发起的创建或删除文档请求

B）NODE1根据文档的_id计算（hash(routing) % number_of_primary_shards） 出该文档属于shard 0. 然后NODE1将请求转发给shard 0所在的节点NODE3

C）NODE3响应请求，完成P0的更新。然后将请求同时转发给给其副本所在的节点NODE1和NODE2。NODE1和NODE2更新完副本后，返回成功给主分片所在的节点NODE3。

D）NODE3返回成功给NODE1，NODE1返回成功给用户

备注：这个里面响应用户请求的是NODE1节点，其实这里其他的节点都可以直接响应用户的请求，请求工作流是类似的。

***场景二：读取一个文档***

![](/images/elasticsearch_1_10.png)

A）NODE1收到用户的读取文档请求

B）NODE1根据文档的_id计算`hash(routing) % number_of_primary_shards`出该文档属于shard 0. NODE1发现在所有的节点上都有shard 0或shard 0的副本。在这种情况下，NODE1会按照Round Robin模式妆发请求，在上图的例子中，是转发给了NODE2

C）NODE2返回文档数据给NODE1，然后NODE1将文档数据返回给用户

备注：这个里面响应用户请求的是NODE1节点，其实这里其他的节点都可以直接响应用户的请求，请求工作流是类似的。

***场景三：更新一个文档***

![](/images/elasticsearch_1_11.png)

A）NODE1收到用户的更新文档请求

B）NODE1计算出文档属于shard 0，并将请求转发给主分片shard 0所在的节点NODE3上。NODE3更新文档，并将请求转发给replica所在的NODE1和NODE2

C）NODE1和NODE2更新replica，并返回成功给NODE3。NODE3返回成功给NODE1，然后NODE1返回成功给用户

# ElasticSearch集群的自动发现机制

分布式系统要解决的首要问题就是节点之间互相发现以及选主的机制。如果使用了Zookeeper/Etcd这样的成熟的服务发现工具，这两个问题都一并解决了。但ElasticSearch并没有依赖这样的工具，带来的好处是部署服务的成本和复杂度降低了，不用预先依赖一个服务发现的集群，缺点当然是将复杂度带入了ElasticSearch内部。ElasticSearch Discovery模块就是负责集群中节点的自动发现和Master节点选举的模块，详细介绍如下：

（1）自动发现

目前ElasticSearch的自动发现机制有四种选择，ES默认支持的是zen Discovery，详细介绍如下：

A）zen discovery

它是ElasticSearch默认支持的，有单播和多播两种方式。

多播时需要如下配置：

	discovery.zen.ping.multicast.group: 224.2.2.4  #组地址 
	discovery.zen.ping.multicast.port: 54328       #端口 
	discovery.zen.ping.multicast.ttl: 3            #广播消息TTL
	discovery.zen.ping.multicast.address: null     #绑定的地址，null表示绑定所有可用的网络接口 
	discovery.zen.ping.multicast.enabled: true     #多播自动发现禁用开关

备注：在生产环境中，官方建议关闭多播模式，因为多播模式下，可能会有一些节点错误地加到ES集群中来

单播时需要如下配置：

	discovery.zen.ping.multicast.enabled: false        #多播自动发现禁用开关
	discovery.zen.ping.unicast.hosts: ["192.168.11.192","192.168.11.193","192.168.11.194"]  #unicast.hosts是集群中任意几个节点，而不用是所有ES中的所有节点。该节点会和unicast.hosts列表中机器进行通信，然后该节点和集群master节点通信，从而加入到集群中来

B）Azure classic discovery

它以插件的形式被ES支持，只有多播方式

C） EC2 discovery

它以插件的形式被ES支持，只有多播方式

D）Google Compute Engine(GCE) discovery

它以插件的形式被ES支持，只有多播方式

（2）Master节点选举

和master选举相关的几个参数有node.master，discovery.zen.minimum_master_nodes等

（3）故障检测

ElasticSearch中的故障检测有两个机制，一个是master节点定期去ping检测所有的slave节点；一个是slave节点定期去ping检测master节点是否存活。有如下三个相关的配置参数：

	discovery.zen.fd.ping_interval #多长时间ping一次，默认是1s
	discovery.zen.fd.ping_timeout  #ping的返回最大容忍时间，默认是30s，也就是说超过30s，ping还没有返回，就认为超时了
	discovery.zen.fd.ping_retries  #如果ping超时，最大的重试次数，默认为3，也就是说重试了3次，一个节点还是ping不通，那么就认为该节点挂掉了

# ElasticSearch中各种节点

（1）master-eligible node（候选主节点）

node.master为true，缺省即为true，意味着该节点可以被选举为master。

（2）master node（主节点）

（3）data node（数据节点）

node.data为true，缺省即为true，它负责存储数据，执行数据相关的CRUD、搜索、聚合操作。

（4）Ingest node（提取节点）

node.ingest为true，缺省即为true，它能够在索引之前预处理文档，拦截文档的bulk和index请求，施加转换，然后再将文档传回给 bulk和index API。用户可以定义一个管道，指定一系列的预处理器，有点类似于logstash了哦。

（5）Tribe node（部落节点）

通过tribe.*配置，是一种特殊类型的协调节点，它连接多个集群，接受同事对多个集群的查询和操作。
