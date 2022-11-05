---
title: Git中一些闲杂知识
date: 2022-11-06 02:21:46
tags: Git
categories: VCS
---

# 使用Git/GitHub的过程

（1）github.com申请账号并登陆

（2）创建repository

有两种方式，一种是自己创建一个项目，新创建的repository中一般会默认包括README.md, LICENSE, .gitignore这些文件。另一种方式是fork其他人的仓库。

（3）在Linux等开发机上安装git工具。

（4）使用ssh-keygen工具在开发机上生成公钥和私钥。并将公钥添加到Github account中。

ssh-keygen的工具使用参见[《linux下使用ssh-keygen生成公钥私钥对》](https://blog.csdn.net/wangjianno2/article/details/48402745)

![](/images/git_bkm_1_1.png)

因为开发机和Github通信是需要加密的，所以要将开发机的公钥告诉给Github。

（5）在本地执行git clone `https://github.com/***/***.git`来将远程仓库中的代码克隆到本地。

（6）在工作目录中修改文件，或新增文件

（7）使用git add -A命令将已修改的文件，放置到暂存区域，等待提交

（8）使用git commit -m "xxxxx"命令提交更新，找到暂存区域的文件，将快照提交到本地git仓库目录

（9）git push xxxx yyyy将本地仓库推送到远程仓库。备注xxxx是用git remote add为远程仓库设置的别名，yyyy是远程仓库的某分支的名称。

（10）提交Pull Request，申请将自己的修改合并到别人的仓库代码中

# gitignore的使用

在Git进行项目代码的版本管理时，有时我们项目中会产生一些临时的文件，例如Python中的*.pyc，Java中的*.class等等。Git提供了机制来忽略这些文件，具体操作步骤如下：

（1）在项目的根目录中添加.gitignore文件

（2）然后将我们需要忽略的文件写入到该文件中

例如要忽略到`*.pyc`文件，我们可以在.gitignore文件中增加一行内容，如下：

    *.pyc

（3）将.gitignore提交到仓库中。

写入到.gitignore的一些文件类型，将不会被git进行版本控制。另外关于.gitignore的设置，在`https://github.com/github/gitignore`中已经有了常见的设置模板，可以拿来复用。

备注：另外，添加到.gitignore中被忽略的特殊文件，如果直接使用git add会提示被忽略错误，这时可以使用git add -f强制add。而且我们可以使用git check-ignore -v filename命令来检查文件filename被.gitignore中的哪条规则所匹配。

# Git钩子hooks设置

Git提供了4个提交工作流钩子，分别是pre-commit、prepare-commit-msg、commit-msg以及post-commit。从字面上可以猜测到这四个hook分别对应“commit之前”、“准备commit log message的时候”、“生成commit log message的时候”、“commit之后”这四个触发时机。这四个hook也的确是按照这个先后顺序被触发的。如果git commit时使用了-n（等价于--no-verify）参数的话，pre-commit和commit-msg就不会被触发。

本质来说，pre-commit、prepare-commit-msg、commit-msg以及post-commit这四个钩子，就是存在.git/hooks目录下相同名称的四个脚本文件。

# Git本地分支和远程分支追踪关系

一般来说，Git会自动在本地分支与远程分支之间，建立一种追踪关系（tracking）。比如，在git clone的时候，所有本地分支默认与远程主机的同名分支，建立追踪关系，也就是说，本地的master分支自动追踪origin/master分支，本地的develop分支自动追踪origin/develop分支。

当然，Git也允许手动建立本地分支和远程分支的追踪关系，命令如下：

```bash
git branch --set-upstream master origin/next #表示指定本地master分支追踪远程origin/next分支
```

有了追踪关系，会有一些好处。如果当前分支与远程分支存在追踪关系，git push/git pull等命令就可以省略本地分支或远程分支的名称了，如git push origin develop命令中虽然省略掉了远程分支的名称，但是有了默认追踪关系的存在，该命令会把本地的develop分支推送到远程origin/develop同名分支上去。

# Git传输协议

Git支持多种数据传输协议。是通过git clone [url]后面的url来决定的。url有如下几种形式：

（1）本地协议，是本地和远程共用一个共享的文件系统。例如克隆的时候url可以为git clone /opt/git/project.git或者git clone file:///opt/git/project.git

（2）git://  表示使用的git自己的协议

（3）http(s):// 表示使用的是http协议

（4）user@server:/path.git 表示使用的是SSH传输协议

备注：SSH是其中唯一一个支持读和写操作的网络协议。而HTTP和Git通常都是只读的。所以虽然二者大多数都可用，但执行写操作的时候还是需要SSH。

