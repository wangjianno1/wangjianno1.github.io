---
title: Linux中curl命令的使用
date: 2019-02-01 12:22:24
tags:
categories: Linux
---

# curl简介

简单来说，curl是一个用url方式，来和服务器进行文件传输和下载的工具。它不仅仅支持HTTP协议，还支持了其他的众多的协议，例如`DICT/FILE/FTP/FTPS/Gopher/HTTP/HTTPS/IMAP/IMAPS/LDAP/LDAPS/POP3/POP3S/RTMP`等。

# curl工具格式和选项

格式：

```
curl [options] [URL...]
```

重要选项：

```bash
-X method, --request method      #指定使用http的method，有GET/POST/PUT/DELETE等等，默认是GET方法
-d key=value, --data key=value   #指定HTTP请求中请求数据段，例如HTTP POST请求时需要传递给服务器的数据，一个curl命令中，可以用多个-d选项，curl会将他们合并成key1=value1&key2=value2…
--data-urlencode key=value       #类似于-d key=value，但是会经过URL编码
-F key=value, --form key=value   #模拟向服务器提交表单form数据，curl会用multipart/form-data的格式传递给服务器，而-d选项使用的是application/x-www-form-urlencoded，一个curl命令中，同样可以有多个-F选项
-e url, --referer url            #在curl发起的http请求的请求头中，设置referer信息，向目标请求站点说明本次的http请求是来自那个http页面
-H <header>, --header <header>   #为http请求设置请求头信息，例如，--header "Content-Type:application/json" -H Host:www.baididu.com
-A <agent string>, --user-agent<agent string>   #为http请求设置user-agent信息，这个字段是用来表示客户端的设备信息。服务器有时会根据这个字段，针对不同设备，返回不同格式的网页
-u <user:password;options>, --user<user:password;options>   #为http请求设置用户名和密码
-o filename           #将curl返回的请求结果，写入到filename文件中
-b <name=data>, --cookie<name=data>, -b <cookie-file>, --cookie <cookie-file>  #为curl的http请求携带cookies信息，可以在命令行用key=value设置，也可以从一个文件中读取
-c <cookie-file>, --cookie-jar <cookie-file>      #将服务器返回的cookie信息写入到本地文件中
-v, --verbose         #显示curl的http请求的通信过程，直接打印到终端上
--trace <file>        #将curl的http请求通信过程写入到文件中
--trace-ascii <file>  #同--trace <file>类似，将curl的http请求通信过程写入到文件中
-I          #只输出HTTP响应报文的头部
-i          #输出HTTP响应报文的头部以及响应正文
-s          #让curl开启静默模式，即不输出进度或错误等信息
-L          #如果服务端返回3XX重定向，curl会继续向新地址发送请求
-k          #curl对于服务器发过来的任何证书不做校验，都认为是安全的
-x ip:port  #设置http请求的代理服务器，若端口不指定，默认为1080
-w <format> #输出curl过程中特定的对象值，如状态码http_code，总耗时time_total等
```

# curl使用的例子

```bash
curl http://www.example.com
curl -o sina.output http://www.example.com
curl -s -o /dev/null http://www.example.com
curl -v http://www.example.com
curl --trace output.txt http://www.example.com
curl http://example.com/form.cgi?data=xxx
curl -X POST --data "data=xxx" http://example.com/form.cgi
curl -X POST --data-urlencode "date=April 1" http://example.com/form.cgi
curl --referer http://www.example.com http://www.example1.com
curl --form upload=@localfilename --form press=OK http://www.example.com  #利用curl上传文件
curl --cookie "name=xxx" www.example.com
curl --header "Content-Type:application/json" http://example.com
curl -X PUT -H "Accept: application/json" http://example.com/v1/user/add --basic -u user:passwd \
     -F proto_file=@task.proto                                          \
     -F message_name="adduser"                                          \
     -F host=hostname                                                   \
     -F part_count=4                                                    \
     -F replication=5                                                   \
     -F part_rule=MOD                                                   \
     -F cpu_num=20                                                      \
     -F mem_mb=10000                                                    \
     -F disk_mb=10000                                                   \
     -F token_pattern="token"                                           \

curl -I -H "Host:www.example.com" http://10.16.34.23/
curl https://www.example.com -x 10.16.34.23:443
curl -k "https://www.example.com"
curl -s "http://www.sohu.com" -w 'httpcode:%{http_code};timetotal:%{time_total}' -o /dev/null
```

备注：狭义地说，curl像是一个浏览器，但是比浏览器的支持的东西要多，因为它不仅支持HTTP协议，还支持其他很多的协议。

# 关于使用curl命令的-d参数携带HTTP request的请求体request body一些问题

HTTP Requset请求头中的`Content-Type`是用来说明请求体的MIME类型的，默认是`application/x-www-form-urlencoded`类型。`curl -d`参数是用携带`POST/PUT`请求的请求体内容的，有如下几种支持的格式：

（1）第一种

```bash
curl -d "param1=value1&param2=value2" -X POST http://localhost:3000/data
```

备注：`Content-Type`缺省为`application/x-www-form-urlencoded`，所以使用`param1=value1&param2=value2`格式时，可省略。

（2）第二种

```bash
curl -d "param1=value1&param2=value2" -H "Content-Type: application/x-www-form-urlencoded" -X POST http://localhost:3000/data
```

备注：使用`param1=value1&param2=value2`格式时，也可以显式地指出`application/x-www-form-urlencoded`。

（3）第三种

```bash
curl -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST http://localhost:3000/data
```

备注：使用json格式的数据，一定要显式地指明`Content-Type`为`application/json`。

（4）第四种

```bash
curl -d "@data.txt" -X POST http://localhost:3000/data
```

备注：将`param1=value1&param2=value2`格式的数据单独放入文件，然后通过`-d "@filename"`来引入。

（5）第五种

```bash
curl -d "@data.json" -H "Content-Type: application/json" -X POST http://localhost:3000/data
```

备注：将json格式的数据单独放入文件，然后通过`-d "@filename"`来引入。

学习资料参考于：
https://gist.github.com/subfuzion/08c5d85437d5d4f00e58
http://www.ruanyifeng.com/blog/2011/09/curl.html
