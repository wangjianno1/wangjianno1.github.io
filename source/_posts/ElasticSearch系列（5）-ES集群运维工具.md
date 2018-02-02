---
title: ElasticSearch系列（5）_ES集群运维工具
date: 2018-02-02 11:49:42
tags: ElasticSearch
categories: ELKStack
---

# ElasticSearch集群管理工具

#### elasticsearch-kopf

elasticsearch-kopf是一个简单的ElasticSearch集群管理工具，使用JavaScript、AngularJS、jQuery以及Bootstrap编写。它是一个开源工具，不是官方ELK Stack中的组件。目前elasticsearch-kopf已经维护，由新的项目cerebro来代替。

elasticsearch-kopf Github：https://github.com/lmenezes/elasticsearch-kopf

#### cerebro

cerebro是一个ElasticSearch集群管理工具，其不仅实现了elasticsearch-kopf的功能，而且还新增了一些功能。cerebro使用Scala、Play Framework、AngularJS以及Bootstrap编写。cerebro需要JAVA 1.8版本以上的环境运行。

cerebro Github：https://github.com/lmenezes/cerebro

cerebro的安装非常简单，步骤如下：

（1）下载cerebro安装包，并解压

从https://github.com/lmenezes/cerebro/releases上下载cerebro的安装包，这里下载的是v0.6.5版本，用来管理ElasticSearch 5.3集群。

（2）配置文件

在${cerebro_HOME}/conf/application.conf中，可以配置要监控的集群，以及集群名。另外，还可以为cerebro平台配置登录账号密码。

（3）启动cerebro

执行`nohup ./bin/cerebro &`， 默认启动的端口是9000

（4）测试cerebro

使用浏览器打开http://hostname:9000，效果图如下：

![](/images/elasticsearch_5_1.png)

#### elasticsearch-head

elasticsearch-head是ElasticSearch的一个插件工具，用来管理ElasticSearch集群。

elasticsearch-head Github： https://github.com/mobz/elasticsearch-head

#### bigdesk

bigdesk插件是一个ElasticSearch的集群监控工具，可以通过它来查看集群的各种状态，如CPU、内存使用情况、索引数据、搜索情况、http连接数等。bigdesk的作者为lukas-vlcek，但是从Elasticsearch 1.4版本开始就不再更新了，也就是说最新的ES集群，bigdesk是不支持。不过，国内有用户fork出来继续维护到支持ES 5.0版本（https://github.com/hlstudio/bigdesk ），配置方法如下：

（1）到github下载项目文件

（2）修改ES集群的某一个节点的elasticsearch.yml文件，增加如下内容：

	http.cors.enabled: true
	http.cors.allow-origin: "*"

（3）启动webserver

```bash
cd bigdesk/_site && python -m SimpleHTTPServer   ## 默认开启了8000端口的web服务
```

（4）测试

打开浏览器输入http://host:8000，然后在页面上配置连接修改了cors的ES节点即可.

bigdesk原作品Github地址：https://github.com/lukas-vlcek/bigdesk（不支持最新的ES版本）

bigdesk GitHub：https://github.com/hlstudio/bigdesk（支持最新的ES版本，本例子中使用）

#### Marvel

Marvel是ElasticSearch的一个集群监控工具，集Head和Bigdesk有点于一身，但是Marvel插件不是免费的。Marvel是ElasticSearch官方开发的一个插件。

# ElasticSearch集群压测工具

esrally压测工具  https://github.com/elastic/rally

# 集群权限控制

searchguard
