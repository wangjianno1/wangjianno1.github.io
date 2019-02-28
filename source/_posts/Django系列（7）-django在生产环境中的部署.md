---
title: Django系列（7）_django在生产环境中的部署
date: 2018-01-28 22:52:52
tags: Python WEB开发
categories: Django
---

# 直接启动django应用

执行命令`python manage.py runserver 192.168.65.239:8082`即可启动django应用。然而这种方式启动的django应用，一般是我们在开发django应用时候的启动方式，便于调试。在实际的生产环境中，我们一般不这样启动django应用哦。

备注：我们可以在django应用的前面，部署一个nginx作为反向代理，将请求转发给django应用，这种方式也能分布式部署django应用。但我们一般也不这样在生产环境中部署哦。

# 使用uWSGI服务器部署django应用

原理图如下，

![uWSGI原理图](/images/django_7_1.png)

使用uWSGI服务器部署django应用，步骤如下：

（1）安装uWSGI服务器

执行命令`pip install uwsgi`即可。

（2）编写uwsgi.ini文件

内容形式如下：

```
[uwsgi]
chdir=/home/scslogsys
module=scslogsys.wsgi:application
#启动一个socket端口
socket=192.168.65.239:8011
#启动一个http端口
#http=192.168.65.239:8011
master=True
pidfile=/tmp/project-master.pid
vacuum=True
max-requests=5000
daemonize=/var/log/uwsgi/scslogsys.log
```

备注：http和socket这两个任选一个就可以了。如果选择http，则uWSGI服务器启动后，可以直接对外提供http服务。如果选择socket，则uWSGI服务器启动后，是不能对外提供http服务的，这是需要nginx将请求转发过来后，才可以处理哦。

（3）启动uWSGI服务器

执行`uwsgi --ini uwsgi.ini`命令即可。其中uwsgi.ini文件是步骤（2）中编写的配置。

（4）安装并配置nginx

```
upstream scslogsys_backend_group
{
    keepalive 16;
    server 192.168.65.239:8011;
}
server {
    listen       8012;
    server_name  192.168.65.239;
    location / {
         include uwsgi_params;
         uwsgi_pass scslogsys_backend_group;
    }
}
```

（5）访问测试

直接访问`http://192.168.65.239:8012`即可。注意`http://192.168.65.239:8011`是访问不了的哦，除非uwsgi.ini配置的http即可。

# 使用apache+mod_wsgi+django部署django应用

待研究
