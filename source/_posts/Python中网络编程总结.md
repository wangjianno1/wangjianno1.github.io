---
title: Python中网络编程总结
date: 2019-02-24 02:44:59
tags:
categories: Python
---

# 使用socket模块网络编程

使用Python socktet模块来进行网络编程，范例如下：

（1）服务端demo

```python
#!/usr/bin/python
import socket

s = socket.socket()      #创建socket对象
host = socket.gethostname()
port = 1234
s.bind((host, port))     #socket绑定host和port
s.listen(5)              #配置监听
while True:
    c, addr = s.accept() #接收client端的连接，是阻塞方法
    print "Got connection from", addr
    c.send("Thank you for connecting, aha!") #向socket发送信息
    c.close()
```

（2）客户端demo

```python
#!/usr/bin/python
import socket

s = socket.socket()     #创建socket对象
host = "test-host-01"   #假设server端程序是运行在test-host-1主机上
port = 1234
s.connect((host, port)) #连接server端
print s.recv(1024)      #从网络套接字中接收内容
```

# 使用urllib和urllib2模块来抓取远程web上内容到本地

# 使用SocketServer模块来编写网络程序

# 使用Twisted网络编程框架来进行网络编程

# 其他很多模块也可以进行网络编程

    asynchat
    asyncore
    cgi
    Cookie
    email
    ftplib
    telnetlib
    ......
