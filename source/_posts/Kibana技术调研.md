---
title: Kibana技术调研
date: 2018-02-02 11:59:57
tags: Kibana
categories: ELKStack
---

# Kibana简介

Kibana自带Node.js Web服务器，无需额外代码或额外基础设施。

# Kibana的查询

在Discover页提交一个搜索，你就可以搜索匹配当前索引模式的索引数据了。可以有两种查询方式：

（1）直接输入简单的请求字符串，也就是用 Lucene query syntax

（2）用完整的基于JSON的Elasticsearch Query DSL

# Kibana的配置和安装

前提声明：本次部署测试使用的是kibana-5.3.0

（1）在官网上下载二进制部署包，并解压缩

（2）配置Kibana

在${KIBANA_HOME}/config/kibana.yml中修改配置，主要配置Kibana要连接的ES集群。Kibana的配置比较简单，参考配置的说明文字修改即可。

（3）启动Kibana

```bash
nohup ./bin/kibana &
```

（4）测试Kibana

使用浏览器打开http://hostname:5601

# Kibana的常见配置

（1）elasticsearch.requestTimeout

设置kibana请求ES的超时时间，超过这个值后kibana直接向用户返回查询超时。默认为30s.

# Kibana搜索实践

Kibana的搜索框中支持如下格式的搜索语句

（1）全文搜索

直接输入关键字：如upstreams或no live upstreams，但是如果有多个关键字，那么会被切词。

（2）多关键字搜索

例如，no AND live AND upstreams，这样只有同时包含no、live以及upstreams的关键字的文档才会被搜索到。

（3）按字段查找

例如server:mp.i.sohu.com，表示只匹配server字段为mp.i.sohu.com的文档。

（4）其他的复合查询

type:http AND http.code:302

更多Kibana搜索用法参见https://segmentfault.com/a/1190000002972420
