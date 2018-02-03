---
title: 使用GPG工具来了解加密解密以及签名认证过程
date: 2018-02-03 17:50:43
tags:
categories: Security
---

# gpg简介

1991年，程序员Phil Zimmermann为了避开政府监视，开发了加密软件PGP。这个软件非常好用，迅速流传开来，成了许多程序员的必备工具。但是，它是商业软件，不能自由使用。所以，自由软件基金会决定，开发一个PGP的替代品，取名为GnuPG。这就是GPG的由来。

# gpg的安装

使用源码或rpm包的方式安装即可。

# gpg工具的使用

（1）使用gpg工具生成秘钥对

执行命令`gpg --gen-key`然后按照屏幕的提示来输入交互信息即可，主要有如下的一些确认信息：

![](/images/gpg_1_1.png)

之后还需要为秘钥设置密码，即passphrase，用来保护私钥的安全，避免私钥泄露后的安全问题。

最终生成成功界面如下：

![](/images/gpg_1_2.png)

（2）关于生成的秘钥的一些常用操作

```bash
gpg --list-keys             #列出系统中已有的密钥对
gpg --delete-key [用户ID]   #删除某个密钥对
gpg --armor --output public-key.txt --export [用户ID]      #公钥文件（.gnupg/pubring.gpg）以二进制形式储存，armor参数可以将其转换为ASCII码显示
gpg --armor --output private-key.txt --export-secret-keys  #将私钥文件转换成文本格式的
gpg --send-keys [用户ID] --keyserver hkp://subkeys.pgp.net  #钥服务器是网络上专门储存用户公钥的服务器。send-keys参数可以将公钥上传到服务器
gpg --fingerprint [用户ID]  #为公钥生成指纹fingerprint，当用户拿到公钥后，可以check下指纹是否正确
gpg --import [密钥文件]     #作为用户端，导入其他的公钥到本系统中
```

备注：我们可以使用--export参数导出公钥，然后给用户使用即可

（3）加密和解密操作

A）加密

```bash
gpg --recipient [用户ID] --output demo.en.txt --encrypt demo.txt
```

recipient参数指定公钥，output参数指定加密后的文件名，encrypt参数指明加密。运行上面的命令后，demo.en.txt就是已加密的文件，可以把它发给对方。

B）解密

```bash
gpg --decrypt demo.en.txt --output demo.de.txt
```

decrypt参数指定需要解密，output参数指定解密后生成的文件。运行上面的命令，demo.de.txt就是解密后的文件。

（4）签名和认证操作

A）签名

```bash
gpg --sign demo.txt
```

运行上面的命令后，当前目录下生成demo.txt.gpg文件，这就是签名后的文件。demo.txt.gpg默认采用二进制储存。

```bash
gpg --clearsign demo.txt
```

同上，只是生成的签名文件是ASCII文本格式的。

```bash
gpg --detach-sign demo.txt
```

在当前目录下生成一个单独的签名文件demo.txt.sig，达到签名文件与文件内容分开存放的效果。

```bash
gpg --armor --detach-sign demo.txt
```

同上，只是生成的签名文件是ASCII文本格式的。

B）认证

```bash
gpg --verify demo.txt.asc demo.txt
```

收到别人签名后的文件，需要用对方的公钥验证签名是否为真。verify参数用来验证。


学习资料参考于：
http://www.ruanyifeng.com/blog/2013/07/gpg.html
