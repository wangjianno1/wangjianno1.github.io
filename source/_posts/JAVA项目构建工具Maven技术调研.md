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
            |-package #即用户的自己的代码，例如com.baidu.xxoomon等
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

坐标是由groupId，artifactId及version等组成。其中groupId为组织名，一般是“公司域名的反写+项目名”，例如com.baidu.xxoomon。artifaceId为项目模块在组织中的标识，一般为“项目名-模块名”，例如xxoomon-api。

（2）仓库

仓库分为本地仓库和远程仓库两个。

+ 本地仓库

本地仓库是开发者本地的仓库，本地仓库在本机的${user.home}/.m2/repository目录中，即编译我们的项目时，就会将依赖安装到该目录中哦。

+ 远程仓库

在本地仓库中若找不到对应的依赖，那么就会到maven的官方仓库中查找，然后下载到本地仓库中，供本地项目使用。maven中央仓库的地址为https://repo.maven.apache.org/maven2

（3）镜像仓库

maven的中央仓库是部署在国外的，国内访问有点慢。其实在国内有很多maven官方仓库的镜像仓库，我们可以将maven中央仓库修改为国内的镜像仓库，那么在安装依赖jar包就会快很多哦。具体可以在`${MAVEN_HOME}/conf/settings.xml`中设置，即在该配置文件的mirrors标签中添加如下内容：

```xml
<mirror>
    <id>alimaven</id>
    <name>aliyun maven</name>
    <url>https://maven.aliyun.com/repository/public</url>
    <mirrorOf>central</mirrorOf>
</mirror>
<mirror>
    <id>alimaven-central</id>
    <name>aliyun maven central</name>
    <url>https://maven.aliyun.com/repository/central</url>
    <mirrorOf>central</mirrorOf>
</mirror>
```

# mvn常见的使用命令

```bash
mvn compile  #编译项目，会在项目的根目录生成的target目录及生成字节码文件
mvn test     #运行项目的测试用例
mvn package  #打包生成项目的jar文件
mvn clean    #删除编译生成class字节码文件以及项目jar文件等等，即删除由mvn compile命令生成的target目录
mvn install  #安装项目jar包到本地仓库中，然后再其他项目中可以直接在pom.xml中引入该jar包
```

备注：这里是`mvn [options] [<phase(s)>]`的命令执行格式。

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
    <packaging>打包方式，默认为jar</packaging>
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

# Maven pom.xml中变量properties的使用

通过`<properties>`元素用户可以自定义一个或多个Maven属性，然后在POM的其他地方使用`${属性名}`的方式引用该属性，这种做法的最大意义在于消除重复和统一管理。Maven总共有6类属性，内置属性、POM属性、自定义属性、Settings属性、java系统属性和环境变量属性：

（1）内置属性

有两个常用内置属性，`${basedir}`表示项目跟目录，即包含pom.xml文件的目录；`${version}`表示项目版本。

（2）POM属性

用户可以使用该类属性引用POM文件中对应元素的值。如${project.artifactId}就对应了<project> <artifactId>元素的值，常用的POM属性包括：

```
${project.build.sourceDirectory}     #项目的主源码目录，默认为src/main/java/
${project.build.testSourceDirectory} #项目的测试源码目录，默认为src/test/java/
${project.build.directory}     #项目构建输出目录，默认为target/
${project.outputDirectory}     #项目主代码编译输出目录，默认为target/classes/
${project.testOutputDirectory} #项目测试主代码输出目录，默认为target/testclasses/
${project.groupId}    #项目的groupId
${project.artifactId} #项目的artifactId
${project.version}    #项目的version,与${version} 等价
${project.build.finalName} #项目打包输出文件的名称，默认为${project.artifactId}-${project.version}
```

（3）自定义属性

用户可以自定义一些属性，举例来说：

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

备注：这里配置了一个`spring.version`的属性变量，然后通过`${spring.version}`来引用该变量，这样就避免了在多个地方配置版本号。

（4）Settings属性

与POM属性同理，用户使用以`settings.`开头的属性引用`settings.xml`文件中的XML元素的值。

（5）Java系统属性

所有java系统属性都可以用Maven属性引用，如`${user.home}`指向了用户目录。

（6）环境变量属性

