---
title: Django系列（5）_对MySQL数据库的配置和使用
date: 2018-01-28 22:33:48
tags: Python WEB开发
categories: Django
---

# Django项目中MySQL数据库的安装与配置

（1）安装MySQL数据库

此处略过。

（2）安装Python包MySQLdb

执行`pip install mysql-python`命令即可。

若是安装过程有问题，可安装下述软件包，然后再行安装MySQLdb

```bash
yum install python-setuptools
yum install libmysqld-dev
yum install libmysqlclient-dev
yum install python-dev
```

进入Python交互式命令行，输入`import MySQLdb`检测是否安装成功。

（3）在django工程中的settings.py中配置数据库

在settings.py文件中修改DATABASES字段如下：

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'xblog',         #数据库名称
        'USER': 'root',
        'PASSWORD': 'password',  #安装mysql数据库时，输入的root用户的密码
        'HOST': '127.0.0.1',
    }   
}
```

至此，MySQL数据库的配置基本上是已经配置好了。

# Django项目中对MySQL数据库进行初始化

（1）使用create database命令创建数据库

（2）在app中编写model

每一个model都是一个Python类，且继承自django.db.models.Model类，模型与数据库息息相关，一个模型对应一个数据库表（在设计model时，可想象成是在设计相应的数据库表）。model中每一个属性对应数据库表中的一个字段。在自定义app的目录中有models.py，我们可以将我们的model都编写到这个文件中，如下为一个model的范例：

```python
from django.db import models

class Article(models.Model):
    url = models.URLField()    
    title = models.CharField(max_length=50)
    title_zh = models.CharField(max_length=50)
    author = models.CharField(max_length=30)
    content_md = models.TextField()
    content_html = models.TextField()
    tags = models.CharField(max_length=30)
    views = models.IntegerField()
    created = models.DateTimeField()
    updated = models.DateTimeField()
```

（3）生成数据库表

执行`python manage.py makemigrations app_name`命令（app_name可不写，表示对project下所有app有效），该命令会在app的migrations目录中生成一些Python文件，是用来和数据库交互的一些接口等。然后再执行命令`python manage.py migrate`就可以在DB中生成数据表了，这个命令才会真正地去操作数据库。当我们在models.py中增加或修改model等，都需要执行上面两个命令，才能在数据库中生效。

备注：执行`python manage.py migrate`命令后，django会自动生成数据库表名，生成的规则为“appname_modelname”,我们可以通过在model类中嵌入class Meta来修改。

# Django项目中常见增删改查操作

前提申明，我们在models.py定义了Student的model如下：

```python
class Student():
        name = models.CharFiled(max_length = 30)
        age = models.IntegerFiled()
```

现在详细的增删改查的方法如下所示：

（1）增加操作

法一：

```python
stu1 = Student(name="Aaron", age=23)
stu1.save()
```

法二：

```python
Student.objects.create(name="Aaron", age=23)
```

（2）删除操作

```python
Student.objects.all().delete()               #删除表中所有数据
Student.objects.get(name='Aaron').delete()   #删除name等于Aaron的数据
Student.objects.filter(age=20).delete()      #删除age等于20的多条数据
```

（3）修改操作

法一：

```python
stu = Student.objects.get(name='Aaron')
stu.name = 'Zhang'
stu.save()
```

法二（更新多个字段）：

```python
Student.objects.get(name='Aaron').update(name='Zhang', age=20)
```

法三（更新所有字段）：

```python
Student.objects.all().update(name='Zhang')
```

（4）查询操作

```python
Student.objects.all()                           #查表中所有记录
Student.objects.all().values()                  #查询带字段名的所有记录，就是将所有记录以key-value的形式保存在字典中
Student.objects.get(name='Aaron')               #查询单条记录，查询name字段是Aaron的这条数据，如果返回多条记录或查询结果为空，都会报异常，需结合try/except一起使用
Student.objects.filter(name='Aaron')            #查询匹配条件的多条数据，查询name字段值为Aaron的所有匹配数据，括号中匹配条件可多个，以逗号分隔。注意filter与上面get方法的区别
Student.objects.filter(name__contains="A")      #模糊查询，查询name字段中值包含A的记录
Student.objects.order_by('age')                 #将字段内容排序后显示，根据Aaron字段的内容进行排序后输出结果
Student.objects.order_by('-age')                #将字段内容逆序后显示，只需要加一个-号就可以达到逆序输出的效果
Student.objects.filter(age=20).order_by("-age") #多重查询，比如过滤后逆序输出
Student.objects.filter(age=20)[0]               #限制数据条数，[0]取第一条记录，[0:2]取前两条记录，切片不支持负数，可以使用上面先逆序排列后再输出达到这个效果
```

# 使用django工具管理数据库

migration，翻为“迁移”，django会将每一次模型的model的变更记录到migration文件中。简单来说，在appname/migrations目录下有很多migration文件，我们可以理解每一个文件都对应了对数据的一次变更操作，而且我们就可以通过sqlmigrate工具将migration文件转换成原始的SQL语句。在Django中，关于数据库的操作有如下一些常用的命令：

（1）`python manage.py makemigrations`

根据models.py中的定义的模型，生成appname/migrations下的Python文件。若是对某个model的局部进行修改，执行完makemigrations后，会生成一个新的Python文件，该Python文件只对应这个局部修改。所以当我们每次在修改model.py时，执行makemigrations命令，都会在appname/migrations下生成一些Python文件。

appname/migrations目录下的migration文件一般为0001_xxx.py,0002_xxx.py,0003_xxx.py....等，可以理解为每一次修改model，都会对应一个migration文件。

备注：`python manage.py makemigrations`后可以紧接着appname，表示只对指定app的model的变更来生成相应的migrations文件。

（2）将makemigrations生成的migration文件，应用到数据库上

```bash
python manage.py migrate
```

（3）清空数据库中表的内容，但表不会删除

```bash
python manage.py flush
```

（4）查看django项目中所有的app的migration文件

```bash
python manage.py showmigrations
```

（5）查看指定的migration文件对应的原始SQL语句

```bash
python manage.py sqlmigrate appname migrationname
```

举例来说，`python manage.py sqlmigrate appname 0002_auto_20171026_1045`表示查看名称为appname的APP的0002_auto_20171026_1045.py文件对应的原始SQL语句。

学习资料参考于：
http://blog.csdn.net/ZCF1002797280/article/details/49559863
