---
title: Python网页爬虫（requests | BeautifulSoup）学习
date: 2018-02-02 18:01:26
tags: Python实践
categories: Python
---

# 网页抓取器

（1）python官方支持库

python原生的http库，如urllib，urllib2，urllib3等。需要注意的是，urllib和urllib2是相互独立的模块，不是升级版的意思。如下为urllib/urllib2的简单使用示例：

```Python
urllib.urlencode({'param1': 'hello', 'param2': 'world'})
response = urllib2.urlopen(url)
```

（2）第三方库requests

requests是非常好用的第三方http请求库，其API设计的比较简单易用，建议后面就使用requests库就好了。如下为requests库的简单使用示例：

```Python
response = requests.get()/requests.post()/requests.delete()...
response.headers   #获取响应头
response.text      #获取响应内容的文本格式
response.content   #获取响应内容的二进制形式，若要获取图片、音乐之类的元素，需要使用response.content哦
response.json      #直接获取json格式的响应内容
response.status_ok #获取响应状态码
response.reason    #获取响应请求状态码的含义
```

# 网页解析器

网页解析有如下几种解决方案：

（1）字符串处理-正则匹配

（2）python官方自带库html.parser

（3）第三方网页解析库BeautifulSoup

（4）第三方网页解析库lxml


学习资料参考于：
http://docs.python-requests.org/zh_CN/latest/user/quickstart.html
https://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html
