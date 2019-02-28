---
title: Django系列（9）_django中一些好用的特性及闲杂知识
date: 2018-01-28 23:00:50
tags: Python WEB开发
categories: Django
---

# 限定HTTP请求的Method

在view函数上加上如下的装饰器，就可以限制指定的HTTP请求的Method类型：

```python
@require_http_methods(["GET", "POST"])
@require_GET()
@require_POST()
```

# django Shell

```bash
python manage.py shell
```

# django api框架设计

django-rest-framework

# django中日志配置

在全局的settings.py中配置LOGGING变量。

# django项目目录布局的最佳实践

参见[《Django项目布局最佳实践》](http://blog.tmackan.com/2016/09/12/2016-09-12/)
