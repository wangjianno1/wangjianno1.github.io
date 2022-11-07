---
title: 合并分支之Git Merge
date: 2022-11-06 01:39:23
tags: Git
categories: VCS
---

# 合并分支

Git合并分支有两种方式，一种是Git Merge，一种是Git Rebase。

# Git Merge

## Git Merge基本操作

假设存在fix和dev两个分支，现在要把fix分支合并到dev分支上。

若是在git命令行工具上操作，操作步骤如下：

```bash
git checkout dev #切换分支到dev分支上
git merge fix    #表示把fix分支的内容合并到当前分支（dev分支）上
```

若是在IDEA的Git面板中操作，先把当前分支切换到dev上，然后在fix分支右键选择Merge Selected into Current即可。合并过程可能会产生冲突，需要解决完冲突才能完成合并。

## Git Merge的Fast-Forward和Non Fast-Forward

一般说来，Git Merge执行之后，会在合并分支上额外产生一条“Merge branch 'xxx' github.com/yyy into xxx”的提交commit点，但是在Git Merge的Fast Forward（快进）模式下，是不会额外产生这条commit记录的。

（1）Fast-Forward适用场景正反例

如下图所示，bugfix分支是从master分支分叉出来的：

![](/images/git_merge_1_2.png)

此时，合并bugfix分支到master分支时，如果master分支的状态没有被更改过，那么这个合并是非常简单的。bugfix分支的历史记录包含master分支所有的历史记录，所以通过把master分支的位置移动到bugfix的最新分支上，Git就会合并。这样的合并被称为Fast-Forward（快进）合并。如下：

![](/images/git_merge_1_3.png)

但是，master分支的历史记录有可能在bugfix分支分叉出去后有新的更新。这种情况下，要把master分支的修改内容和bugfix分支的修改内容汇合起来。此种情形就适用不了Fast-Forward模式了。如下：

![](/images/git_merge_1_6.png)

因此，合并两个修改会生成一个提交点E。这时，master分支的HEAD会移动到该提交上。如下：

![](/images/git_merge_1_4.png)

（2）No Fast-Forward

执行合并时，如果设定了Non Fast-Forward选项（即`git merge --no-ff`），即使在能够Fast-Forward合并的情况下也会生成新的提交并合并。

![](/images/git_merge_1_5.png)

# Git Merge和Git Rebase区别

Git Merge会保留分支提交信息。Git Merge会创建一次Merge branch的commit信息。相比Git Merge，Git Rebase会将分支上的commit整合到当前分支上，让整个代码周期更为清晰。相比Git Merge，Git Rebase并不会产生多余的commit信息。

![](/images/git_merge_1_1.png)

在上图中，1是Git Rebase方式合并，2和3是Git Merge方式合并。

在项目实践中，选择用Git Rebase，还是Git Mrege，各有各的好处，取决于项目的规范要求。

# 一点闲杂

git pull默认使用merge的方式来合并代码，所以在Fast Forward不满足的情况下，git pull执行完后，将远程仓库的分支合并到本地分支上时，会在本地分支上产生一条“Merge branch xxxx”的提交记录。

学习资料参考于：
https://backlog.com/git-tutorial/cn/stepup/stepup1_4.html
