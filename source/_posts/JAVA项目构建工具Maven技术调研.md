---
title: JAVA项目构建工具Maven技术调研
date: 2018-02-05 16:12:23
tags: JAVA工具
categories: JAVA技术栈
---

# Maven简介
Apache Maven是一个软件（特别是Java软件）项目管理及自动构建工具，由Apache软件基金会所提供。基于项目对象模型（POM）概念，Maven利用一小段描述信息来管理一个项目的构建、报告和文档等。Maven也可被用于构建和管理各种项目，例如C#，Ruby，Scala和其他语言编写的项目。Maven曾是Jakarta项目的子项目，现为由Apache软件基金会主持的独立Apache项目。

备注：Maven同类别的工具有Ant以及gradle等。

# Windows平台下Maven的环境配置和搭建

（1）安装JDK并配置JAVA环境变量

（2）Apache Maven上下载二进制安装包，解压即可，不需要安装哦

（3）为Maven配置系统环境变量

首先新建环境变量M2_HOME，值为Maven的部署路径；然后修改系统PATH变量，增加%M2_HOME/bin

（4）测试验证

在Windows的cmd中输入`mvn -v`即可。

# Maven管理的项目的目录结构

```bash
|-src
    |-main
        |-java
            |-package #即用户的自己的代码，例如com.sohu.adslmon等
        |-resources   #存放一些配置文件或静态资源文件，如模板文件、静态图片等
            |-static
            |-templates
    |-test
        |-java
            |-package #即用户的自己的代码
        |-resources   #存放测试需要用到的一些配置文件或静态资源文件，如模板文件、静态图片等
            |-static
            |-templates
|-pom.xml     #Maven的项目管理配置文件
```

# 使用Maven进行项目开发的流程

（1）按照Maven项目的目录结构创建目录

（2）开发自己的代码

（3）新建pom.xml文件，并配置

（4）编译项目

cd到Maven项目根目录，然后执行`mvn compile`。

（5）执行单元测试

执行`mvn test`对项目进行单元测试，并生成测试报告。

（6）对项目进行打包

`mvn package`

# Maven中的一些概念

（1）坐标

坐标是由groupId，artifactId及version等组成。其中groupId为组织名，一般是“公司域名的反写+项目名”，例如com.sohu.adslmon。artifaceId为项目模块在组织中的标识，一般为“项目名-模块名”，例如adslmon-api。

（2）仓库

仓库分为本地仓库和远程仓库两个。

+ 本地仓库

本地仓库是开发者本地的仓库，本地仓库在本机的${user.home}/.m2/repository目录中，即编译我们的项目时，就会将依赖安装到该目录中哦。

+ 远程仓库

在本地仓库中若找不到对应的依赖，那么就会到maven的官方仓库中查找，然后下载到本地仓库中，供本地项目使用。maven中央仓库的地址为https://repo.maven.apache.org/maven2

（3）镜像仓库

maven的中央仓库是部署在国外的，国内访问有点慢。其实在国内有很多maven官方仓库的镜像仓库，我们可以将maven中央仓库修改为国内的镜像仓库，那么在安装依赖jar包就会快很多哦。具体可以在${MAVEN_HOME}/conf/settings.xml中设置。

# mvn常见的使用命令

```bash
mvn compile  #编译项目，会在项目的根目录生成的target目录及生成字节码文件
mvn test     #运行项目的测试用例
mvn package  #打包生成项目的jar文件
mvn clean    #删除编译生成class字节码文件以及项目jar文件等等，即mvn compile生成的target目录
mvn install  #安装项目jar包到本地仓库中，然后再其他项目中可以直接在pom.xml中引入该jar包
```

# 使用archetype插件创建maven项目的目录结构

```bash
cd workspace && mvn archetype:generate
```

或者如下：

```bash
cd worksapce && mvn archetype:generate -DgroupId=组织名（公司域名的反写+项目名） 
                                       -DartifactId=项目名-模块名 
                                       -Dversion=版本号 
                                       -Dpackage=代码所存在的包名
```

# pom.xml文件编写

