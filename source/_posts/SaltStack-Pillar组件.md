---
title: SaltStack Pillar组件
date: 2019-03-04 23:50:14
tags:
categories: SaltStack
---

# Pillar组件简介

Pillar也是Key/Value，但是Pillar数据是动态的，和salt-minion启不启动没关系，它给特定的salt-minion指定特定的数据，只有指定的salt-minion才能看到自己的数据。

# SaltStack Pillar的使用

（1）在salt-master上开启Pillar及配置pillar_roots

在/etc/salt/master中配置pillar_roots，如下：

```
pillar_roots:
  base:
    - /srv/pillar
pillar_opts: True
```

（2）创建一个Pillar的sls，名称为/srv/pillar/web/apache.sls

文件内容如下：

```
{% if grains['os'] == 'CentOS' %}
apache: httpd
{% elif grains['os'] == 'Debian' %}
apache: apache2
{% endif %}
```

（3）配置Pillar的top file，名称为/srv/pillar/top.sls

编辑top file（Pillar必须要写top file，不像SaltStack State不写top file也可以），文件内容如下：

```
base:
  'linux-node2*':
    - web.apache
```

（4）刷新Pillar并测试获取pillar item

```bash
salt '*' saltutil.refresh_pillar
salt '*' pillar.items apache
```

![](/images/saltstack_1_4.png)

# Grains VS. Pillar

![](/images/saltstack_1_5.png)