所有环境变量属性都可以使用以`env.`开头的Maven属性引用，如`${env.JAVA_HOME}`指代了`JAVA_HOME`环境变量的的值。

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
    <scope>test</scope>
  </dependency>
</depencencies>
```

# Maven生命周期与插件

## Maven的生命周期与插件关系

一个完整的项目构建过程通常包括清理、编译、测试、打包、集成测试、验证、部署等步骤，Maven从中抽取了一套完善的、易扩展的生命周期。Maven中的生命周期是一个抽象概念，并没有实际的实现。而具体任务是由插件来完成。

## Maven生命周期

Maven定义了三套生命周期，分别是clean、default以及site。每个生命周期又包含了很多的阶段（phase）。三套生命周期相互独立，互不影响。但各个生命周期中的phase却是有执行顺序的，后面的phase依赖于前面的phase。执行某个phase时，其前面的phase会依顺序执行，但不会触发另外两套生命周期中的任何phase。

（1）clean生命周期

clean生命周期的各个阶段phase如下：

    pre-clean  #执行清理前的工作
    clean      #清理上一次构建生成的所有文件
    post-clean #执行清理后的工作

（2）default生命周期

default生命周期是最核心的，它包含了构建项目时真正需要执行的所有步骤。其各个阶段phase如下：

    validate
    initialize
    generate-sources
    process-sources
    generate-resources
    process-resources  #复制和处理资源文件到target目录，准备打包
    compile            #编译项目的源代码；
    process-classes
    generate-test-sources
    process-test-sources
    generate-test-resources
    process-test-resources
    test-compile       #编译测试源代码；
    process-test-classes
    test        #运行测试代码；
    prepare-package
    package     #打包成jar或者war或者其他格式的分发包；
    pre-integration-test
    integration-test
    post-integration-test
    verify
    install     #将打好的包安装到本地仓库，供其他项目使用；
    deploy      #将打好的包安装到远程仓库，供其他项目使用；

（3）site生命周期

    pre-site
    site        #生成项目的站点文档
    post-site
    site-deploy #发布生成的站点文档

备注：上面的各个生命周期的每个阶段都是Maven从工程实践中抽象出来的一个流程概念，Maven本身并没有对每个phase要完成的具体工作去编写工具。而这个实际完成工作的工具正是下面介绍的插件。

## Maven插件

Maven的核心文件很小，主要的任务都是由插件来完成。进入`%本地仓库%\org\apache\maven\plugins`，可以看到一些下载好的插件如下：

![](/images/maven_1_5.png)

Maven官网上提供了很多官方插件，开发者也可以自己开发自定义Maven插件。一些插件可以完成多种功能，则每一种功能称为该插件的一个目标goal，如maven-compiler-plugin插件不仅可以编译项目业务代码，也可以编译项目的测试代码，因此它至少有compile和testcompile两个goal。

Maven的插件是通过`groupId:artifactId:version`这种形式来定位的，和普通的Maven JAR是一样的。当要显示指定某个插件的某一goal时，就需要用到`groupId:artifactId:version:goal`这样的形式。如`org.apache.maven.plugins:maven-help-plugin:2.1`就是定位了一个插件，但是从用户使用上看是有些不方便的，因为一般的groupId、artifactId都会很长，字符太多。 所以就发明了目标前缀的概念，其实就是给`groupId:artifactId:version`起了一个简短的别名而已。比如，上面的`org.apache.maven.plugins:maven-help-plugin:2.1`插件的目标前缀是help，我们在使用的使用时候直接用`help:2.1`就可以啦。

## Maven生命周期的阶段和插件的目标绑定

Maven的生命周期是抽象的，实际工作需要插件来完成，这一过程是通过将插件的目标（goal）绑定到生命周期的具体阶段（phase）来完成的。如将maven-compiler-plugin插件的compile目标绑定到default生命周期的compile阶段，完成项目的源代码编译：

![](/images/maven_1_6.png)

Maven对一些生命周期的阶段（phase）默认绑定了插件的目标，所以我们不用在pom.xml中配置大量的生命周期和插件的绑定关系。当然用户可以根据需要将任何插件目标绑定到任何生命周期的阶段，如将maven-source-plugin的jar-no-fork目标绑定到default生命周期的package阶段，这样以后在执行mvn package命令打包项目时，在package阶段之后会执行源代码打包。

## Maven执行命令和生命周期以及插件是怎么关联起来的

Maven的命令执行格式为：

```
mvn [options] [<goal(s)>] [<phase(s)>]
```

其中options是执行mvn命令的一些选项参数。`[<goal(s)>]`和`[<phase(s)>]`代表了mvn的两种不同的执行方式。

（1）`mvn [options] [<phase(s)>]`

这种形式其实就是我们使用最多的形式，如`mvn clean`，`mvn package`，`mvn clean package`等等。这里面是phase就是Maven生命周期的各个阶段phase。当我们执行`mvn xxxphase`时，maven首先判断xxxphase是属于哪个生命周期，确定了之后，从该生命周期的第一个phase开始按顺序依次执行到xxxphase。如`mvn package`，首先判断出package属于default生命周期，然后依次执行default生命周期的validate、initialize、generate-sources、process-sources、generate-resources、process-resources、compile、process-classes、generate-test-sources、process-test-sources、generate-test-resources、processtest-resources、test-compile、process-test-classes、test、prepare-package以及package阶段。

（2）`mvn [options] [<goal(s)>]`

这里的goal就是插件中目标的概念，这与maven定义的生命周期没有什么关系，也就是不会像执行`mvn [options] [<phase(s)>]`那样，从一个生命周期的第一个phase开始执行。`mvn [options] [<goal(s)>]`表示直接在maven项目中执行某个插件的指定的目标goal。如`mvn archetype:generate`表示生成一个Maven项目结构，`mvn checkstyle:check`表示检查代码风格。

# Maven中profile多环境配置概念和应用

在开发过程中，我们的软件会面对不同的运行环境，比如开发环境、测试环境、生产环境，而我们的软件在不同的环境中，有的配置可能会不一样，比如数据源配置、日志文件配置、以及一些软件运行过程中的基本配置，那每次我们将软件部署到不同的环境时，都需要修改相应的配置文件，这样来回修改，很容易出错，而且浪费劳动力。Maven提供了一种方便的解决这种问题的方案，就是profile功能。profile可以让我们定义一系列的配置信息，然后指定其激活条件。这样我们就可以定义多个profile，然后每个profile对应不同的激活条件和配置信息，从而达到不同环境使用不同配置信息的效果。假设我们的Maven工程有开发、测试和生产环境的配置，在打包项目时，我们期望在不同环境可以使用不同的配置文件。具体配置方法如下：

（1）为不同环境建立相应的配置文件

![](/images/maven_1_7.png)

（2）在项目pom.xml添加如下三个profile配置

```xml
<profiles>
    <profile>
        <id>local</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <profiles.proj.env>local</profiles.proj.env>
        </properties>
    <profile>
        <id>test</id>
        <properties>
            <profiles.proj.env>test</profiles.proj.env>
        </properties>
    </profile>
    <profile>
        <id>production</id>
        <properties>
            <profiles.proj.env>production</profiles.proj.env>
        </properties>
    </profile>
