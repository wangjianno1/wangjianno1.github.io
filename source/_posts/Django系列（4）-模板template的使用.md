---
title: Django系列（4）_模板template的使用
date: 2018-01-28 22:25:50
tags: Python WEB开发
categories: Django
---

# django中模板引擎简介

目前django支持的模板引擎有：

（1）Django Template engine，是django自带的模板引擎

（2）jinja2

（3）其他第三方的模板引擎

# django中模板template的使用方法

（1）模板template的配置

在myproject/settings.py中，配置TEMPLATES变量，格式和内容如下：

```python
TEMPLATES = [
    {   
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```

备注：

	BACKEND：配置django使用哪种模板引擎，目前支持django.template.backends.django.DjangoTemplates和django.template.backends.jinja2.Jinja2两种
	DIRS：配置django在哪些目录中查找模板，查找顺序和DIRS元组的元素顺序一致
	APP_DIRS：引擎是否在已安装APP（的目录）内查找模板源文件。配置为true或false
	OPTIONS：传递给该模板引擎（backend）的其他参数。不同的引擎，可用的参数不一样

（2）编写模板文件

如果我们使用django自带的模板引擎，我们可以使用django模板引擎的DTL语言来编写模板文件。模板文件的内容形式如下：

```
{% if latest_question_list %}
    <ul>
    {% for question in latest_question_list %}
        <li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
    {% endfor %}
    </ul>
{% else %}
    <p>No polls are available.</p>
{% endif %}
```

（3）模板渲染并返回响应对象

模板渲染有两种方式：

A）普通常规方式

```python
from django.http import HttpResponse
from django.template import loader
from .models import Question

def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    template = loader.get_template('polls/index.html')
    context = {
        'latest_question_list': latest_question_list,
    }
    return HttpResponse(template.render(context, request))
```

备注：使用loader加载模板引擎，然后向模板填充数据，最终返回一个HttpResponse对象给客户端。

B）简单快捷方式

```python
from django.shortcuts import render
from .models import Question

def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    context = {'latest_question_list': latest_question_list}
    return render(request, 'polls/index.html', context)
```

备注：直接使用django.shortcuts.render函数即可。


学习资料参考于：
https://docs.djangoproject.com/en/1.11/topics/templates/
