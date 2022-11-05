---
title: 合并分支之Git Rebase
date: 2022-11-06 01:19:06
tags: Git
categories: VCS
---

# Git Rebase变基介绍

Rebase在Git中是一个非常有魅力的命令，使用得当会极大提高自己的工作效率。相反，如果乱用，会给团队中其他人带来麻烦。它的作用简要概括为，可以对某一段线性提交历史进行编辑、删除、复制、粘贴。因此，合理使用Rebase命令可以使我们的提交历史干净、简洁。

简单来说，变基就是，先确定变基分支和目标变基分支共同祖先的那一次提交，然后变基分支会将共同祖先后最开始的一次提交的parent修改指向，指向目标变基分支的最新的一次提交。

# Git Rebase使用场景之合并多个commit

Git Rebase的一种使用场景就是用来合并多个commit为一个完整commit。当我们在本地仓库中提交了多次，在我们把本地提交push到公共仓库中之前，为了让提交记录更简洁明了，我们希望把如下分支B、C、D三个提交记录合并为一个完整的提交，然后再push到公共仓库。

需要注意的是，是在本地仓库多次提交，但是还未被push到远程仓库中，使用Git Rebase功能对本地仓库的commit历史进行合并调整等。对于已经push到远程仓库中的多次提交，也是可以用git rebase来合并多次提交的，只是最后push到远程仓库时，要force push到远程仓库才可以。

![](/images/git_rebase_1_1.png)

假设本地仓库的rebase分支下当前的提交历史如下：

![](/images/git_rebase_1_2.png)

此时我们需要合并第1～3条提交记录。我们执行如下格式的命令：

    git rebase -i [startpoint] [endpoint]

其中`-i`的意思是`--interactive`，即弹出交互式的界面让用户编辑完成合并操作，`[startpoint]`和`[endpoint]`则指定了一个编辑区间，如果不指定`[endpoint]`，则该区间的终点默认是当前分支HEAD所指向的commit（注：该区间指定的是一个前开后闭的区间）。

具体到我们这个例子，就是执行如下命令：

```bash
git rebase -i 825241aa0 #或执行git rebase -i HEAD~3也是可以的
```

然后我们会看到如下界面：

![](/images/git_rebase_1_3.png)

上面未被注释的部分列出的是我们本次rebase操作包含的所有提交，下面注释部分是git为我们提供的命令说明。每一个commit id前面的pick表示指令类型，git为我们提供了以下几个命令：

    * pick：保留该commit（缩写:p）
    * reword：保留该commit，但我需要修改该commit的注释（缩写:r）
    * edit：保留该commit, 但我要停下来修改该提交(不仅仅修改注释)（缩写:e）
    * squash：将该commit和前一个commit合并（缩写:s）
    * fixup：将该commit和前一个commit合并，但我不要保留该提交的注释信息（缩写:f）
    * exec：执行shell命令（缩写:x）
    * drop：我要丢弃该commit（缩写:d）

根据我们的需求，我们将commit内容编辑如下：

![](/images/git_rebase_1_4.png)

然后是注释修改界面：

![](/images/git_rebase_1_5.png)

编辑完保存即可完成commit的合并了：

![](/images/git_rebase_1_6.png)

本地仓库合并完成之后，考虑到推送到远程仓库。若合并之前，本地的多次commit并未被push到远程仓库，那这里直接使用git push origin rebase即可将合并后的内容push到远程仓库。若合并之前，本地的多次commit已经被push到远程仓库，这是使用git push origin rebase则会提示如下错误：

![](/images/git_rebase_1_7.png)

此处若想push成功，必须使用force push才可以，如下：

![](/images/git_rebase_1_8.png)

# Git Rebase使用场景之合并分支

假设一个代码仓有master和experiment两个分支，其当前的git log内容如下图，现在要将feature分支的内容合并到master分支中。

![](/images/git_rebase_1_9.png)

如果我们要使用git rebase来完成这个任务的话，其操作命令如下：

```bash
git checkout experiment
git rebase master #将experiment分支变基到master分支上
```

git rebase master这条命令的执行原理需要特别说明下，它的原理是首先找到这两个分支（即当前分支experiment 、变基操作的目标基底分支master）的最近共同祖先C2 ，然后对比当前分支（即experiment分支）相对于该祖先C2的历次提交，把这些提交抽离出来并存为临时文件，然后将当前分支（即experiment分支）指向目标基底C3，最后再将临时文件中的各个提交依序在experiment分支上应用。执行完成上面的任务后，git log内容如下图：

![](/images/git_rebase_1_10.png)

如果再有需求，要把experiment分支的内容合并到master上来，则需要再执行一个merge操作。首先回到master分支，再进行一次快进合并。即执行如下命令：

```bash
git checkout master
git merge experiment
```

执行完之后，master分支中已经有了experiment分支的，而experiment分支中也包含了master中C3。git log内容如下图：

![](/images/git_rebase_1_11.png)

# 一点闲杂

关于使用Git Rebase，将某个分支上的一段commit合并到另一个分支上，还有更复杂的场景如下：

![](/images/git_rebase_1_12.png)

这时候我们用到的git rebase的命令格式如下：

    git rebase [startpoint] [endpoint] --onto [branchName]

其中，`[startpoint]`和`[endpoint]`仍然和git merge命令中的一样，指定了一个编辑区间（还是需要注意，这是一个前开后闭的区间），`--onto`表示是要将该指定的提交复制到哪个分支上。这部分具体实例，等后续遇到再研究，再把内容补充进来。