</profiles>
```

其中profiles.proj.env是我们自定义的一个变量，名字可以随便取。

（3）在项目pom.xml中使用我们自定义的profiles.proj.env变量

我们可以在pom.xml中加入如下resources配置：

```xml
<resources>
    <resource>
        <directory>src/main/resources/${profiles.proj.env}</directory>
   </resource>
</resources>
```

（4）执行mvn命令针对不同的环境打包

```bash
mvn package -Plocal      #为开发环境打包，会将src/main/resources/${profiles.proj.env}替换成src/main/resources/local，从而加载开发环境的配置
mvn package -Ptest       #为测试环境打包，会将src/main/resources/${profiles.proj.env}替换成src/main/resources/test，从而加载测试环境的配置
mvn package -Pproduction #为生成环境打包，会将src/main/resources/${profiles.proj.env}替换成src/main/resources/production，从而加载生成环境的配置
```

需要注意的是，在pom.xml的profile的`<activeByDefault>true</activeByDefault>`表示默认激活的是local，也就是直接执行`mvn package`将会开发环境打包。

# Maven构建多模块项目

## Maven多模块项目简介

Maven 3支持Maven项目的多模块（multi-modules）结构。这样的Maven项目也被称为聚合项目，通常由一个父模块和若干个子模块构成。所有用mavan管理的项目最好都是分模块的，每个模块对应着一个pom.xml，他们之间继承和聚合互相关联。划分模块后，导入Eclipse变成了N个项目，这会带来复杂度，给开发带来不便，那为什么还要用呢？原因有以下几点：

（1）方便复用，如app-common这些模块可以渐渐进化成一个基础公共类，供所有项目使用，这是模块化最重要的一个目的

（2）由于你划分了模块，每个模块的配置都在各自的pom.xml，不用再到一个纷繁复杂的pom中寻找自己的配置

（3）如果你只是在app-common上工作，你不需要build整个项目，只要在app-common目录运行mvn命令即可，这样可以节省时间，尤其是当项目很庞大，build越来越耗时的时候

（4）某些模块，如app-common被很多人依赖，但你不想给所有人修改，完全可以把app-common拿出来做成另一个项目，只提供jar包，没有修改权限

## 一个简单的Maven多模块项目结构

一个简单的Maven多模块项目结构如下：

```
|-xxoo
    |-xxoo-common
        |-pom.xml(jar)
    |-xxoo-utils
        |-pom.xml(jar)
    |-xxoo-core
        |-pom.xml(jar)
    |-xxoo-web
        |-pom.xml(war)
    |-pom.xml(pom)
