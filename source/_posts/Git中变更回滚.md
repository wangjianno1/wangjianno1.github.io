---
title: Git中变更回滚
date: 2022-11-06 01:58:02
tags: Git
categories: VCS
---

# 撤消工作区域中文件的修改

使用`git checkout -- [filename]`将工作区域中修改去掉，很危险哦，修改会丢失的哦。

备注：git status命令有操作提示。

# 取消被暂存的文件

使用`git reset HEAD <filename>`来取消被放到暂存区域的文件，然后重新放到工作目录。

备注：git status命令有操作提示。

# 合并重新提交

```bash
git commit -m 'initial commit'

# 此处做继续修改文件的操作
git add someotherfile.dat
git commit --amend
```

最终你只会有一个提交，第二次提交将代替第一次提交的结果，其实就是将两次提交合并成一个提交，使用git log只能看到一条提交记录。在使用git push可能需要-f参数，即git push origin branchname -f，否则push不成功。

备注：这个和Git Rebase第一个使用场景看着是一样的。

# 使用Git Reset回滚已经commit的内容

（1）Git Reset命令格式

    git reset [--soft | --mixed | --hard] commitid

soft模式会将被撤销的commit内容撤销至暂存区域。mixed模式时默认模式，会将被撤销的commit内容撤销至工作区域。hard模式比较危险，会将被撤销的commmit内容直接丢弃掉。commitid是要回滚到那次提交的commitid。

（2）实际操作案例

首先修改文件uuu.txt，并提交到本地仓库中，使用git log查看提交历史，假设我们想借助Git Reset命令回滚掉这次update uuu.txt的提交。

![](/images/git_rollback_1_1.png)

![](/images/git_rollback_1_2.png)

我们获取到update uuu.txt这次提交的上一次提交的commit id是77daad0a6b2d8dfeb0f364d8f4f2c0fe6dbca685。

接下来我们使用Git Reset的soft模式来回滚掉这次提交，操作如下：

![](/images/git_rollback_1_3.png)

![](/images/git_rollback_1_4.png)

通过上面的执行结果，我们看到update uuu.txt这次提交已经被回滚掉，文件的变更并没有丢失，而是被撤回到了暂存区域。

接下来我们再次把内容提交，然后使用Git Reset的mixed模式来回滚掉这次提交，操作如下：

![](/images/git_rollback_1_5.png)

![](/images/git_rollback_1_6.png)

通过上面的执行结果，我们看到update uuu.txt这次提交也已经成功被回滚掉，文件的变更也没有丢失，而是被撤回到了工作区域。

接下来我们把内容提交到暂存区，并在此提交内容，使用Git Reset的hard模式来回滚掉这次提交，操作如下：

![](/images/git_rollback_1_7.png)

![](/images/git_rollback_1_8.png)

通过上面的执行结果，我们看到update uuu.txt这次提交也已经成功被回滚掉，但是文件的变更已经被丢弃了。因此我们使用Git Reset的hard模式的一定要注意了哦。

（3）IDEA中的Git面板中使用Git Reset

在IDEA中，点击Git工具栏，切换到Log标签页，可以看到本地commit日志和远程commit日志，在指定commit上右键选择Reset Current Branch to Hear就可以以Git Reset的方式回滚到该commit上。

![](/images/git_rollback_1_9.png)

此时有四种回滚的模式，具体哪四种待研究，其中一种是Hard模式，若选择Hard模式，将会清除本地版本，强制回滚到指定commit状态，但是通过Git Reset是无法进行git push操作，因为本地的版本比远程版本要低，若要做push操作，可以强制push到远程分支，即使用`git push --force`或`git push -f`命令来push操作。

（4）若本地commit已经被push到远程仓库，想要使用Git Reset来回滚远程仓库中提交，会比较不好弄，也比较危险。首先在本地仓库使用Git Reset回滚，然后在push的时候，会提示push失败，此时要强制push，即force push。需要注意的是，force push是一种非常不好的习惯，除非你清楚的意识到force push带来的后果，不然千万不要执行force push。

# 使用Git Revert回滚已经commit的内容

（1）Git Revert命令格式

    git revert commitid

（2）实际操作案例

首先创建多次提交，如下：

![](/images/git_rollback_1_10.png)

![](/images/git_rollback_1_11.png)

假设我们现在回滚掉9786cfbe615ec6aa236fda5b4b3703043fed0500这次提交内容，操作如下：

![](/images/git_rollback_1_12.png)

![](/images/git_rollback_1_13.png)

从执行结果来看，Git Revert可以将指定commitid的提交内容抹掉（但是提交记录还存在），并重新提交了一个新的revert的commit。

（3）IDEA中的Git面板中使用Git Revert

Git Revert可以将指定的commit所做的修改全部撤销掉，而不影响其他commit的修改，假设我们有三个文件，分别为file1.txt，file2.txt，file3.txt，现在提交三个commit，三个commit分别如下：

    Commit1：向file1.txt中添加内容
    Commit2：向file2.txt中添加内容
    Commit3：向file3.txt中添加内容

![](/images/git_rollback_1_14.png)

现在我们在“Commit2：文件2修改”这个commit上面右键选择Revert Commit，这时候会弹出提交窗口，IDEA会自动提交一次新的commit，commit后我们发现文件2的内容没有了，也就是撤销了commit2修改的内容，commit后执行push操作就能推送到远程仓库了，因为是生成了新的commit，所以无需force push就能提交到远程仓库。

（4）若本地commit已经被push到远程仓库，想要使用Git Revert来回滚远程仓库中提交，会比较不好弄，也比较危险。首先在本地仓库使用Git Revert回滚，然后在push的时候，会提示push失败，此时要强制push，即force push。需要注意的是，force push是一种非常不好的习惯，除非你清楚的意识到force push带来的后果，不然千万不要执行force push。

# Git Reset和Git Revert不同

假设我们提交了三次commit，如下：

    commit1 -> commit2 -> commit3

如果使用Git Reset回滚到commit2，那么commit2之后的所有修改都会被丢弃，也就是把commit2之后的commit全部砍掉了，提交历史git log会变成如下：

    commit1 -> commit2 

如果使用Git Revert回滚掉commit2（注意是回滚掉，与Git Revert的回滚到，是有区别的，Git Revert能回滚掉指定的commit），则有点像UNDO，会把commit2做的操作反做一遍，也就是UNDO，并且生成一个新的commit，提交历史git log会变成如下：

    commit1 -> commit2 -> commit3 -> commit4

# 重要TIPS

不管使用`--amend`合并commit，还是使用Git Reset/Rebase回滚已经commit的内容，有一点必须要知道：若这些被操作或修改的commit还未被push到远程仓库，那么本地仓库操作完，直接push到远程仓库就好了；若这些被操作或修改的commit已经被push到远程仓库了，那么本地操作完，是push不成功的，若要push只能使用force push，但是这个操作风险极高，不知道对远程操作带来的实际影响，就不要去force push。
