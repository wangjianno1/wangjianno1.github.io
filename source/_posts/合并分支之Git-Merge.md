---
title: 合并分支之Git Merge
date: 2022-11-06 01:39:23
tags: Git
categories: VCS
---

# 合并分支

Git合并分支有两种方式，一种是Git Merge，一种是Git Rebase。

# Git Merge操作

假设存在fix和dev两个分支，现在要把fix分支合并到dev分支上。

若是在git命令行工具上操作，操作步骤如下：

```bash
git checkout dev #切换分支到dev分支上
git merge fix    #表示把fix分支的内容合并到当前分支（dev分支）上
```

若是在IDEA的Git面板中操作，先把当前分支切换到dev上，然后在fix分支右键选择Merge Selected into Current即可。合并过程可能会产生冲突，需要解决完冲突才能完成合并。

# Git Merge和Git Rebase区别

Git Merge会保留分支提交信息。Git Merge会创建一次Merge branch的commit信息。相比Git Merge，Git Rebase会将分支上的commit整合到当前分支上，让整个代码周期更为清晰。相比Git Merge，Git Rebase并不会产生多余的commit信息。

![](/images/git_merge_1_1.png)

在上图中，1是Git Rebase方式合并，2和3是Git Merge方式合并。

在项目实践中，选择用Git Rebase，还是Git Mrege，各有各的好处，取决于项目的规范要求。