```

在上图中，有一个父项目（xxoo）聚合很多子模块（xxoo-common、xxoo-utils、xxoo-core以及xxoo-web）。每个项目或模块都含有一个pom.xml文件，需要注意的是，小括号中标出了每个项目的打包类型。父项目是pom，也必须是pom。子项目有jar或war，根据模块的功能来决定。父模块xxoo必须以pom打包类型，同时以`<modules>`给出所有的子模块，如下：

```xml
...
<groupId>com.bat.sysadmin</groupId>
<artifactId>xxoo</artifactId>
<version>1.0.0</version>
<packaging>pom</packaging>
<modules>
    <module>xxoo-common</module>
    <module>xxoo-utils</module>
    <module>xxoo-core</module>
    <module>xxoo-web</module>
</modules>
...
```

## 使用Eclipse创建Maven多模块项目

（1）创建一个父项目xxoo

`new->project->maven->maven project`，点击下一步，选择项目原型maven-archetype-site-simple，配置在groupid和artifactid，完成之后，在Eclipse会生成一个项目。在pom.xml中将packaging修改为pom，同时将xxoo中src目录删除，父项目xxoo主要功能是管理其他子项目，本身并不用写代码，所以只保留一个pom.xml就可以了。

（2）创建子模块xxoo-common，xxoo-utils以及xxoo-core

在项目xxoo上点击右键，选择`new->project->maven->maven module`，填写module name，比如xxoo-common点击下一步， 在选择模块原型为maven-archetype-quickstart，确定后生成xxoo-common项目。创建xxoo-utils以及xxoo-core同xxoo-common过程一样，这里忽略。

（3）创建子模块xxoo-web

xxoo-web是个web应用模块，在项目xxoo上点击右键，选择`new->project->maven->maven module`，填写module name为xxoo-web，点击下一步， 再选择模块原型为maven-archetype-webapp，确定后生成xxoo-web项目。

通过上面的操作后，在Eclipse的Package Explorer中会展示如下的项目结构：

![](/images/maven_1_8.png)

在Eclipse中xxoo-common、xxoo-utils、xxoo-core以及xxoo-web单独的Project是虚拟出来的，其实在本地磁盘的目录结构如下：

![](/images/maven_1_9.png)

备注：在Eclipse IDE中多模块项目，一般来说，我们将聚合项目折叠起来，如xxoo。而是到Eclipse虚拟出来的工程中去编辑具体的子模块。当然在xxoo聚合模块，还是子模块中编辑开发，在两边都会有体现的啦。另外，在创建子模块时，注意package结构。

## Maven聚合、继承及二者区别

（1）Maven聚合

在一个要聚合多个模块的Maven工程pom.xml中，配置如下内容：

```xml
<groupId>com.bat</groupId>
<artifactId>xxoo</artifactId>
<packaging>pom</packaging>
<modules>
    <module>xxoo-common</module>
    <module>xxoo-utils</module>
    <module>xxoo-core</module>
    <module>xxoo-web</module>
