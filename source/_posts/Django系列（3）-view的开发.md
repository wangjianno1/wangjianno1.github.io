---
title: Django系列（3）_view的开发
date: 2018-01-28 21:57:33
tags: Python WEB开发
categories: Django
---

在django应用中，view是url路由后，所执行的回调函数。在django的view形式有两种，一种是view函数，一种是基于class的view。

# 基础的view函数

view函数是编写在app_name/views.py中的普通函数，然后再url路由中关联到该view函数即可。举例来说：

名称为getDetailInfo的view函数如下：

```python
from django.http import Http404
from django.shortcuts import render
from polls.models import Poll
def getDetailInfo(request, poll_id):
    try:
        p = Poll.objects.get(pk=poll_id)
    except Poll.DoesNotExist:
        raise Http404("Poll does not exist")
    return render(request, 'polls/detail.html', {'poll': p})
```

url路由规则的设定如下：

```python
urlpatterns = [
    url(r'^detailinfo$', views.getDetailInfo, name='getdetailinfo'),
]
```

# 基于class的高级view

开发基于class的高级view的步骤如下：

（1）开发基于class的高级view类

```python
from django.http import HttpResponse
from django.views import View
class MyView(View):
    def get(self, request):
        #balabala
        return HttpResponse('http getmethod..')

    def post(self, request):
        #balabala
        return HttpResponse('http post method..')
```

备注：该view类继承django.views.View，当然也可以继承其他一些类，如django.views.generic.ListView。

（2）url路由绑定到view类

django的路由配置，是通过url映射到回调函数上，而不是类。但是基于class的View类提供了一个as_view()函数，as_view()会创建一个view实例并调用实例的dispatch()方法，然后由dispatch()将请求映射到具体的post或get等方法上。

举例来说：

```python
urlpatterns = [
    url(r'^about/$', MyView.as_view(greeting="HelloWorld!!!")),
]
```


学习资料参考于：
https://docs.djangoproject.com/en/1.11/topics/class-based-views/