pom.xml的完整的标签和结构如下：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                      http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
    <!-- The Basics -->
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
    <packaging>...</packaging>
    <dependencies>...</dependencies>
    <parent>...</parent>
    <dependencyManagement>...</dependencyManagement>
    <modules>...</modules>
    <properties>...</properties>
 
    <!-- Build Settings -->
    <build>...</build>
    <reporting>...</reporting>
 
    <!-- More Project Information -->
    <name>...</name>
    <description>...</description>
    <url>...</url>
    <inceptionYear>...</inceptionYear>
    <licenses>...</licenses>
    <organization>...</organization>
    <developers>...</developers>
    <contributors>...</contributors>
 
    <!-- Environment Settings -->
    <issueManagement>...</issueManagement>
    <ciManagement>...</ciManagement>
    <mailingLists>...</mailingLists>
    <scm>...</scm>
    <prerequisites>...</prerequisites>
    <repositories>...</repositories>
    <pluginRepositories>...</pluginRepositories>
    <distributionManagement>...</distributionManagement>
    <profiles>...</profiles>
</project>
```

如下为一个pom.xml配置文件的例子：

```xml
<project>
    <groupId>公司域名反写+项目名</groupId>
    <artifactId>项目名-模块名</artifactId>
    <version>版本号</version>
    <package>打包方式，默认为jar</package>
    <name>项目描述名</name>
    <url>项目地址</url>
    <description>项目描述信息</description>
    <developers>项目开发人员列表</developers>
    <licenses>许可证</licenses>
    <organization>组织描述信息</organization>
    <dependencies>
        <dependency>
            <groupId>第三方库groupId</groupId>
            <artifactId>第三方库artifactId</artifactId>
            <version>第三方库版本号</version>
        </dependency>
        <dependency>
        .....
        </dependency>
    </dependencies>
    <build>
        <plugins><plugin>插件引入<plugin></plugins>
    </build>
</project>
```

# 在Eclipse中配置Maven环境

（1）按照第2部分在windows本地安装maven工具

（2）在Eclipse中选择`Window | Preferences | Maven | Installations`中，选择add按钮，将本地maven的安装路径配置进去，如下：

![](/images/maven_1_1.png)

（3）如果需要的话，可以做一些Maven的用户设置，界面如下：

![](/images/maven_1_2.png)

# 在Eclipse中执行Maven命令

在使用Eclipse开发Maven项目时，可以右击项目，并选择Run As菜单项，会出现类似如下的菜单，

![](/images/maven_1_3.png)

![](/images/maven_1_4.png)

其中`Maven build...`是用来添加自定义的运行方法；`Maven build`可以使用指定的运行方法来运行项目，若添加了多个运行方法，点击`Maven build`时，会弹出一个可以选择运行方法的窗口。另外，在`Run Configurations...`中可以配置更多的运行方法哦。

学习资料参考于：
http://blog.csdn.net/u011939453/article/details/43017865

# Maven pom.xml中变量的使用

举例来说：

```
<properties>
  <spring.version>2.5</spring.version>
</properties>

<depencencies>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactid>spring-beans</artifactId>
    <version>${spring.version}</version>
  </dependency>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactid>spring-context</artifactId>
    <version>${spring.version}</version>
  </dependency>
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactid>spring-core</artifactId>
    <version>${spring.version}</version>
  </dependency>
</depencencies>
```

这里配置了一个`spring.version`的属性变量，然后通过`${spring.version}`来引用该变量，这样就避免了在多个地方配置版本号。

# Maven中dependency的scope作用域

+ test

表明该dependency在测试范围有效，在编译和打包时都不会使用这个依赖。

+ compile

表明该dependency在编译范围有效，在编译和打包时都会将依赖包含进去。

+ provided

在编译和测试的过程有效，最后生成war包时不会加入。以servlet-api依赖来说，tomcat等web服务器已经存在了，如果再打包会冲突 

+ runtime

在运行的时候依赖，在编译的时候不依赖 。

备注：若不指明dependency的scope，则默认的依赖范围是compile.

举例来说，如下为junit只在测试阶段使用该依赖，打包部署到生成环境时，则不会依赖junit包。

```
<depencencies>
  <dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>3.8.1</version>
  </dependency>
</depencencies>
```

# Maven Plugins

clean、compile、install等等都属于maven的插件，即maven自身其实很简单，主要的功能是有maven插件来完成的。

# 闲杂知识

（1）可以在`https://mvnrepository.com/`页面中搜索第三方JAVA库。

（2）使用maven构建Servlet WEB项目时，可以直接在pom.xml中引入jetty plugin，然后可以直接在jetty servlet容器中运行WEB项目了哦，开发测试非常方便。当然我们也可以引入tomcat plugin哦。

# Maven构建多模块项目

待学习