</modules>
```

通过上述配置后，xxoo就对xxoo-common、xxoo-utils、xxoo-core以及xxoo-web进行了聚合，这样在打包时，各个项目会同时打包。

（2）Maven继承

在子模块的pom.xml中，配置如下内容：

```xml
<parent>  
    <groupId>com.bat</groupId>
    <artifactId>xxoo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
</parent>
```

若子项目不在父项目的目录中，那么还需要`<relativePath></relativePath>`标签来配置相对路径。通过继承的应用，各个子项目会继承很多父项目pom.xml中的配置，更合理方便的管理各个子项目的第三方jar包依赖问题。

（3）Maven继承和聚合的关系

虽然聚合通常伴随着继承关系，但是这两者不是必须同时存在的，实际上在Maven中聚合（多模块）和继承是两回事，两者不存在直接联系。继承是Maven中很强大的一种功能，继承可以使得子POM可以获得parent中的各项配置，可以对子pom进行统一的配置和依赖管理，父POM是为了抽取统一的配置信息和依赖版本控制，方便子POM直接引用，简化子POM的配置。聚合（多模块）则是为了方便一组项目进行统一的操作而作为一个大的整体，所以要真正根据这两者不同的作用来使用，不必为了聚合而继承同一个父POM，也不比为了继承父POM而设计成多模块。

## 在一个子模块需要使用到另一个子项目的类

假设xxoo-web需要用到xxoo-common中的工具类，那么需要在xxoo-web的pom.xml中加入如下依赖：

```xml
<dependency>
    <groupId>com.bat</groupId>
    <artifactId>xxoo-common</artifactId>
    <version>0.0.1-SNAPSHOT</version>
</dependency>
```

那么在`maven package`子模块xxoo-web时，就会将xxoo-common的jar包xxoo-common-0.0.1-SNAPSHOT.jar，拷贝一份到xxoo-web的`target/xxoo-web/WEB-INF/lib`下，这样就会像使用第三方JAR包一样使用我们自己开发的JAR包模块啦。

## Maven+SpringBoot项目多模块管理的最佳实践

模块的拆分有两种方式，

（1）按照MVC分层结构来拆分模块，结构如下：

```
|-xxoo
    |-xxoo-common
        |-pom.xml(jar)
    |-xxoo-controller
        |-pom.xml(war)
    |-xxoo-service
        |-pom.xml(jar)
    |-xxoo-dao
        |-pom.xml(jar)
    |-pom.xml(pom)
```

（2）按照业务逻辑结构来拆分模块，结构如下：

```
|-xxoo
    |-xxoo-common
        |-pom.xml(jar)
    |-xxoo-order
        |-pom.xml(war)
    |-xxoo-accout
        |-pom.xml(war)
    |-xxoo-pay
        |-pom.xml(war)
    |-pom.xml(pom)
```

网络上的一个项目结构参考如下：

![](/images/maven_1_10.png)

在实际的工程实践中，一定要注意，xxoo-common是一个抽离出来的工具库，其他模块会引用xxoo-common，假设xxoo-order依赖xxoo-common，因为xxoo-common是xxoo的子模块，maven继承了xxoo的pom.xml中的配置，那其实xxoo-common也是一个SpringBoot的项目，如果在xxoo的pom.xml中有如下的配置：

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```

那么xxoo-common也会继承这个配置，那么SpringBoot工程编译打包时，xxoo-common会生成两种jar包，一种是普通的jar，另一种是可执行jar。默认情况下，这两种jar的名称相同，在不做配置的情况下，普通的jar先生成，可执行jar后生成，造成可执行jar会覆盖普通的jar。而xxoo-order无法依赖xxoo-common工程的可执行jar，所以编译打包时，xxoo-order就会报出“程序包com.baidu.xxoo.common不存在”失败。当前想到的解决方式是把插件spring-boot-maven-plugin的配置挪到xxoo-order中，这样xxoo-common就不会继承到spring-boot-maven-plugin的插件。xxoo-common仅仅是一个普通的工具包，我们并不想编译成可执行的包哦。

# 其他闲杂知识

## 关于`<packaging>...</packaging>`使用

packaging指明项目打包的格式，目前支持的格式有pom，jar，maven-plugin，ejb，war，ear，rar，par等，若不显式指定packaging，则缺省的packaging格式为jar。

