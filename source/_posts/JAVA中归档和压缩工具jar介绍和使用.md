---
title: JAVA中归档和压缩工具jar介绍和使用
date: 2018-12-07 18:31:53
tags: JAVA基础
categories: JAVA
---

# jar工具及JAR文件

jar是随JDK安装的，是JDK中自带的一个工具，在 JDK安装目录下的bin目录中，Windows下文件名为jar.exe，Linux下文件名jar。jar是一个归档和压缩工具，jar工具是基于zip和zlib创建出来的。使用jar工具打包压缩出来的文件称为JAR文件，即Java Archive File。顾名思义，它的应用是与Java息息相关的，是Java的一种文档格式。JAR文件非常类似ZIP文件，准确地说，它就是ZIP文件。JAR文件与ZIP文件唯一的区别就是在JAR文件的内容中，包含了一个META-INF目录，且该目录下有一个名称为MANIFEST.MF的文件，这个目录和文件是在使用jar工具生成JAR文件时自动创建的。

JAR文件包的扩展名是`.jar`，在Windows平台上，我们直接可以将JAR文件的扩展名改成.zip，然后使用WinRAR工具打开。

# JAR文件的目录结构

假设有一个简单的JAR文件，它的基本目录结构如下：

![](/images/java_jar_1_1.png)

备注：com.bat.adsl是包结构。

# jar命令格式及参数

jar命令的使用格式如下：

```
jar {ctxu} [vfm0M] [jar-filename] [manifest-filename] [-C 目录] 文件名 ...
```

jar命令各个选项和参数说明如下：

```
c  #创建新的JAR文件包
v  #生成详细报告并打印到标准输出，即输出压缩和解压的详细过程信息
f  #指定JAR文件名，通常这个参数是必须的
m  #指定需要包含的MANIFEST清单文件
t　#列出JAR文件包的内容列表
x　#展开JAR文件包的指定文件或者所有文件
u　#更新已存在的JAR文件包（添加文件到JAR文件包中）
M  #不产生所有项的清单（MANIFEST）文件，此参数会忽略-m参数
[jar-filename]      #表示需要生成、查看、更新或者解压的JAR文件包，它是f参数的附属参数
[manifest-filename] #即MANIFEST清单文件，它是m参数的附属参数
[-C 目录]   #表示需要转到指定目录下去执行这个jar命令的操作，它相当于先使用cd命令转该目录下再执行不带[-C 目录]参数的jar命令，它只能在创建和更新JAR文件包的时候可用
文件名 ...  #指定一个文件/目录列表，这些文件/目录就是要添加到JAR文件包中的文件/目录。如果指定了目录，那么jar命令打包的时候会自动把该目录中的所有文件和子目录打入包中
```

# jar命令使用举例

（1）`jar cf test.jar test`

该命令没有执行过程的显示，执行结果是在当前目录生成了test.jar文件。

（2）`jar cvf test.jar test`

该命令与上例中的结果相同，但是由于v参数的作用，显示出了打包过程。

（3）`jar cvfM test.jar test`

该命令与（2）结果类似，但在生成的test.jar中没有包含META-INF/MANIFEST文件。

（4）`jar cvfm test.jar manifest.mf test`

运行结果与（2）相似，显示信息也相同，只是生成JAR包中的META-INF/MANIFEST是我们指定的manifest.mf文件的内容，而不是jar工具默认生成的META-INF/MANIFEST文件内容。

（5）`jar tf test.jar`或`jar tvf test.jar`

在test.jar已经存在的情况下，可以查看test.jar中的内容，但并不会解压test.jar包文件哦。

（6）`jar xf test.jar`或`jar xvf test.jar`

解压缩test.jar归档文件到当前目录。

# 使用jar工具创建可执行jar文件

（1）编写java代码，并使用javac编译

（2）创建MANIFEST.MF文件

这个MANIFEST.MF文件可以放在任何位置，也可以是其它任意文件名，但要创建可执行JAR包，MANIFEST.MF文件必须要有`Main-Class: test.Test`一行，且该行以一个回车符结束即可。Main-Class这一行指明了JAR包的执行入口，即包含了`public static void main(String[] args)`方法的类。

（3）执行打包命令`jar cvfm test.jar manifest.mf test`

（4）执行`java -jar test.jar`命令来执行可执行jar文件

# 一个典型MANIFEST.MF

MANIFEST.MF文件是JAR归档文件的清单文件，默认情况下，JAR文件中都包含了该文件，除非在生成JAR文件特别执行不需要MANIFEST.MF文件。

一个典型的MANIFEST.MF的文件内容如下：

```
Manifest-Version: 1.0
Created-By: 1.8.0 (IBM Corporation)
Main-Class: com.bat.adsl.Test
```

一个稍复杂的可执行的SpringBoot JAR应用的MANIFEST.MF的文件内容如下：

```
Manifest-Version: 1.0
Implementation-Title: adsl
Implementation-Version: 0.0.1-SNAPSHOT
Archiver-Version: Plexus Archiver
Built-By: wangjianno1
Implementation-Vendor-Id: com.bat
Spring-Boot-Version: 1.5.2.RELEASE
Implementation-Vendor: Pivotal Software, Inc.
Main-Class: org.springframework.boot.loader.JarLauncher
Start-Class: com.bat.adsl.ADSLStart
Spring-Boot-Classes: BOOT-INF/classes/
Spring-Boot-Lib: BOOT-INF/lib/
Created-By: Apache Maven 3.3.9
Build-Jdk: 1.8.0_101
Implementation-URL: http://maven.apache.org
```

# 其他闲杂知识

（1）我们可以使用Eclipse IDE来生成jar文件，当然也可以使用Maven工具来生成jar文件。

学习资料参考于：
https://blog.csdn.net/xlgen157387/article/details/23126933
