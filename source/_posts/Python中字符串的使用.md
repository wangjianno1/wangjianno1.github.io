---
title: Python中字符串的使用
date: 2019-02-22 14:29:01
tags:
categories: Python
---

# 字符串的定义

```python
if __name__ == "__main__":
    var1 = 'this world is beautiful!!'
    var2 = "this world is beautiful!!"
    var3 = 'this "world" is beautiful!!'
    var4 = "this 'world' is beautiful!!"
    var5 = '''this 
world 
is 
beautiful!!'''
    var6 = """this 
world 
is 
beautiful!!"""
    var7 = '''this 
"world" 
is 
beautiful!!'''
    var8 = """this 
'world' 
is 
beautiful!!"""
    var9 = 'this \"world\" is beautiful!!'
    var10 = "this \'world\' is beautiful!!"
    var11 = "this \"world\" is beautiful!!"
    var12 = 'this \'world\' is beautiful!!'
    var13 = "this world " "is beautiful!!"
    var14 = 'this world ' 'is beautiful!!'
    var15 = ("this world " 
             "is beautiful!!")
    var16 = 'this world '\
            'is beautiful!!'
    print "var1 : " + var1
    print '*'*40
    print "var2 : " + var2
    print '*'*40
    print "var3 : " + var3
    print '*'*40
    print "var4 : " + var4
    print '*'*40
    print "var5 : " + var5
    print '*'*40
    print "var6 : " + var6
    print '*'*40
    print "var7 : " + var7
    print '*'*40
    print "var8 : " + var8
    print '*'*40
    print "var9 : " + var9
    print '*'*40
    print "var10 : " + var10
    print '*'*40
    print "var11 : " + var11
    print '*'*40
    print "var12 : " + var12
    print '*'*40
    print "var13 : " + var13
    print '*'*40
    print "var14 : " + var14
    print '*'*40
    print "var15 : " + var15
    print '*'*40
    print "var16 : " + var16
    print '*'*40
```

输出内容为：

```text
var1 : this world is beautiful!!
****************************************
var2 : this world is beautiful!!
****************************************
var3 : this "world" is beautiful!!
****************************************
var4 : this 'world' is beautiful!!
****************************************
var5 : this 
world 
is 
beautiful!!
****************************************
var6 : this 
world 
is 
beautiful!!
****************************************
var7 : this 
"world" 
is 
beautiful!!
****************************************
var8 : this 
'world' 
is 
beautiful!!
****************************************
var9 : this "world" is beautiful!!
****************************************
var10 : this 'world' is beautiful!!
****************************************
var11 : this "world" is beautiful!!
****************************************
var12 : this 'world' is beautiful!!
****************************************
var13 : this world is beautiful!!
****************************************
var14 : this world is beautiful!!
****************************************
var15 : this world is beautiful!!
****************************************
var16 : this world is beautiful!!
****************************************
```

备注：

（1）单双引号都可以用来定义字符串

（2）当字符串串中包括单引号时，则使用双引号来定义。反之亦成立。当然这种情况可以使用转义字符

（3）对于多行的字符串，可以使用三重单引号或者三种双引号来定义。

# Python字符串定义中的u和r

（1）指定中文编码为unicode

举例来说，`text = u"你好"`，这对解决Python中中文乱码问题很有用哦。

（2）指定字符串为raw string

举例来说，`text = r"\tHello World!!!"`，r指明该字符串为raw string，即字符串中有特殊字符，也当做普通字符来看。在本例中\t就是一个转义字符，但是加上r后，它就是两个普通字符。

# 格式化字符串

（1）用%格式化字符串

其中%前面为字符串模板，%后面为元组，用于替换前面的格式占位符。

```python
str1 = "%saaaaaaaaaaa%s" % ("start", "end")
print str1
```

（2）使用str.format()格式化字符串

```python
madlib1 = "I {verb} the {object} off the {place}".format(verb="took", object="cheese", place="table")
madlib2 = "I {} the {} off the {}".format("took", "cheese", "table")
```


学习资料参考于：
http://blog.xiayf.cn/2013/01/26/python-string-format/
