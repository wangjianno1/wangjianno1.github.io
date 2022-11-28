---
title: Git管理员操作手册
date: 2022-11-06 00:55:22
tags: Git
categories: VCS
---

# 代码提交

```bash
git add -A             #将未被git管理的文件加入跟踪，将本地已修改的文件提交到暂存区，或者执行git add .也一样
git commit -m "xxxxxx" #将本地暂存区中的修改，提交到本地仓库中
git pull origin main   #从远程仓库origin的main分支获取最新版本并merge到本地仓库
git push origin master #把本地仓库中当前分支的内容b，向远程仓库推送提交
```

备注：push之前，commit之后，一定要记得pull一下，有冲突解决冲突，没冲突更好。注意pull动作不能放到commit之前，因为pull过来的内容可能会覆盖掉你已经修改，但是还未commit到本地仓库中内容。

# 分支操作

```bash
git branch -a #查看本地仓库以及远程仓库上所有的分支，记得先执行下git fetch --all一下
git branch    #查看本地仓库中的所有分支，有星号*的是当前分支，这里面看不到远程仓库中的其他分支哦
git checkout branch_name    #从当前分支切换到名称为branch_name的分支上去
git checkout -b branch_name #在本地仓库创建一个新分支，并切换到新仓库中，相当于git branch branch_name和git checkout branch_name两个命令的结合
git branch branch_name      #在本地仓库创建一个名称为branch_name的分支
git branch -d branch_name或git branch -D branch_name #删除本地仓库中某一个分支
```

# 提交历史

```bash
git log       #查看当前分支的提交历史
git log -2    #查看当前分支的最近两次的提交记录
git log -p    #查看当前分支提交记录及每次的提交的diff
git log -p -2 #查看当前分支最近两次的提交记录及diff内容
git log --pretty=format:"%h %s" #只显示commitid和提交说明
git log --graph                 #以图表的方式展示分支及分支合并的历史
git log --graph --pretty=oneline --abbrev-commit       #图形化展示提交历史，这个很好用哦，类似于一些Git图形化工具，如IDEA的Git面板中log展示，执行前最好git fetch origin xxx一下
git log --graph --pretty=oneline --abbrev-commit --all #图形化展示所有本地和远程仓库的提交历史，执行前最好git fetch --all一下
```

![](/images/git_handbook_1_1.png)

查看远程仓库的最新提交记录：

```bash
# 方法一
git fetch origin develop && git log origin/develop #查看远程仓库的提交记录，要先执行fetch，否则看到不是远程仓库最新的状态。需要注意的是，这里执行git log develop也是看不到远程仓库最新提交记录

# 方法二
git pull && git log develop
```

备注：使用git log命令，可以看到git为每次提交生成一个长串，这个就是commitid，是git根据每次提交的内容通过SHA1计算出来的哈希串。一般来说，这个commitid很长，其实我们取前面一部分短串使用就好了。还有一点说明的是，git log执行时，不管是看本地仓库某分支还是远程仓库的提交log，都不会去远程仓库中获取提交记录，都是从本地存好的数据中解析出来。因此git log查看远程仓库的提交记录时，一般要git fetch一下。

# git push使用

命令格式如下：

    git push <remote> <local branch name>:<remote branch to push into>  #这里的<remote>是远程仓库的缩写名称，可以使用git remote -v查看

```bash
git push origin develop:master #把本地仓库的develop分支推送到远程仓库的master分支上
git push origin HEAD:master    #将当前分支推送到远程仓库origin的master分支上
git push origin :master #相当于push一个空分支到远程仓库的master分支中，也就是删除远程仓库的master分支
git push origin master  #此处省略了远程仓库的分支名称，则表示将本地仓库中指定分支推动到远程仓库的同名分支上，若远程仓库中不存在同名的仓库，那么会在远程仓库上新建一个同名的分支。此处相当于git push origin master:master
git push origin         #表示将当前分支推送到远程仓库origin相同的分支上，若只有一个origin远程仓库，那么直接写git push也行啦
```

# git pull使用

git pull用于从远程仓库的分支下载代码变更，并合并本地仓库的分支上。git pull其实就是git fetch和git merge。需要注意的是，git pull默认合并分支使用的是Git Merge，我们也可以通过参数修改成使用Git Rebase的方式来合并分支。我的理解，若`git pull --rebase`这种形式执行，如git pull相当于是git fetch和git rebase。git pull命令格式如下：

    git pull <remote> <remote branch name>:<local branch to merge into>

```bash
git pull origin master:develop #将远程仓库origin的master分支拉取过来，与本地仓库的develop分支合并
git pull origin master         #省略本地仓库分支，该命令表示从远程仓库拉取master分支内容，并于本地仓库的当前分支（HEAD）合并（此例子中并不一定表示合并到本地master分支哦）
git pull origin   #表示从远程仓库中拉取于当前分支同名的远程分支，并合并到本地仓库当前分支中
git pull          #同git pull origin
git pull --rebase #使用Git Rebase方式合并远程分支代码到本地，这种方式可以避免产生一条额外的“Merge branch xxx”的commit，且导致git log历史分叉
```

# git fetch使用

git fetch命令，从远程仓库中下载代码变更，但是不会于本地的代码合并。若需要合并，需要再执行git merge命令来合并。

```bash
git fetch origin #获取远程仓库所有分支的代码变更
git fetch --all  #获取远程所有分支的代码变更
git fetch origin develop #获取远程仓库develop分支中的所有内容
```

# git配置用户信息

使用git config配置个人的用户名称和电子邮件地址。这两条配置很重要，每次Git提交时都会引用这两条信息，说明是谁提交了更新，所以会随更新内容一起被永久纳入历史记录。

（1）全局配置

```bash
git config --global user.name "John Doe"
git config --global user.email "johndoe@example.com"
```

如果使用了`--global`选项，用户姓名及邮箱就配置在用户主目录下的`~/.gitconfig`文件中，以后所有的项目都会默认使用这里配置的用户信息。

（2）局部git项目配置

```bash
git config user.name "John Doe"
git config user.email "johndoe@example.com"
```

如果要在某个特定的项目中使用其他名字或者电邮，只要去掉`--global`选项重新配置即可，新的设定保存在当前项目的`.git/config`文件里。

# git设置代理服务器

（1）设置代理

```bash
git config --global http.proxy http://10.16.20.12:3128
git config --global https.proxy https://10.16.20.12:3128
```

（2）取消代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

# 其他命令

```bash
git status #查看文件的状态信息，这个命令要经常执行，会给一些有用的提示。有时执行git status时，提示Your Branch is up to date with 'origin/xxxxx'，即和远程仓库是一致的，其实并不准，需要git fetch或git pull一下，才能获取到远程仓库这个分支的最新状态
git remote #查看远程仓库名，或git remote -v，命令输出远程仓库的缩写名称（一般默认就叫origin），以及远程仓库的资源地址
git remote add [remote-name] [url]来添加远程仓库，之后就可以用remote-name这个别名来指代url这个远程仓库了
git tag  #打标签
git diff #用来查看某个文件在不同状态时的差异
git rm   #移除文件
git mv   #移动文件
git init #创建一个空的本地仓库
```