若packaging指定为pom，则该Maven工程不会打包出任何东西。不像jar/war等，会打包出jar包或war包。

## 关于dependencyManagement与dependencies

当我们的项目有很多模块组成时，我们往往会在父类项目的pom.xml中看到dependencyManagement配置，通过dependencyManagement元素来管理jar包的版本，让子项目中引用一个依赖而不用显示的列出版本号。Maven会沿着父子层次向上走，直到找到一个拥有dependencyManagement元素的项目，然后它就会使用在这个dependencyManagement元素中指定的版本号。

这样做便于统一管理项目的版本号，确保应用的各个项目的依赖和版本一致，才能保证测试的和发布的是相同的成果，因此，在顶层pom.xml中定义共同的依赖关系。同时可以避免在每个使用的子项目中都声明一个版本号，这样想升级或者切换到另一个版本时，只需要在父类容器里更新，不需要任何一个子项目的修改；如果某个子项目需要另外一个版本号时，只需要在dependencies中声明一个版本号即可。子类就会使用子类声明的版本号，不继承于父类版本号。

在父项目的pom.xml中可能会看到`<dependencyManagement><dependencies></dependencies></dependencyManagement>`，也会直接看到`<dependencies></dependencies>`。它们的区别如下：

（1）dependencies即使在子项目中不写该依赖项，那么子项目仍然会从父项目中继承该依赖项（全部继承）

（2）dependencyManagement里只是声明依赖，并不实现引入，因此子项目需要显示的声明需要用的依赖。如果不在子项目中声明依赖，是不会从父项目中继承下来的；只有在子项目中写了该依赖项，并且没有指定具体版本，才会从父项目中继承该项，并且version和scope都读取自父pom；另外如果子项目中指定了版本号，那么会使用子项目中指定的jar版本。

## Maven pom.xml中resources配置的概念和使用

构建Maven项目的时候，如果没有进行特殊的配置，Maven会按照标准的目录结构查找和处理各种类型文件。举例来说：

`src/main/java`和`src/test/java`这两个目录中的所有`*.java`文件会分别在comile和test-comiple阶段被编译，编译结果分别放到了`target/classes`和`targe/test-classes`目录中，但是这两个目录中的其他文件都会被忽略掉。

`src/main/resouces`和`src/test/resources`这两个目录中的文件也会分别被复制到`target/classes`和`target/test-classes`目录中。

打包插件默认会把`target/classes`这个目录中的所有内容打入到jar包或者war包中。

resources代表了Maven的资源文件，是项目中要使用的文件，代码在执行的时候会到指定位置去查找这些文件。前面已经说了Maven默认的处理方式，但是有时候我们需要进行自定义配置。比如说，有时候有些配置文件通常与`*.java`文件一起放在`src/main/java`目录（如Mybatis或Hibernate的表映射文件）。有的时候还希望把其他目录中的资源也复制到classes目录中。有的时候我们需要排除`src/main/resouces`下某下配置文件。这些情况下就需要在pom.xml文件配置resource啦。

举例来说：

```xml
<resources>
    <resource>
        <directory>src/main/resources</directory>
        <!-- 资源根目录排除各环境的配置，使用单独的资源目录来指定 -->
        <excludes>
            <exclude>local/*</exclude>
            <exclude>test/*</exclude>
            <exclude>production/*</exclude>
        </excludes>
    </resource>
    <resource>
        <directory>src/main/resources/template</directory>
    </resource>
<resources>
```

## 第三方库查找

可以在`https://mvnrepository.com/`页面中搜索第三方JAVA库。

## jetty/tomcat插件

使用maven构建Servlet WEB项目时，可以直接在pom.xml中引入jetty plugin，然后可以直接在jetty servlet容器中运行WEB项目了哦，开发测试非常方便。当然我们也可以引入tomcat plugin哦。

学习资料参考于：
https://www.cnblogs.com/luotaoyeah/p/3819001.html
https://maven.apache.org/run.html
https://blog.csdn.net/liutengteng130/article/details/46991829
https://www.cnblogs.com/pixy/p/4798089.html
https://www.cnblogs.com/0201zcr/p/6262762.html
https://blog.csdn.net/jrainbow/article/details/50546524
http://www.blogways.net/blog/2013/05/13/maven-multi-modules-demo.html
